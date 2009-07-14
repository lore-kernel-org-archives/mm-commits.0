From: akpm@linux-foundation.org
Subject: [merged] gcov-exclude-code-operating-in-userspace-from-profiling.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:32:39 -0700
Message-ID: <200907142032.n6EKWdJ1012241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756443AbZGNUdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:33:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oberpar@linux.vnet.ibm.com, mingo@elte.hu, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     gcov: exclude code operating in userspace from profiling
has been removed from the -mm tree.  Its filename was
     gcov-exclude-code-operating-in-userspace-from-profiling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcov: exclude code operating in userspace from profiling
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Fix for this issue on x86_64:

rostedt@goodmis.org wrote:
> On bootup of the latest kernel my init segfaults. Debugging it,
> I found  that vread_tsc (a vsyscall) increments some strange
> kernel memory:
>
> 0000000000000000 <vread_tsc>:
>    0:   55                      push   %rbp
>    1:   48 ff 05 00 00 00 00    incq   0(%rip)
>                         # 8 <vread_tsc+0x8>
>                         4: R_X86_64_PC32        .bss+0x3c
>    8:   48 89 e5                mov    %rsp,%rbp
>    b:   66 66 90                xchg   %ax,%ax
>    e:   48 ff 05 00 00 00 00    incq   0(%rip)
>                         # 15 <vread_tsc+0x15>
>                         11: R_X86_64_PC32       .bss+0x44
>   15:   66 66 90                xchg   %ax,%ax
>   18:   48 ff 05 00 00 00 00    incq   0(%rip)
>                         # 1f <vread_tsc+0x1f>
>                         1b: R_X86_64_PC32       .bss+0x4c
>   1f:   0f 31                   rdtsc
>
>
> Those "incq" is very bad to happen in vsyscall memory, since
> userspace can not modify it. You need to make something prevent
> profiling of vsyscall  memory (like I do with ftrace).

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/Makefile |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/kernel/Makefile~gcov-exclude-code-operating-in-userspace-from-profiling arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~gcov-exclude-code-operating-in-userspace-from-profiling
+++ a/arch/x86/kernel/Makefile
@@ -26,6 +26,8 @@ CFLAGS_tsc.o		:= $(nostackp)
 CFLAGS_paravirt.o	:= $(nostackp)
 GCOV_PROFILE_vsyscall_64.o	:= n
 GCOV_PROFILE_hpet.o		:= n
+GCOV_PROFILE_tsc.o		:= n
+GCOV_PROFILE_paravirt.o		:= n
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
_

Patches currently in -mm which might be from oberpar@linux.vnet.ibm.com are


