From: akpm@linux-foundation.org
Subject: + elf-fix-multithreaded-program-core-dumping-on-arm.patch added to -mm tree
Date: Wed, 01 Jul 2009 11:54:24 -0700
Message-ID: <200907011854.n61IsOVt001274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834AbZGASzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 14:55:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: teawater@gmail.com, dhowells@redhat.com, jakub@redhat.com, rmk@arm.linux.org.uk, roland@redhat.com, viro@zeniv.linux.org.uk, xiyou.wangcong@gmail.com


The patch titled
     elf: fix multithreaded program core dumping on arm
has been added to the -mm tree.  Its filename is
     elf-fix-multithreaded-program-core-dumping-on-arm.patch

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
Subject: elf: fix multithreaded program core dumping on arm
From: Hui Zhu <teawater@gmail.com>

Fix the multithread program core thread message error.

This issue affects arches with neither has CORE_DUMP_USE_REGSET nor
ELF_CORE_COPY_TASK_REGS, ARM is one of them.

The thread message of core file is generated in elf_dump_thread_status. 
The register values is set by elf_core_copy_task_regs in this function.

If an arch doesn't define ELF_CORE_COPY_TASK_REGS,
elf_core_copy_task_regs() will do nothing.  Then the core file will not
have the register message of thread.

So add elf_core_copy_regs to set regiser values if ELF_CORE_COPY_TASK_REGS
doesn't define.

The following is how to reproduce this issue:

cat 1.c
#include <stdio.h>
#include <pthread.h>
#include <assert.h>

void td1(void * i)
{
       while (1)
       {
               printf ("1\n");
               sleep (1);
       }

       return;
}

void td2(void * i)
{
       while (1)
       {
               printf ("2\n");
               sleep (1);
       }

       return;
}

int
main(int argc,char *argv[],char *envp[])
{
       pthread_t       t1,t2;

       pthread_create(&t1, NULL, (void*)td1, NULL);
       pthread_create(&t2, NULL, (void*)td2, NULL);

       sleep (10);

       assert(0);

       return (0);
}
arm-xxx-gcc -g -lpthread 1.c -o 1
copy 1.c and 1 to a arm board.
Goto this board.
ulimit -c 1800000
./1
# ./1
1
2
1
...
...
1
1: 1.c:37: main: Assertion `0' failed.
Aborted (core dumped)
Then you can get a core file.
gdb 1 core.xxx
Without the patch:
(gdb) info threads
 3 process 909  0x00000000 in ?? ()
 2 process 908  0x00000000 in ?? ()
* 1 process 907  0x4a6e2238 in raise () from /lib/libc.so.6
You can found that the pc of 909 and 908 is 0x00000000.
With the patch:
(gdb) info threads
 3 process 885  0x4a749974 in nanosleep () from /lib/libc.so.6
 2 process 884  0x4a749974 in nanosleep () from /lib/libc.so.6
* 1 process 883  0x4a6e2238 in raise () from /lib/libc.so.6
The pc of 885 and 884 is right.

Signed-off-by: Hui Zhu <teawater@gmail.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/elfcore.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/elfcore.h~elf-fix-multithreaded-program-core-dumping-on-arm include/linux/elfcore.h
--- a/include/linux/elfcore.h~elf-fix-multithreaded-program-core-dumping-on-arm
+++ a/include/linux/elfcore.h
@@ -125,6 +125,8 @@ static inline int elf_core_copy_task_reg
 #ifdef ELF_CORE_COPY_TASK_REGS
 	
 	return ELF_CORE_COPY_TASK_REGS(t, elfregs);
+#else
+	elf_core_copy_regs(elfregs, task_pt_regs(t));
 #endif
 	return 0;
 }
_

Patches currently in -mm which might be from teawater@gmail.com are

elf-fix-multithreaded-program-core-dumping-on-arm.patch

