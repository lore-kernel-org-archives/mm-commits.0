From: akpm@linux-foundation.org
Subject: - call_usermodehelper-increase-reliability.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:41 -0700
Message-ID: <200807252254.m6PMsfca002846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752623AbYGYWze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, andi@firstfloor.org, jeremy@xensource.com, lizf@cn.fujitsu.com, menage@google.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     call_usermodehelper(): increase reliability
has been removed from the -mm tree.  Its filename was
     call_usermodehelper-increase-reliability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: call_usermodehelper(): increase reliability
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Presently call_usermodehelper_setup() uses GFP_ATOMIC.  but it can return
NULL _very_ easily.

GFP_ATOMIC is needed only when we can't sleep.  and, GFP_KERNEL is robust
and better.

thus, I add gfp_mask argument to call_usermodehelper_setup().

So, its callers pass the gfp_t as below:

call_usermodehelper() and call_usermodehelper_keys():
	depend on 'wait' argument.
call_usermodehelper_pipe():
	always GFP_KERNEL because always run under process context.
orderly_poweroff():
	pass to GFP_ATOMIC because may run under interrupt context.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Paul Menage" <menage@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h |   11 +++++++----
 kernel/kmod.c        |    9 +++++----
 kernel/sys.c         |    2 +-
 3 files changed, 13 insertions(+), 9 deletions(-)

diff -puN include/linux/kmod.h~call_usermodehelper-increase-reliability include/linux/kmod.h
--- a/include/linux/kmod.h~call_usermodehelper-increase-reliability
+++ a/include/linux/kmod.h
@@ -19,6 +19,7 @@
  *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/gfp.h>
 #include <linux/stddef.h>
 #include <linux/errno.h>
 #include <linux/compiler.h>
@@ -41,8 +42,8 @@ struct file;
 struct subprocess_info;
 
 /* Allocate a subprocess_info structure */
-struct subprocess_info *call_usermodehelper_setup(char *path,
-						  char **argv, char **envp);
+struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
+						  char **envp, gfp_t gfp_mask);
 
 /* Set various pieces of state into the subprocess_info structure */
 void call_usermodehelper_setkeys(struct subprocess_info *info,
@@ -69,8 +70,9 @@ static inline int
 call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
 {
 	struct subprocess_info *info;
+	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
-	info = call_usermodehelper_setup(path, argv, envp);
+	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
 	if (info == NULL)
 		return -ENOMEM;
 	return call_usermodehelper_exec(info, wait);
@@ -81,8 +83,9 @@ call_usermodehelper_keys(char *path, cha
 			 struct key *session_keyring, enum umh_wait wait)
 {
 	struct subprocess_info *info;
+	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
-	info = call_usermodehelper_setup(path, argv, envp);
+	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
 	if (info == NULL)
 		return -ENOMEM;
 
diff -puN kernel/kmod.c~call_usermodehelper-increase-reliability kernel/kmod.c
--- a/kernel/kmod.c~call_usermodehelper-increase-reliability
+++ a/kernel/kmod.c
@@ -352,16 +352,17 @@ static inline void register_pm_notifier_
  * @path: path to usermode executable
  * @argv: arg vector for process
  * @envp: environment for process
+ * @gfp_mask: gfp mask for memory allocation
  *
  * Returns either %NULL on allocation failure, or a subprocess_info
  * structure.  This should be passed to call_usermodehelper_exec to
  * exec the process and free the structure.
  */
-struct subprocess_info *call_usermodehelper_setup(char *path,
-						  char **argv, char **envp)
+struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
+						  char **envp, gfp_t gfp_mask)
 {
 	struct subprocess_info *sub_info;
-	sub_info = kzalloc(sizeof(struct subprocess_info),  GFP_ATOMIC);
+	sub_info = kzalloc(sizeof(struct subprocess_info), gfp_mask);
 	if (!sub_info)
 		goto out;
 
@@ -494,7 +495,7 @@ int call_usermodehelper_pipe(char *path,
 	struct subprocess_info *sub_info;
 	int ret;
 
-	sub_info = call_usermodehelper_setup(path, argv, envp);
+	sub_info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL);
 	if (sub_info == NULL)
 		return -ENOMEM;
 
diff -puN kernel/sys.c~call_usermodehelper-increase-reliability kernel/sys.c
--- a/kernel/sys.c~call_usermodehelper-increase-reliability
+++ a/kernel/sys.c
@@ -1795,7 +1795,7 @@ int orderly_poweroff(bool force)
 		goto out;
 	}
 
-	info = call_usermodehelper_setup(argv[0], argv, envp);
+	info = call_usermodehelper_setup(argv[0], argv, envp, GFP_ATOMIC);
 	if (info == NULL) {
 		argv_free(argv);
 		goto out;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix-fix.patch
relay-add-buffer-only-channels-useful-for-early-logging-fix.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-collect-lru-meminfo-statistics-from-correct-offset.patch
vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru.patch
vmscan-split-lru-lists-into-anon-file-sets-split_lru-fix-pagevec_move_tail-doesnt-treat-unevictable-page.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
vmscan-second-chance-replacement-for-anonymous-pages-memcg-lru-scan-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
unevictable-lru-infrastructure-kill-unnecessary-lock_page-in-vmscanc.patch
unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
unevictable-lru-page-statistics-fix-printk-in-show_free_areas.patch
unevictable-lru-page-statistics-units-fix.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mlock-mlocked-pages-are-unevictable-restore-patch-failure-hunk-of-mlock-mlocked-pages-are-unevictablepatch.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmstat-mlocked-pages-statistics-fix.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch

