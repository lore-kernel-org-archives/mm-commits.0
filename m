From: akpm@linux-foundation.org
Subject: +
 mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
 added to -mm tree
Date: Tue, 07 Jun 2016 13:41:42 -0700
Message-ID: <57573186.LGt4MrWkR8/aEwvA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbcFGUln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2016 16:41:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes

WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
#155: FILE: mm/readahead.c:111:
+		struct list_head *pages, unsigned nr_pages, gfp_t gfp_mask)

WARNING: line over 80 characters
#165: FILE: mm/readahead.c:129:
+		if (!add_to_page_cache_lru(page, mapping, page->index, gfp_mask)) {

WARNING: braces {} are not necessary for single statement blocks
#165: FILE: mm/readahead.c:129:
+		if (!add_to_page_cache_lru(page, mapping, page->index, gfp_mask)) {
 			mapping->a_ops->readpage(filp, page);
 		}

total: 0 errors, 3 warnings, 111 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-memcg-use-consistent-gfp-flags-during-readahead.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/readahead.c~mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes mm/readahead.c
--- a/mm/readahead.c~mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes
+++ a/mm/readahead.c
@@ -108,7 +108,7 @@ int read_cache_pages(struct address_spac
 EXPORT_SYMBOL(read_cache_pages);
 
 static int read_pages(struct address_space *mapping, struct file *filp,
-		struct list_head *pages, unsigned nr_pages, gfp_t gfp_mask)
+		struct list_head *pages, unsigned int nr_pages, gfp_t gfp)
 {
 	struct blk_plug plug;
 	unsigned page_idx;
@@ -126,9 +126,8 @@ static int read_pages(struct address_spa
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
 		struct page *page = lru_to_page(pages);
 		list_del(&page->lru);
-		if (!add_to_page_cache_lru(page, mapping, page->index, gfp_mask)) {
+		if (!add_to_page_cache_lru(page, mapping, page->index, gfp))
 			mapping->a_ops->readpage(filp, page);
-		}
 		put_page(page);
 	}
 	ret = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

