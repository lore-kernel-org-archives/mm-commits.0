From: akpm@linux-foundation.org
Subject: [merged] capabilities-simplify-bound-checks-for-copy_from_user.patch removed from -mm tree
Date: Thu, 15 Oct 2009 11:43:57 -0700
Message-ID: <200910151843.n9FIhvhJ024272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935278AbZJOSou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 14:44:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@infradead.org, arjan@linux.intel.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     capabilities: simplify bound checks for copy_from_user()
has been removed from the -mm tree.  Its filename was
     capabilities-simplify-bound-checks-for-copy_from_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: capabilities: simplify bound checks for copy_from_user()
From: Arjan van de Ven <arjan@infradead.org>

The capabilities syscall has a copy_from_user() call where gcc currently
cannot prove to itself that the copy is always within bounds.

This patch adds a very explicity bound check to prove to gcc that this
copy_from_user cannot overflow its destination buffer.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/capability.c~capabilities-simplify-bound-checks-for-copy_from_user kernel/capability.c
--- a/kernel/capability.c~capabilities-simplify-bound-checks-for-copy_from_user
+++ a/kernel/capability.c
@@ -238,7 +238,7 @@ SYSCALL_DEFINE2(capget, cap_user_header_
 SYSCALL_DEFINE2(capset, cap_user_header_t, header, const cap_user_data_t, data)
 {
 	struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
-	unsigned i, tocopy;
+	unsigned i, tocopy, copybytes;
 	kernel_cap_t inheritable, permitted, effective;
 	struct cred *new;
 	int ret;
@@ -255,8 +255,11 @@ SYSCALL_DEFINE2(capset, cap_user_header_
 	if (pid != 0 && pid != task_pid_vnr(current))
 		return -EPERM;
 
-	if (copy_from_user(&kdata, data,
-			   tocopy * sizeof(struct __user_cap_data_struct)))
+	copybytes = tocopy * sizeof(struct __user_cap_data_struct);
+	if (copybytes > sizeof(kdata))
+		return -EFAULT;
+
+	if (copy_from_user(&kdata, data, copybytes))
 		return -EFAULT;
 
 	for (i = 0; i < tocopy; i++) {
_

Patches currently in -mm which might be from arjan@infradead.org are

linux-next.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch

