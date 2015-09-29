From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
 added to -mm tree
Date: Tue, 29 Sep 2015 14:09:25 -0700
Message-ID: <560afe05.PHJyI8VloQZN6Dd7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbbI2VJ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 17:09:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch

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
Subject: mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes

WARNING: line over 80 characters
#110: FILE: drivers/block/drbd/drbd_bitmap.c:1010:
+		page = mempool_alloc(drbd_md_io_page_pool, __GFP_HIGHMEM|__GFP_RECLAIM);

WARNING: line over 80 characters
#139: FILE: drivers/block/nvme-core.c:1039:
+		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen, __GFP_RECLAIM);

WARNING: line over 80 characters
#466: FILE: include/linux/gfp.h:110:
+#define __GFP_RECLAIM ((__force gfp_t)(___GFP_DIRECT_RECLAIM|___GFP_KSWAPD_RECLAIM))

ERROR: code indent should use tabs where possible
#547: FILE: kernel/power/swap.c:978:
+^I^I           __get_free_page(__GFP_RECLAIM | __GFP_HIGH);$

ERROR: code indent should use tabs where possible
#557: FILE: kernel/power/swap.c:1245:
+^I^I                                  __GFP_RECLAIM | __GFP_HIGH :$

ERROR: code indent should use tabs where possible
#558: FILE: kernel/power/swap.c:1246:
+^I^I                                  __GFP_RECLAIM | __GFP_NOWARN |$

WARNING: line over 80 characters
#570: FILE: lib/percpu_ida.c:138:
+ * used for internal memory allocations); thus if passed __GFP_RECLAIM we may sleep

ERROR: code indent should use tabs where possible
#596: FILE: mm/failslab.c:19:
+        if (failslab.ignore_gfp_reclaim && (gfpflags & __GFP_RECLAIM))$

WARNING: please, no spaces at the start of a line
#596: FILE: mm/failslab.c:19:
+        if (failslab.ignore_gfp_reclaim && (gfpflags & __GFP_RECLAIM))$

WARNING: line over 80 characters
#617: FILE: mm/filemap.c:2717:
+ * this page (__GFP_IO), and whether the call may block (__GFP_RECLAIM & __GFP_FS).

total: 4 errors, 6 warnings, 463 lines checked

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/swap.c |    8 ++++----
 mm/failslab.c       |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/power/swap.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes kernel/power/swap.c
--- a/kernel/power/swap.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes
+++ a/kernel/power/swap.c
@@ -975,7 +975,7 @@ static int get_swap_reader(struct swap_m
 		last = tmp;
 
 		tmp->map = (struct swap_map_page *)
-		           __get_free_page(__GFP_RECLAIM | __GFP_HIGH);
+			   __get_free_page(__GFP_RECLAIM | __GFP_HIGH);
 		if (!tmp->map) {
 			release_swap_reader(handle);
 			return -ENOMEM;
@@ -1242,9 +1242,9 @@ static int load_image_lzo(struct swap_ma
 
 	for (i = 0; i < read_pages; i++) {
 		page[i] = (void *)__get_free_page(i < LZO_CMP_PAGES ?
-		                                  __GFP_RECLAIM | __GFP_HIGH :
-		                                  __GFP_RECLAIM | __GFP_NOWARN |
-		                                  __GFP_NORETRY);
+						  __GFP_RECLAIM | __GFP_HIGH :
+						  __GFP_RECLAIM | __GFP_NOWARN |
+						  __GFP_NORETRY);
 
 		if (!page[i]) {
 			if (i < LZO_CMP_PAGES) {
diff -puN mm/failslab.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes mm/failslab.c
--- a/mm/failslab.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes
+++ a/mm/failslab.c
@@ -16,7 +16,7 @@ bool should_failslab(size_t size, gfp_t
 	if (gfpflags & __GFP_NOFAIL)
 		return false;
 
-        if (failslab.ignore_gfp_reclaim && (gfpflags & __GFP_RECLAIM))
+	if (failslab.ignore_gfp_reclaim && (gfpflags & __GFP_RECLAIM))
 		return false;
 
 	if (failslab.cache_filter && !(cache_flags & SLAB_FAILSLAB))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
memcg-make-mem_cgroup_read_stat-unsigned-fix.patch
drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

