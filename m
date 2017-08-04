From: akpm@linux-foundation.org
Subject: + mm-fix-list-corruptions-on-shmem-shrinklist-fix.patch added to
 -mm tree
Date: Fri, 04 Aug 2017 16:19:17 -0700
Message-ID: <598500f5.1HcJfJhGxwW2wDTz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47480 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753692AbdHDXTS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2017 19:19:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, kirill.shutemov@linux.intel.com, stable@vger.kernel.org, torvalds@linux-foundation.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-list-corruptions-on-shmem-shrinklist-fix
has been added to the -mm tree.  Its filename is
     mm-fix-list-corruptions-on-shmem-shrinklist-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-list-corruptions-on-shmem-shrinklist-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-list-corruptions-on-shmem-shrinklist-fix.patch

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
Subject: mm-fix-list-corruptions-on-shmem-shrinklist-fix

add comments

Cc: <stable@vger.kernel.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/shmem.c~mm-fix-list-corruptions-on-shmem-shrinklist-fix mm/shmem.c
--- a/mm/shmem.c~mm-fix-list-corruptions-on-shmem-shrinklist-fix
+++ a/mm/shmem.c
@@ -1022,6 +1022,10 @@ static int shmem_setattr(struct dentry *
 			 */
 			if (IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE)) {
 				spin_lock(&sbinfo->shrinklist_lock);
+				/*
+				 * _careful to defend against unlocked access to
+				 * ->shrink_list in shmem_unused_huge_shrink()
+				 */
 				if (list_empty_careful(&info->shrinklist)) {
 					list_add_tail(&info->shrinklist,
 							&sbinfo->shrinklist);
@@ -1817,6 +1821,10 @@ alloc_nohuge:		page = shmem_alloc_and_ac
 			 * to shrink under memory pressure.
 			 */
 			spin_lock(&sbinfo->shrinklist_lock);
+			/*
+			 * _careful to defend against unlocked access to
+			 * ->shrink_list in shmem_unused_huge_shrink()
+			 */
 			if (list_empty_careful(&info->shrinklist)) {
 				list_add_tail(&info->shrinklist,
 						&sbinfo->shrinklist);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-make-tlb_flush_pending-global-fix.patch
mm-fix-list-corruptions-on-shmem-shrinklist-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
add-testcases-for-memset16-32-64-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

