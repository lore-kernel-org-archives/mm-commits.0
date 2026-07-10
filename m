Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053131DC98F
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 02:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783650538; cv=none; b=XGOuyfD6z2uDKVeZM6Hcktst9yHLHLn0K117NLb/JzPNa/OJvevnAyPtqsd1XqQLEAWiU+V2IPBIn7eq93R8RHBhgajEcDom8NEgswamv4uNLiDKxg2xI6iMBHwn33t//EqPmhRRVL2a0QbsOtkbLjUxBkFaXxtdNgUsSUgof0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783650538; c=relaxed/simple;
	bh=oIsj/B1+2+AWMiiT+QQ+CdWaNJUI7ibxzLtpYTJGoRQ=;
	h=Date:To:From:Subject:Message-Id; b=EKcXZRMOwLQRERIVZebfaq7zi7C3CLwYK6A60CtyfIKOv104o+DBk/IgxWHjf5MK6vQrPMRSgcqMsNzPaBqXVVIJ8exlwy0eatTOEfTv6jBhTUerjzwHP7jDyskZxZEYA8DElWPO7fiC6xv+T1lDmBzx8m1V1USqwuQkzgx3p+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oqQQipSM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oqQQipSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2021F000E9;
	Fri, 10 Jul 2026 02:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783650536;
	bh=M+JJfX0eM7ykwf2+IVxuhuFr+RdTSHxPdf/Ik4Ji4wQ=;
	h=Date:To:From:Subject;
	b=oqQQipSMvBJvoqLg0BTeOnsIolvawDosjHK7/Ky4YbTe1sK/RnEeQn+lL/9RCyDkp
	 lExYFI8GcetyvC66zwqLdtTygHkcrdPqczIz6/3JZBbTueKKhjjGkVg8U1TE3z9XJ+
	 7iAk9eBtwSED79F58wAmiwa45/OZJpI3m8AXIOMA=
Date: Thu, 09 Jul 2026 19:28:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sougupta@nvidia.com,david@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-fix-gup-fast-fallback-for-null-mapping-order-0-folios.patch added to mm-new branch
Message-Id: <20260710022856.6B2021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: fix GUP-fast fallback for NULL-mapping order-0 folios
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-fix-gup-fast-fallback-for-null-mapping-order-0-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-fix-gup-fast-fallback-for-null-mapping-order-0-folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: fix GUP-fast fallback for NULL-mapping order-0 folios
Date: Tue, 7 Jul 2026 17:57:45 -0700

Since commit f002882ca369 ("mm: merge folio_is_secretmem() and
folio_fast_pin_allowed() into gup_fast_folio_allowed()"),
gup_fast_folio_allowed() falls back to the slow path for any order-0 folio
with a NULL mapping when CONFIG_SECRETMEM=y.  This causes a performance
regression for drivers that allocate pages with alloc_page() and insert
them into VMAs via vm_insert_page().  These pages legitimately have a NULL
folio->mapping, but they cannot be secretmem pages.

Secretmem pages are always added to the secretmem inode's page cache via
filemap_add_folio(), which sets folio->mapping to the inode's i_mapping. 
A folio with a NULL mapping can never be a secretmem folio.  The
NULL-mapping check was intended to handle truncated file-backed pages (a
reject_file_backed concern), not secretmem detection.

When only check_secretmem is true (and reject_file_backed is false), a
NULL mapping is sufficient to prove the folio is not secretmem, so the
fast path can proceed.

Link: https://lore.kernel.org/20260708005745.164928-1-jhubbard@nvidia.com
Fixes: f002882ca369 ("mm: merge folio_is_secretmem() and folio_fast_pin_allowed() into gup_fast_folio_allowed()")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Tested-by: Sourab Gupta <sougupta@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-gup-fix-gup-fast-fallback-for-null-mapping-order-0-folios
+++ a/mm/gup.c
@@ -2784,12 +2784,17 @@ static bool gup_fast_folio_allowed(struc
 	mapping = READ_ONCE(folio->mapping);
 
 	/*
-	 * The mapping may have been truncated, in any case we cannot determine
-	 * if this mapping is safe - fall back to slow path to determine how to
-	 * proceed.
+	 * If the mapping is NULL (truncated, or never set), we cannot
+	 * determine whether the folio is file-backed, so a long-term writable
+	 * pin must fall back to the slow path.
+	 *
+	 * Otherwise, a NULL mapping proves this is not a secretmem folio
+	 * (secretmem folios always have a valid mapping to the secretmem
+	 * inode's address_space), so in that case, we can continue with the
+	 * fast path.
 	 */
 	if (!mapping)
-		return false;
+		return !reject_file_backed;
 
 	/* Anonymous folios pose no problem. */
 	mapping_flags = (unsigned long)mapping & FOLIO_MAPPING_FLAGS;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-fix-gup-fast-fallback-for-null-mapping-order-0-folios.patch

