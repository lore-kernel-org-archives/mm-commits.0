From: akpm@linux-foundation.org
Subject: [failures]
 exec-simplify-the-copy_strings_kernel-calling-convention.patch removed from
 -mm tree
Date: Sat, 25 Apr 2020 21:47:56 -0700
Message-ID: <20200426044756.w912GwqOG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgDZEr5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 26 Apr 2020 00:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, benh@kernel.crashing.org, ebiederm@xmission.com, hch@lst.de, jk@ozlabs.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: exec: simplify the copy_strings_kernel calling convention
has been removed from the -mm tree.  Its filename was
     exec-simplify-the-copy_strings_kernel-calling-convention.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: exec: simplify the copy_strings_kernel calling convention

copy_strings_kernel is always used with a single argument, adjust the
calling convention to that.

Link: http://lkml.kernel.org/r/20200421154204.252921-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_em86.c        |    6 +++---
 fs/binfmt_misc.c        |    4 ++--
 fs/binfmt_script.c      |    6 +++---
 fs/exec.c               |   13 ++++++-------
 include/linux/binfmts.h |    3 +--
 5 files changed, 15 insertions(+), 17 deletions(-)

--- a/fs/binfmt_em86.c~exec-simplify-the-copy_strings_kernel-calling-convention
+++ a/fs/binfmt_em86.c
@@ -68,15 +68,15 @@ static int load_em86(struct linux_binprm
 	 * user environment and arguments are stored.
 	 */
 	remove_arg_zero(bprm);
-	retval = copy_strings_kernel(1, &bprm->filename, bprm);
+	retval = copy_string_kernel(bprm->filename, bprm);
 	if (retval < 0) return retval; 
 	bprm->argc++;
 	if (i_arg) {
-		retval = copy_strings_kernel(1, &i_arg, bprm);
+		retval = copy_string_kernel(i_arg, bprm);
 		if (retval < 0) return retval; 
 		bprm->argc++;
 	}
-	retval = copy_strings_kernel(1, &i_name, bprm);
+	retval = copy_string_kernel(i_name, bprm);
 	if (retval < 0)	return retval;
 	bprm->argc++;
 
--- a/fs/binfmt_misc.c~exec-simplify-the-copy_strings_kernel-calling-convention
+++ a/fs/binfmt_misc.c
@@ -190,13 +190,13 @@ static int load_misc_binary(struct linux
 		bprm->file = NULL;
 	}
 	/* make argv[1] be the path to the binary */
-	retval = copy_strings_kernel(1, &bprm->interp, bprm);
+	retval = copy_string_kernel(bprm->interp, bprm);
 	if (retval < 0)
 		goto error;
 	bprm->argc++;
 
 	/* add the interp as argv[0] */
-	retval = copy_strings_kernel(1, &fmt->interpreter, bprm);
+	retval = copy_string_kernel(fmt->interpreter, bprm);
 	if (retval < 0)
 		goto error;
 	bprm->argc++;
--- a/fs/binfmt_script.c~exec-simplify-the-copy_strings_kernel-calling-convention
+++ a/fs/binfmt_script.c
@@ -117,17 +117,17 @@ static int load_script(struct linux_binp
 	retval = remove_arg_zero(bprm);
 	if (retval)
 		return retval;
-	retval = copy_strings_kernel(1, &bprm->interp, bprm);
+	retval = copy_string_kernel(bprm->interp, bprm);
 	if (retval < 0)
 		return retval;
 	bprm->argc++;
 	if (i_arg) {
-		retval = copy_strings_kernel(1, &i_arg, bprm);
+		retval = copy_string_kernel(i_arg, bprm);
 		if (retval < 0)
 			return retval;
 		bprm->argc++;
 	}
-	retval = copy_strings_kernel(1, &i_name, bprm);
+	retval = copy_string_kernel(i_name, bprm);
 	if (retval)
 		return retval;
 	bprm->argc++;
--- a/fs/exec.c~exec-simplify-the-copy_strings_kernel-calling-convention
+++ a/fs/exec.c
@@ -588,24 +588,23 @@ out:
 }
 
 /*
- * Like copy_strings, but get argv and its values from kernel memory.
+ * Copy and argument/environment string from the kernel to the processes stack.
  */
-int copy_strings_kernel(int argc, const char *const *__argv,
-			struct linux_binprm *bprm)
+int copy_string_kernel(const char *arg, struct linux_binprm *bprm)
 {
 	int r;
 	mm_segment_t oldfs = get_fs();
 	struct user_arg_ptr argv = {
-		.ptr.native = (const char __user *const  __user *)__argv,
+		.ptr.native = (const char __user *const  __user *)&arg,
 	};
 
 	set_fs(KERNEL_DS);
-	r = copy_strings(argc, argv, bprm);
+	r = copy_strings(1, argv, bprm);
 	set_fs(oldfs);
 
 	return r;
 }
-EXPORT_SYMBOL(copy_strings_kernel);
+EXPORT_SYMBOL(copy_string_kernel);
 
 #ifdef CONFIG_MMU
 
@@ -1863,7 +1862,7 @@ static int __do_execve_file(int fd, stru
 	if (retval < 0)
 		goto out;
 
-	retval = copy_strings_kernel(1, &bprm->filename, bprm);
+	retval = copy_string_kernel(bprm->filename, bprm);
 	if (retval < 0)
 		goto out;
 
--- a/include/linux/binfmts.h~exec-simplify-the-copy_strings_kernel-calling-convention
+++ a/include/linux/binfmts.h
@@ -144,8 +144,7 @@ extern int setup_arg_pages(struct linux_
 extern int transfer_args_to_stack(struct linux_binprm *bprm,
 				  unsigned long *sp_location);
 extern int bprm_change_interp(const char *interp, struct linux_binprm *bprm);
-extern int copy_strings_kernel(int argc, const char *const *argv,
-			       struct linux_binprm *bprm);
+int copy_string_kernel(const char *arg, struct linux_binprm *bprm);
 extern void install_exec_creds(struct linux_binprm *bprm);
 extern void set_binfmt(struct linux_binfmt *new);
 extern ssize_t read_code(struct file *, unsigned long, loff_t, size_t);
_

Patches currently in -mm which might be from hch@lst.de are

x86-hyperv-use-vmalloc_exec-for-the-hypercall-page.patch
x86-fix-vmap-arguments-in-map_irq_stack.patch
staging-android-ion-use-vmap-instead-of-vm_map_ram.patch
staging-media-ipu3-use-vmap-instead-of-reimplementing-it.patch
dma-mapping-use-vmap-insted-of-reimplementing-it.patch
powerpc-add-an-ioremap_phb-helper.patch
powerpc-remove-__ioremap_at-and-__iounmap_at.patch
mm-remove-__get_vm_area.patch
mm-unexport-unmap_kernel_range_noflush.patch
mm-rename-config_pgtable_mapping-to-config_zsmalloc_pgtable_mapping.patch
mm-only-allow-page-table-mappings-for-built-in-zsmalloc.patch
mm-pass-addr-as-unsigned-long-to-vb_free.patch
mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch
mm-rename-vmap_page_range-to-map_kernel_range.patch
mm-dont-return-the-number-of-pages-from-map_kernel_range_noflush.patch
mm-remove-map_vm_range.patch
mm-remove-unmap_vmap_area.patch
mm-remove-the-prot-argument-from-vm_map_ram.patch
mm-enforce-that-vmap-cant-map-pages-executable.patch
gpu-drm-remove-the-powerpc-hack-in-drm_legacy_sg_alloc.patch
mm-remove-the-pgprot-argument-to-__vmalloc.patch
mm-remove-the-prot-argument-to-__vmalloc_node.patch
mm-remove-both-instances-of-__vmalloc_node_flags.patch
mm-remove-__vmalloc_node_flags_caller.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node.patch
mm-remove-vmalloc_user_node_flags.patch
arm64-use-__vmalloc_node-in-arch_alloc_vmap_stack.patch
powerpc-use-__vmalloc_node-in-alloc_vm_stack.patch
s390-use-__vmalloc_node-in-stack_alloc.patch
exec-open-code-copy_string_kernel.patch
amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
i915-gvt-remove-unused-xen-bits.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
