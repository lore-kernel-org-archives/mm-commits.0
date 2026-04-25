Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6CC37F8BD
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 22:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777154498; cv=none; b=oe+OhoVV7cVcoH7H51plLNGqy3W3JSVZnbd9g9fxSTzI4TGBEhdhkJCH1nsSxEjXJ9YdoPs63HfiBw79SaOac2Jkg8bxRGdviiSH5jweJm3ND5ncIunMa6VMEGj7/JSbO4PEvWuX7cR6MvmE+vOSmBQcQ2FWae7YZnCwmx5OalY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777154498; c=relaxed/simple;
	bh=dh5HLITTFQ1XaOs8A8UGFaCOb1b53PyWRmQiAt+VY64=;
	h=Date:To:From:Subject:Message-Id; b=nWPyB9cBmc08wfOv/KQxkrOWlu1oTOK/FtA5WlEWBx0r2AD30AWK24pCK5VNno+o/pi4ANUrV/xifDOJ86/SYcKdwnSCM4rp4HJ9jUYewZ39FTpp/+WDIB2CJ+BbvMprMaRm5y9BvKG0x+tjd4cIUuGgysgYWX/o6VS74WJyy4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ywxJl8Sm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ywxJl8Sm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C127C2BCB5;
	Sat, 25 Apr 2026 22:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777154498;
	bh=dh5HLITTFQ1XaOs8A8UGFaCOb1b53PyWRmQiAt+VY64=;
	h=Date:To:From:Subject:From;
	b=ywxJl8SmOvv4ci+92CePBa2ABKVgUhke7HVvBfaBIyrwVZ+Vaim55JIqmYJ3X1L5a
	 Qhfr7LnkaDvKtM2tdbIzlVORyP7BDKpHQLvt85VwKwIoVOMbnwo9sUBqF34BT/OxTE
	 VSkf6QQ0STq+hOXOdKXrwyJNFpPbtSxRj+0/cLhU=
Date: Sat, 25 Apr 2026 15:01:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-remove-read_only_thp_for_fs-check-fix.patch added to mm-new branch
Message-Id: <20260425220138.7C127C2BCB5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-khugepaged-remove-read_only_thp_for_fs-check-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-remove-read_only_thp_for_fs-check-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-remove-read_only_thp_for_fs-check-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-khugepaged-remove-read_only_thp_for_fs-check-fix
Date: Sat Apr 25 02:54:04 PM PDT 2026

fix arm64 allnoconfig by uninlining mapping_pmd_thp_support()

In file included from ./include/linux/mm.h:31,
                 from fs/inode.c:9:
./include/linux/pagemap.h: In function 'mapping_pmd_thp_support':
./include/linux/pgtable.h:8:26: error: 'PMD_SHIFT' undeclared (first use in this function); did you mean 'PUD_SHIFT'?
    8 | #define PMD_ORDER       (PMD_SHIFT - PAGE_SHIFT)
      |                          ^~~~~~~~~
./include/linux/pagemap.h:521:52: note: in expansion of macro 'PMD_ORDER'
  521 |         return mapping_max_folio_order(mapping) >= PMD_ORDER;
      |                                                    ^~~~~~~~~
./include/linux/pgtable.h:8:26: note: each undeclared identifier is reported only once for each function it appears in
    8 | #define PMD_ORDER       (PMD_SHIFT - PAGE_SHIFT)
      |                          ^~~~~~~~~
./include/linux/pagemap.h:521:52: note: in expansion of macro 'PMD_ORDER'
  521 |         return mapping_max_folio_order(mapping) >= PMD_ORDER;
      |                                                    ^~~~~~~~~
make[3]: *** [scripts/Makefile.build:289: fs/inode.o] Error 1
make[2]: *** [scripts/Makefile.build:548: fs] Error 2
make[1]: *** [/usr/src/25/Makefile:2139: .] Error 2
make: *** [Makefile:248: __sub-make] Error 2

Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    9 +--------
 mm/filemap.c            |    8 ++++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/include/linux/pagemap.h~mm-khugepaged-remove-read_only_thp_for_fs-check-fix
+++ a/include/linux/pagemap.h
@@ -513,14 +513,7 @@ static inline bool mapping_large_folio_s
 	return mapping_max_folio_order(mapping) > 0;
 }
 
-static inline bool mapping_pmd_thp_support(const struct address_space *mapping)
-{
-	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
-	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
-
-	return mapping_max_folio_order(mapping) >= PMD_ORDER;
-}
-
+bool mapping_pmd_thp_support(const struct address_space *mapping);
 
 /* Return the maximum folio size for this pagecache mapping, in bytes. */
 static inline size_t mapping_max_folio_size(const struct address_space *mapping)
--- a/mm/filemap.c~mm-khugepaged-remove-read_only_thp_for_fs-check-fix
+++ a/mm/filemap.c
@@ -126,6 +126,14 @@
  *    ->private_lock		(zap_pte_range->block_dirty_folio)
  */
 
+bool mapping_pmd_thp_support(const struct address_space *mapping)
+{
+	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
+	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
+
+	return mapping_max_folio_order(mapping) >= PMD_ORDER;
+}
+
 static void page_cache_delete(struct address_space *mapping,
 				   struct folio *folio, void *shadow)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch
mm-khugepaged-remove-read_only_thp_for_fs-check-fix.patch
mm-page_owner-add-numa-node-filter-with-nodelist-support-fix.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch
proc-rewrite-next_tgid-fix.patch

