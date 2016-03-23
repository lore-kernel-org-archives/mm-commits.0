From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-in-peek_siginfo-check-syscall-bitness-not-task-bitness.patch removed from -mm tree
Date: Wed, 23 Mar 2016 10:40:39 -0700
Message-ID: <56f2d517.0NMvqwGDA8wsu8IM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbcCWRkk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: in PEEK_SIGINFO, check syscall bitness, not task bitness
has been removed from the -mm tree.  Its filename was
     ptrace-in-peek_siginfo-check-syscall-bitness-not-task-bitness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: ptrace: in PEEK_SIGINFO, check syscall bitness, not task bitness

Users of the 32-bit ptrace() ABI expect the full 32-bit ABI.  siginfo
translation should check ptrace() ABI, not caller task ABI.

This is an ABI change on SPARC.  Let's hope that no one relied on the old
buggy ABI.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/ptrace.c~ptrace-in-peek_siginfo-check-syscall-bitness-not-task-bitness kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-in-peek_siginfo-check-syscall-bitness-not-task-bitness
+++ a/kernel/ptrace.c
@@ -681,7 +681,7 @@ static int ptrace_peek_siginfo(struct ta
 			break;
 
 #ifdef CONFIG_COMPAT
-		if (unlikely(is_compat_task())) {
+		if (unlikely(in_compat_syscall())) {
 			compat_siginfo_t __user *uinfo = compat_ptr(data);
 
 			if (copy_siginfo_to_user32(uinfo, &info) ||
_

Patches currently in -mm which might be from luto@kernel.org are


