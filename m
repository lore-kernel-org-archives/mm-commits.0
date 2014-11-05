From: akpm@linux-foundation.org
Subject: + fanotify-ignore-marks-not-respected-fix.patch added to -mm tree
Date: Wed, 05 Nov 2014 13:57:35 -0800
Message-ID: <545a9d4f.LHJQSlbqT7RC+/HJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaKEV5e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2014 16:57:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify-ignore-marks-not-respected-fix
has been added to the -mm tree.  Its filename is
     fanotify-ignore-marks-not-respected-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-ignore-marks-not-respected-fix.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-ignore-marks-not-respected-fix.patch

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
Subject: fanotify-ignore-marks-not-respected-fix

fix typo in comment, tweak code layout

Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fsnotify.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/notify/fsnotify.c~fanotify-ignore-marks-not-respected-fix fs/notify/fsnotify.c
--- a/fs/notify/fsnotify.c~fanotify-ignore-marks-not-respected-fix
+++ a/fs/notify/fsnotify.c
@@ -188,7 +188,7 @@ static int send_to_group(struct inode *t
  * out to all of the registered fsnotify_group.  Those groups can then use the
  * notification event in whatever means they feel necessary.
  *
- * To correctly interprete the ignore mask it is necessary to pass the inode
+ * To correctly interpret the ignore mask it is necessary to pass the inode
  * mark and the vfsmount mark of the same notification group in a single call
  * to send_to_group().
  *
@@ -265,12 +265,11 @@ int fsnotify(struct inode *to_tell, __u3
 		else if (vfsmount_group == NULL)
 			vfsmount_mark = NULL;
 		else {
-			if (inode_group->priority
-			    > vfsmount_group->priority) {
+			if (inode_group->priority > vfsmount_group->priority) {
 				vfsmount_mark = NULL;
 				vfsmount_group = NULL;
-			} else if (inode_group->priority
-				   < vfsmount_group->priority) {
+			} else if (inode_group->priority <
+					vfsmount_group->priority) {
 				inode_mark = NULL;
 				inode_group = NULL;
 			} else if (inode_group > vfsmount_group) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-ignore-marks-not-respected-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

