From: akpm@linux-foundation.org
Subject: [merged]
 seccomp-check-in_compat_syscall-not-is_compat_task-in-strict-mode.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:40:37 -0700
Message-ID: <56f2d515.1yeRgIbjcHkYkQbc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbcCWRki (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: seccomp: check in_compat_syscall, not is_compat_task, in strict mode
has been removed from the -mm tree.  Its filename was
     seccomp-check-in_compat_syscall-not-is_compat_task-in-strict-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: seccomp: check in_compat_syscall, not is_compat_task, in strict mode

Seccomp wants to know the syscall bitness, not the caller task bitness,
when it selects the syscall whitelist.

As far as I know, this makes no difference on any architecture, so it's
not a security problem.  (It generates identical code everywhere except
sparc, and, on sparc, the syscall numbering is the same for both ABIs.)

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/seccomp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/seccomp.c~seccomp-check-in_compat_syscall-not-is_compat_task-in-strict-mode kernel/seccomp.c
--- a/kernel/seccomp.c~seccomp-check-in_compat_syscall-not-is_compat_task-in-strict-mode
+++ a/kernel/seccomp.c
@@ -395,7 +395,7 @@ seccomp_prepare_user_filter(const char _
 	struct seccomp_filter *filter = ERR_PTR(-EFAULT);
 
 #ifdef CONFIG_COMPAT
-	if (is_compat_task()) {
+	if (in_compat_syscall()) {
 		struct compat_sock_fprog fprog32;
 		if (copy_from_user(&fprog32, user_filter, sizeof(fprog32)))
 			goto out;
@@ -529,7 +529,7 @@ static void __secure_computing_strict(in
 {
 	int *syscall_whitelist = mode1_syscalls;
 #ifdef CONFIG_COMPAT
-	if (is_compat_task())
+	if (in_compat_syscall())
 		syscall_whitelist = mode1_syscalls_32;
 #endif
 	do {
_

Patches currently in -mm which might be from luto@kernel.org are


