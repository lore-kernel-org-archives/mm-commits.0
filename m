From: akpm@linux-foundation.org
Subject: [merged]
 auditsc-for-seccomp-events-log-syscall-compat-state-using-in_compat_syscall.patch removed from -mm tree
Date: Wed, 23 Mar 2016 10:40:41 -0700
Message-ID: <56f2d519.efwpVWXFH5vK12nu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260AbcCWRkr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, davem@davemloft.net, eparis@redhat.com, paul@paul-moore.com, mm-commits@vger.kernel.org


The patch titled
     Subject: auditsc: for seccomp events, log syscall compat state using in_compat_syscall
has been removed from the -mm tree.  Its filename was
     auditsc-for-seccomp-events-log-syscall-compat-state-using-in_compat_syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: auditsc: for seccomp events, log syscall compat state using in_compat_syscall

Except on SPARC, this is what the code always did.  SPARC compat
seccomp was buggy, although the impact of the bug was limited
because SPARC 32-bit and 64-bit syscall numbers are the same.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/auditsc.c~auditsc-for-seccomp-events-log-syscall-compat-state-using-in_compat_syscall kernel/auditsc.c
--- a/kernel/auditsc.c~auditsc-for-seccomp-events-log-syscall-compat-state-using-in_compat_syscall
+++ a/kernel/auditsc.c
@@ -2412,8 +2412,8 @@ void __audit_seccomp(unsigned long sysca
 		return;
 	audit_log_task(ab);
 	audit_log_format(ab, " sig=%ld arch=%x syscall=%ld compat=%d ip=0x%lx code=0x%x",
-			 signr, syscall_get_arch(), syscall, is_compat_task(),
-			 KSTK_EIP(current), code);
+			 signr, syscall_get_arch(), syscall,
+			 in_compat_syscall(), KSTK_EIP(current), code);
 	audit_log_end(ab);
 }
 
_

Patches currently in -mm which might be from luto@kernel.org are


