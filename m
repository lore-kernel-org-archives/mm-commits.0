Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C354C92;
	Wed,  4 Mar 2026 17:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646297; cv=none; b=s37l/x9qVduSItKO2/x2OY8cZUCWNBXP/f/UFxOc2lCjdYNoFTEz/8UMXcPnVfyycxGN87Q1ZVyqjDwo7rK9n5xp7D4r+YZS4VEVYPbhpNYLgcMkMctMTmygKp5QctHdXY/ftEG0w59euE6wUacVj+rNKAQoe/8QPSQ8B0N56HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646297; c=relaxed/simple;
	bh=FD3LxfIFQIFg+xDndyA9rWjBA4t0P9x/m2dTRBkD8pY=;
	h=Date:To:From:Subject:Message-Id; b=onE4u9E4eN7Oy5CQ2XRKrzCzVeSogZeFWKLmwHdv/9Q1DvsYUiyZ9QyomeC0MGpqo4gx3oJLEjTKyNsdQCIp2JTSUieUy9K/oX0WXqRiEs0pluIKXyPMxirmp99TrVixlzOuwQosaNhzlrTZsCvUeyXbI44wySHVyM2ht9AC9HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZRjwrdkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZRjwrdkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06657C4CEF7;
	Wed,  4 Mar 2026 17:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772646297;
	bh=FD3LxfIFQIFg+xDndyA9rWjBA4t0P9x/m2dTRBkD8pY=;
	h=Date:To:From:Subject:From;
	b=ZRjwrdkl5HBNvfBzrYf4yPQkIWWDRT8Z+9s2oMZnQ3UTHssR+qr41u8Em5+oUhK4d
	 BEgcIGqa20nKtm+ab3gEUM6xKtewZaBXAsKZFJhzOy0Lj+YXATdnmA9JMhqbloWLNi
	 qxye3/2I04uhNYQJS68NAtGgfu55M8w4JHHszd74=
Date: Wed, 04 Mar 2026 09:44:56 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memfd_luo-always-make-all-folios-uptodate.patch removed from -mm tree
Message-Id: <20260304174457.06657C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memfd_luo: always make all folios uptodate
has been removed from the -mm tree.  Its filename was
     mm-memfd_luo-always-make-all-folios-uptodate.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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

memfd-export-memfd_addget_seals.patch
mm-memfd_luo-preserve-file-seals.patch
kho-move-alloc-tag-init-to-kho_init_foliopages.patch

