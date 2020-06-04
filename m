From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 096/127] exec: simplify the copy_strings_kernel
 calling convention
Date: Thu, 04 Jun 2020 16:51:14 -0700
Message-ID: <20200604235114.FgJFp55nc%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbgFDXvQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:51:16 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Christoph Hellwig <hch@lst.de>
Subject: exec: simplify the copy_strings_kernel calling convention

copy_strings_kernel is always used with a single argument,
adjust the calling convention to that.

Link: http://lkml.kernel.org/r/20200501104105.2621149-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
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
 
@@ -1865,7 +1864,7 @@ static int __do_execve_file(int fd, stru
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
