From: akpm@linux-foundation.org
Subject: - mm-mempolicyc-cleanups.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:10 -0700
Message-ID: <200710162036.l9GKaAHr015125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57017 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933879AbXJPVfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:35:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mm/mempolicy.c: cleanups
has been removed from the -mm tree.  Its filename was
     mm-mempolicyc-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm/mempolicy.c: cleanups
From: Adrian Bunk <bunk@stusta.de>

This patch contains the following cleanups:
- every file should include the headers containing the prototypes for
  its global functions
- make the follosing needlessly global functions static:
  - migrate_to_node()
  - do_mbind()
  - sp_alloc()
  - mpol_rebind_policy()

[akpm@linux-foundation.org: fix uninitialised var warning]
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    6 ------
 mm/mempolicy.c            |   28 ++++++++++++++++++----------
 2 files changed, 18 insertions(+), 16 deletions(-)

diff -puN include/linux/mempolicy.h~mm-mempolicyc-cleanups include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-mempolicyc-cleanups
+++ a/include/linux/mempolicy.h
@@ -144,7 +144,6 @@ struct mempolicy *mpol_shared_policy_loo
 
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
-extern void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *new);
 extern void mpol_rebind_task(struct task_struct *tsk,
 					const nodemask_t *new);
 extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
@@ -236,11 +235,6 @@ static inline void numa_default_policy(v
 {
 }
 
-static inline void mpol_rebind_policy(struct mempolicy *pol,
-					const nodemask_t *new)
-{
-}
-
 static inline void mpol_rebind_task(struct task_struct *tsk,
 					const nodemask_t *new)
 {
diff -puN mm/mempolicy.c~mm-mempolicyc-cleanups mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-cleanups
+++ a/mm/mempolicy.c
@@ -87,6 +87,7 @@
 #include <linux/migrate.h>
 #include <linux/rmap.h>
 #include <linux/security.h>
+#include <linux/syscalls.h>
 
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
@@ -108,6 +109,9 @@ struct mempolicy default_policy = {
 	.policy = MPOL_DEFAULT,
 };
 
+static void mpol_rebind_policy(struct mempolicy *pol,
+                               const nodemask_t *newmask);
+
 /* Do sanity checking on a policy */
 static int mpol_check_policy(int mode, nodemask_t *nodes)
 {
@@ -459,7 +463,7 @@ static void mpol_set_task_struct_flag(vo
 }
 
 /* Set the process memory policy */
-long do_set_mempolicy(int mode, nodemask_t *nodes)
+static long do_set_mempolicy(int mode, nodemask_t *nodes)
 {
 	struct mempolicy *new;
 
@@ -519,8 +523,8 @@ static int lookup_node(struct mm_struct 
 }
 
 /* Retrieve NUMA policy */
-long do_get_mempolicy(int *policy, nodemask_t *nmask,
-			unsigned long addr, unsigned long flags)
+static long do_get_mempolicy(int *policy, nodemask_t *nmask,
+			     unsigned long addr, unsigned long flags)
 {
 	int err;
 	struct mm_struct *mm = current->mm;
@@ -611,7 +615,8 @@ static struct page *new_node_page(struct
  * Migrate pages from one node to a target node.
  * Returns error or the number of pages not migrated.
  */
-int migrate_to_node(struct mm_struct *mm, int source, int dest, int flags)
+static int migrate_to_node(struct mm_struct *mm, int source, int dest,
+			   int flags)
 {
 	nodemask_t nmask;
 	LIST_HEAD(pagelist);
@@ -742,8 +747,9 @@ static struct page *new_vma_page(struct 
 }
 #endif
 
-long do_mbind(unsigned long start, unsigned long len,
-		unsigned long mode, nodemask_t *nmask, unsigned long flags)
+static long do_mbind(unsigned long start, unsigned long len,
+		     unsigned long mode, nodemask_t *nmask,
+		     unsigned long flags)
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
@@ -988,7 +994,8 @@ asmlinkage long sys_get_mempolicy(int __
 				unsigned long maxnode,
 				unsigned long addr, unsigned long flags)
 {
-	int err, pval;
+	int err;
+	int uninitialized_var(pval);
 	nodemask_t nodes;
 
 	if (nmask != NULL && maxnode < MAX_NUMNODES)
@@ -1537,8 +1544,8 @@ static void sp_delete(struct shared_poli
 	kmem_cache_free(sn_cache, n);
 }
 
-struct sp_node *
-sp_alloc(unsigned long start, unsigned long end, struct mempolicy *pol)
+static struct sp_node *sp_alloc(unsigned long start, unsigned long end,
+				struct mempolicy *pol)
 {
 	struct sp_node *n = kmem_cache_alloc(sn_cache, GFP_KERNEL);
 
@@ -1716,7 +1723,8 @@ void numa_default_policy(void)
 }
 
 /* Migrate a policy to a different set of nodes */
-void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *newmask)
+static void mpol_rebind_policy(struct mempolicy *pol,
+			       const nodemask_t *newmask)
 {
 	nodemask_t *mpolmask;
 	nodemask_t tmp;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-kvm.patch
remove-fs-jffs2-ioctlc.patch
parisc-extern-inline-static-inline.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-ipwireless_cs.patch
maps2-add-proc-kpagemap-interface.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
unicode-diacritics-support-s390-fix.patch
script-to-check-for-undefined-kconfig-symbols.patch
drivers-block-ccissc-fix-check-after-use.patch
dontdiff-update-based-on-gitignore-updates.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
