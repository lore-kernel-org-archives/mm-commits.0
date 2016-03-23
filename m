From: akpm@linux-foundation.org
Subject: [merged]
 sparc-compat-provide-an-accurate-in_compat_syscall-implementation.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:40:33 -0700
Message-ID: <56f2d511.ysF6hze3iOJZWXo7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbcCWRkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, davem@davemloft.net, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc/compat: provide an accurate in_compat_syscall implementation
has been removed from the -mm tree.  Its filename was
     sparc-compat-provide-an-accurate-in_compat_syscall-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: sparc/compat: provide an accurate in_compat_syscall implementation

On sparc64 compat-enabled kernels, any task can make 32-bit and 64-bit
syscalls.  is_compat_task returns true in 32-bit tasks, which does not
necessarily imply that the current syscall is 32-bit.

Provide an in_compat_syscall implementation that checks whether the
current syscall is compat.

As far as I know, sparc is the only architecture on which is_compat_task
checks the compat status of the task and on which the compat status of a
syscall can differ from the compat status of the task.  On x86,
is_compat_task checks the syscall type, not the task type.

[akpm@linux-foundation.org: add comment, per Sam]
[akpm@linux-foundation.org: update comment, per Andy]
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/compat.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/sparc/include/asm/compat.h~sparc-compat-provide-an-accurate-in_compat_syscall-implementation arch/sparc/include/asm/compat.h
--- a/arch/sparc/include/asm/compat.h~sparc-compat-provide-an-accurate-in_compat_syscall-implementation
+++ a/arch/sparc/include/asm/compat.h
@@ -307,4 +307,11 @@ static inline int is_compat_task(void)
 	return test_thread_flag(TIF_32BIT);
 }
 
+static inline bool in_compat_syscall(void)
+{
+	/* Vector 0x110 is LINUX_32BIT_SYSCALL_TRAP */
+	return pt_regs_trap_type(current_pt_regs()) == 0x110;
+}
+#define in_compat_syscall in_compat_syscall
+
 #endif /* _ASM_SPARC64_COMPAT_H */
_

Patches currently in -mm which might be from luto@kernel.org are


