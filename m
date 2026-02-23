Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184F1340A70;
	Mon, 23 Feb 2026 18:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771872609; cv=none; b=eiDTBvcwHnEqz/Md87qUkM5WH70fgEM6ZRhwhTcZZr2cSj083+c7wvxCHhYfB7cwIwpLZkp47Z+kQUP5uIZ2wflw2ORXBQR4BcEahpXcBgAIQqDrA5nC31YYnG8APPBww2G6MBbVkF0OKYgnT0e0Z7y9ZD/AO3wDgRx98m5O4Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771872609; c=relaxed/simple;
	bh=ukyuMxUgLxto9SzZ68PU/qK5aUnk+AhNYMr3Eyt2U10=;
	h=Date:To:From:Subject:Message-Id; b=g7MPE6fyACrkCBjU2sZu6EJBMl0ilTAWEb+FZUngedG3WT+BiZrPJwa82S/AtwbtenJc/NqpF2NJJkDOusOs7zoY0JhXa6bU2S729+Bi1ONSSLKbJ8Ay2/0mb0QG0dz9zOJ9Kn6kxLkMCJMEmchHr3U0c1TIFq/wGU0nXW2xiVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bb72rv7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bb72rv7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83943C116C6;
	Mon, 23 Feb 2026 18:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771872608;
	bh=ukyuMxUgLxto9SzZ68PU/qK5aUnk+AhNYMr3Eyt2U10=;
	h=Date:To:From:Subject:From;
	b=Bb72rv7byrBhriXJ78AmVcoY240FQ9SBsN+GksGRwrUmJSnk7r4Tqd2nvoYnHQ7c4
	 SSFAO0UAhCBuTatTb/yGZ3gar3eb5KZpS8K79BG2pqCAQ8FgVNPnKo3Y19UdLynJ+P
	 lhHOXs/oP+uou4ZxOk4dA/gNdW3S4qkeolbG0jeI=
Date: Mon, 23 Feb 2026 10:50:07 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-always-make-all-folios-uptodate.patch added to mm-hotfixes-unstable branch
Message-Id: <20260223185008.83943C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memfd_luo: always make all folios uptodate
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memfd_luo-always-make-all-folios-uptodate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd_luo-always-make-all-folios-uptodate.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: mm: memfd_luo: always make all folios uptodate
Date: Mon, 23 Feb 2026 18:39:28 +0100

Patch series "mm: memfd_luo: fixes for folio flag preservation".

This series contains a couple fixes for flag preservation for memfd live
update.

The first patch fixes memfd preservation when fallocate() was used to
pre-allocate some pages.  For these memfds, all the writes to fallocated
pages touched after preserve were lost.

The second patch fixes dirty flag tracking.  If the dirty flag is not
tracked correctly, the next kernel might incorrectly reclaim some folios
under memory pressure, losing user data.  This is a theoretical bug that I
observed when reading the code, and haven't been able to reproduce it.


This patch (of 2):

When a folio is added to a shmem file via fallocate, it is not zeroed on
allocation.  This is done as a performance optimization since it is
possible the folio will never end up being used at all.  When the folio is
used, shmem checks for the uptodate flag, and if absent, zeroes the folio
(and sets the flag) before returning to user.

With LUO, the flags of each folio are saved at preserve time.  It is
possible to have a memfd with some folios fallocated but not uptodate. 
For those, the uptodate flag doesn't get saved.  The folios might later
end up being used and become uptodate.  They would get passed to the next
kernel via KHO correctly since they did get preserved.  But they won't
have the MEMFD_LUO_FOLIO_UPTODATE flag.

This means that when the memfd is retrieved, the folios will be added to
the shmem file without the uptodate flag.  They will be zeroed before
first use, losing the data in those folios.

Since we take a big performance hit in allocating, zeroing, and pinning
all folios at prepare time anyway, take some more and zero all
non-uptodate ones too.

Later when there is a stronger need to make prepare faster, this can be
optimized.

To avoid racing with another uptodate operation, take the folio lock.

Link: https://lkml.kernel.org/r/20260223173931.2221759-2-pratyush@kernel.org
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-always-make-all-folios-uptodate
+++ a/mm/memfd_luo.c
@@ -152,10 +152,31 @@ static int memfd_luo_preserve_folios(str
 		if (err)
 			goto err_unpreserve;
 
+		folio_lock(folio);
+
 		if (folio_test_dirty(folio))
 			flags |= MEMFD_LUO_FOLIO_DIRTY;
-		if (folio_test_uptodate(folio))
-			flags |= MEMFD_LUO_FOLIO_UPTODATE;
+
+		/*
+		 * If the folio is not uptodate, it was fallocated but never
+		 * used. Saving this flag at prepare() doesn't work since it
+		 * might change later when someone uses the folio.
+		 *
+		 * Since we have taken the performance penalty of allocating,
+		 * zeroing, and pinning all the folios in the holes, take a bit
+		 * more and zero all non-uptodate folios too.
+		 *
+		 * NOTE: For someone looking to improve preserve performance,
+		 * this is a good place to look.
+		 */
+		if (!folio_test_uptodate(folio)) {
+			folio_zero_range(folio, 0, folio_size(folio));
+			flush_dcache_folio(folio);
+			folio_mark_uptodate(folio);
+		}
+		flags |= MEMFD_LUO_FOLIO_UPTODATE;
+
+		folio_unlock(folio);
 
 		pfolio->pfn = folio_pfn(folio);
 		pfolio->flags = flags;
_

Patches currently in -mm which might be from pratyush@kernel.org are

liveupdate-luo_file-remember-retrieve-status.patch
mm-memfd_luo-always-make-all-folios-uptodate.patch
mm-memfd_luo-always-dirty-all-folios.patch
memfd-export-memfd_addget_seals.patch
mm-memfd_luo-preserve-file-seals.patch
kho-move-alloc-tag-init-to-kho_init_foliopages.patch

