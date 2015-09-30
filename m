From: akpm@linux-foundation.org
Subject: +
 page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch added to
 -mm tree
Date: Wed, 30 Sep 2015 16:03:14 -0700
Message-ID: <560c6a32.dGYCqH00H3vdVMoq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914AbbI3XDP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 19:03:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fs-obey-gfp_mapping-for-add_to_page_cache-fix
has been added to the -mm tree.  Its filename is
     page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch

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
Subject: mm-fs-obey-gfp_mapping-for-add_to_page_cache-fix

fix fs/cifs/file.c

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/cifs/file.c~page-flags-define-pg_locked-behavior-on-compound-pages-fix fs/cifs/file.c
--- a/fs/cifs/file.c~page-flags-define-pg_locked-behavior-on-compound-pages-fix
+++ a/fs/cifs/file.c
@@ -3391,13 +3391,13 @@ readpages_get_pages(struct address_space
 	 * should have access to this page, we're safe to simply set
 	 * PG_locked without checking it first.
 	 */
-	__set_page_locked(page);
+	__SetPageLocked(page);
 	rc = add_to_page_cache_locked(page, mapping,
 				      page->index, gfp);
 
 	/* give up if we can't stick it in the cache */
 	if (rc) {
-		__clear_page_locked(page);
+		__ClearPageLocked(page);
 		return rc;
 	}
 
@@ -3418,9 +3418,9 @@ readpages_get_pages(struct address_space
 		if (*bytes + PAGE_CACHE_SIZE > rsize)
 			break;
 
-		__set_page_locked(page);
+		__SetPageLocked(page);
 		if (add_to_page_cache_locked(page, mapping, page->index, gfp)) {
-			__clear_page_locked(page);
+			__ClearPageLocked(page);
 			break;
 		}
 		list_move_tail(&page->lru, tmplist);
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
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
linux-next-rejects.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch

