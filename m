From: akpm@linux-foundation.org
Subject: + mips-allocate-sys_membarrier-system-call-number.patch added to
 -mm tree
Date: Mon, 28 Sep 2015 13:33:16 -0700
Message-ID: <5609a40c.lyNlmI5jvcqVIBRk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbbI1UdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 16:33:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@efficios.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: allocate sys_membarrier system call number
has been added to the -mm tree.  Its filename is
     mips-allocate-sys_membarrier-system-call-number.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mips-allocate-sys_membarrier-system-call-number.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mips-allocate-sys_membarrier-system-call-number.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: mips: allocate sys_membarrier system call number

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/uapi/asm/unistd.h |   15 +++++++++------
 arch/mips/kernel/scall32-o32.S      |    1 +
 arch/mips/kernel/scall64-64.S       |    1 +
 arch/mips/kernel/scall64-n32.S      |    1 +
 arch/mips/kernel/scall64-o32.S      |    1 +
 5 files changed, 13 insertions(+), 6 deletions(-)

diff -puN arch/mips/include/uapi/asm/unistd.h~mips-allocate-sys_membarrier-system-call-number arch/mips/include/uapi/asm/unistd.h
--- a/arch/mips/include/uapi/asm/unistd.h~mips-allocate-sys_membarrier-system-call-number
+++ a/arch/mips/include/uapi/asm/unistd.h
@@ -378,16 +378,17 @@
 #define __NR_bpf			(__NR_Linux + 355)
 #define __NR_execveat			(__NR_Linux + 356)
 #define __NR_mlock2			(__NR_Linux + 357)
+#define __NR_membarrier			(__NR_Linux + 358)
 
 /*
  * Offset of the last Linux o32 flavoured syscall
  */
-#define __NR_Linux_syscalls		357
+#define __NR_Linux_syscalls		358
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
 
 #define __NR_O32_Linux			4000
-#define __NR_O32_Linux_syscalls		357
+#define __NR_O32_Linux_syscalls		358
 
 #if _MIPS_SIM == _MIPS_SIM_ABI64
 
@@ -713,16 +714,17 @@
 #define __NR_bpf			(__NR_Linux + 315)
 #define __NR_execveat			(__NR_Linux + 316)
 #define __NR_mlock2			(__NR_Linux + 317)
+#define __NR_membarrier			(__NR_Linux + 318)
 
 /*
  * Offset of the last Linux 64-bit flavoured syscall
  */
-#define __NR_Linux_syscalls		317
+#define __NR_Linux_syscalls		318
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */
 
 #define __NR_64_Linux			5000
-#define __NR_64_Linux_syscalls		317
+#define __NR_64_Linux_syscalls		318
 
 #if _MIPS_SIM == _MIPS_SIM_NABI32
 
@@ -1052,15 +1054,16 @@
 #define __NR_bpf			(__NR_Linux + 319)
 #define __NR_execveat			(__NR_Linux + 320)
 #define __NR_mlock2			(__NR_Linux + 321)
+#define __NR_membarrier			(__NR_Linux + 322)
 
 /*
  * Offset of the last N32 flavoured syscall
  */
-#define __NR_Linux_syscalls		321
+#define __NR_Linux_syscalls		322
 
 #endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */
 
 #define __NR_N32_Linux			6000
-#define __NR_N32_Linux_syscalls		321
+#define __NR_N32_Linux_syscalls		322
 
 #endif /* _UAPI_ASM_UNISTD_H */
diff -puN arch/mips/kernel/scall32-o32.S~mips-allocate-sys_membarrier-system-call-number arch/mips/kernel/scall32-o32.S
--- a/arch/mips/kernel/scall32-o32.S~mips-allocate-sys_membarrier-system-call-number
+++ a/arch/mips/kernel/scall32-o32.S
@@ -600,3 +600,4 @@ EXPORT(sys_call_table)
 	PTR	sys_bpf				/* 4355 */
 	PTR	sys_execveat
 	PTR	sys_mlock2
+	PTR	sys_membarrier
diff -puN arch/mips/kernel/scall64-64.S~mips-allocate-sys_membarrier-system-call-number arch/mips/kernel/scall64-64.S
--- a/arch/mips/kernel/scall64-64.S~mips-allocate-sys_membarrier-system-call-number
+++ a/arch/mips/kernel/scall64-64.S
@@ -437,4 +437,5 @@ EXPORT(sys_call_table)
 	PTR	sys_bpf				/* 5315 */
 	PTR	sys_execveat
 	PTR	sys_mlock2
+	PTR	sys_membarrier
 	.size	sys_call_table,.-sys_call_table
diff -puN arch/mips/kernel/scall64-n32.S~mips-allocate-sys_membarrier-system-call-number arch/mips/kernel/scall64-n32.S
--- a/arch/mips/kernel/scall64-n32.S~mips-allocate-sys_membarrier-system-call-number
+++ a/arch/mips/kernel/scall64-n32.S
@@ -430,4 +430,5 @@ EXPORT(sysn32_call_table)
 	PTR	sys_bpf
 	PTR	compat_sys_execveat		/* 6320 */
 	PTR	sys_mlock2
+	PTR	sys_membarrier
 	.size	sysn32_call_table,.-sysn32_call_table
diff -puN arch/mips/kernel/scall64-o32.S~mips-allocate-sys_membarrier-system-call-number arch/mips/kernel/scall64-o32.S
--- a/arch/mips/kernel/scall64-o32.S~mips-allocate-sys_membarrier-system-call-number
+++ a/arch/mips/kernel/scall64-o32.S
@@ -585,4 +585,5 @@ EXPORT(sys32_call_table)
 	PTR	sys_bpf				/* 4355 */
 	PTR	compat_sys_execveat
 	PTR	sys_mlock2
+	PTR	sys_membarrier
 	.size	sys32_call_table,.-sys32_call_table
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

mips-allocate-sys_membarrier-system-call-number.patch

