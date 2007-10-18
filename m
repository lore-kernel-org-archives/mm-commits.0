From: akpm@linux-foundation.org
Subject: - ipc-shmc-make-2-functions-static.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:54:45 -0700
Message-ID: <200710180654.l9I6sjxQ030548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57878 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760776AbXJRHh2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:37:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     ipc/shm.c: make 2 functions static
has been removed from the -mm tree.  Its filename was
     ipc-shmc-make-2-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipc/shm.c: make 2 functions static
From: Adrian Bunk <bunk@stusta.de>

This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN ipc/shm.c~ipc-shmc-make-2-functions-static ipc/shm.c
--- a/ipc/shm.c~ipc-shmc-make-2-functions-static
+++ a/ipc/shm.c
@@ -233,7 +233,7 @@ static int shm_fault(struct vm_area_stru
 }
 
 #ifdef CONFIG_NUMA
-int shm_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
+static int shm_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
 {
 	struct file *file = vma->vm_file;
 	struct shm_file_data *sfd = shm_file_data(file);
@@ -243,7 +243,8 @@ int shm_set_policy(struct vm_area_struct
 	return err;
 }
 
-struct mempolicy *shm_get_policy(struct vm_area_struct *vma, unsigned long addr)
+static struct mempolicy *shm_get_policy(struct vm_area_struct *vma,
+					unsigned long addr)
 {
 	struct file *file = vma->vm_file;
 	struct shm_file_data *sfd = shm_file_data(file);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-kvm.patch
remove-fs-jffs2-ioctlc.patch
parisc-extern-inline-static-inline.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
unexport-pm_power_off_prepare.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
