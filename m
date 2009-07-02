From: akpm@linux-foundation.org
Subject: + gcov-exclude-code-operating-in-userspace-from-profiling.patch added to -mm tree
Date: Thu, 02 Jul 2009 14:47:02 -0700
Message-ID: <200907022147.n62Ll27a012325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729AbZGBVrR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 17:47:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, mingo@elte.hu, rostedt@goodmis.org


The patch titled
     gcov: exclude code operating in userspace from profiling
has been added to the -mm tree.  Its filename is
     gcov-exclude-code-operating-in-userspace-from-profiling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
gcov-exclude-code-operating-in-userspace-from-profiling.patch

