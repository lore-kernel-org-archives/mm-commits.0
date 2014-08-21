From: akpm@linux-foundation.org
Subject: + prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
 added to -mm tree
Date: Thu, 21 Aug 2014 15:51:40 -0700
Message-ID: <53f677fc.wRCusxPK5iocqT28%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:43469 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbaHUWvm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 18:51:42 -0400
Received: by mail-qg0-f73.google.com with SMTP id i50so727551qgf.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 15:51:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gorcunov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix
has been added to the -mm tree.  Its filename is
     prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch

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
Subject: prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix

fix 80-col wordwrap in macro definitions

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN kernel/sys.c~prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix kernel/sys.c
--- a/kernel/sys.c~prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix
+++ a/kernel/sys.c
@@ -1703,15 +1703,15 @@ static int validate_prctl_map_locked(str
 	 * Make sure the members are not somewhere outside
 	 * of allowed address space.
 	 */
-#define __prctl_check_addr_space(__member)					\
-	({									\
-		int __rc;							\
-		if ((unsigned long)prctl_map->__member < mmap_max_addr &&	\
-		    (unsigned long)prctl_map->__member >= mmap_min_addr)	\
-			__rc = 0;						\
-		else								\
-			__rc = -EINVAL;						\
-		__rc;								\
+#define __prctl_check_addr_space(__member)				\
+	({								\
+		int __rc;						\
+		if ((unsigned long)prctl_map->__member < mmap_max_addr &&\
+		    (unsigned long)prctl_map->__member >= mmap_min_addr)\
+			__rc = 0;					\
+		else							\
+			__rc = -EINVAL;					\
+		__rc;							\
 	})
 	error |= __prctl_check_addr_space(start_code);
 	error |= __prctl_check_addr_space(end_code);
@@ -1736,7 +1736,7 @@ static int validate_prctl_map_locked(str
 		error = -EINVAL;
 		goto out;
 	}
-#define __prctl_check_vma(__member)						\
+#define __prctl_check_vma(__member)					\
 	find_vma(mm, (unsigned long)prctl_map->__member) ? 0 : -EINVAL
 	error |= __prctl_check_vma(start_brk);
 	error |= __prctl_check_vma(brk);
@@ -1751,8 +1751,8 @@ static int validate_prctl_map_locked(str
 	/*
 	 * Make sure the pairs are ordered.
 	 */
-#define __prctl_check_order(__m1, __op, __m2)					\
-	((unsigned long)prctl_map->__m1 __op					\
+#define __prctl_check_order(__m1, __op, __m2)				\
+	((unsigned long)prctl_map->__m1 __op				\
 	 (unsigned long)prctl_map->__m2) ? 0 : -EINVAL
 	error |= __prctl_check_order(start_code, <, end_code);
 	error |= __prctl_check_order(start_data, <, end_data);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

