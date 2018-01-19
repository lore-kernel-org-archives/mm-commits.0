From: akpm@linux-foundation.org
Subject: [patch 5/6] proc: fix coredump vs read /proc/*/stat race
Date: Thu, 18 Jan 2018 16:34:05 -0800
Message-ID: <5a613cfd.zH6KMv7ABoC+mZ0A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57586 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754862AbeASAeG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jan 2018 19:34:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com, a.p.zijlstra@chello.nl, gkohli@codeaurora.org, john.ogness@linutronix.de, mingo@elte.hu, oleg@redhat.com, stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: fix coredump vs read /proc/*/stat race

do_task_stat() accesses IP and SP of a task without bumping reference
count of a stack (which became an entity with independent lifetime at some
point).

Steps to reproduce:

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <unistd.h>
#include <sys/wait.h>

int main(void)
{
	setrlimit(RLIMIT_CORE, &(struct rlimit){});

	while (1) {
		char buf[64];
		char buf2[4096];
		pid_t pid;
		int fd;

		pid = fork();
		if (pid == 0) {
			*(volatile int *)0 = 0;
		}

		snprintf(buf, sizeof(buf), "/proc/%u/stat", pid);
		fd = open(buf, O_RDONLY);
		read(fd, buf2, sizeof(buf2));
		close(fd);

		waitpid(pid, NULL, 0);
	}
	return 0;
}

BUG: unable to handle kernel paging request at 0000000000003fd8
IP: do_task_stat+0x8b4/0xaf0
PGD 800000003d73e067 P4D 800000003d73e067 PUD 3d558067 PMD 0
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 0 PID: 1417 Comm: a.out Not tainted 4.15.0-rc8-dirty #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1.fc27 04/01/2014
RIP: 0010:do_task_stat+0x8b4/0xaf0
RSP: 0018:ffffc90000607cc8 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff88003e0e6680 RCX: ffff88003d6bd500
RDX: 0000000000000001 RSI: 000000000000000d RDI: ffff88003c1f8000
RBP: ffff88003c1f8000 R08: 0000000000000001 R09: 0000000000001000
R10: 00007f4d79555460 R11: ffff88003c325800 R12: ffff88003d7643c0
R13: ffffffff81a28f80 R14: 0000000000000001 R15: 0000000000000001
FS:  00007f4d79772700(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000003fd8 CR3: 000000003d9c0000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ? flush_tlb_mm_range+0x8b/0x100
 proc_single_show+0x43/0x70
 seq_read+0xe6/0x3b0
 __vfs_read+0x1e/0x120
 ? __check_object_size+0xa4/0x180
 vfs_read+0x84/0x110
 SyS_read+0x3d/0xa0
 entry_SYSCALL_64_fastpath+0x13/0x6c
RIP: 0033:0x7f4d7928cba0
RSP: 002b:00007ffddb245158 EFLAGS: 00000246
Code: 03 b7 a0 01 00 00 4c 8b 4c 24 70 4c 8b 44 24 78 4c 89 74 24 18 e9 91 f9 ff ff f6 45 4d 02 0f 84 fd f7 ff ff 48 8b 45 40 48 89 ef <48> 8b 80 d8 3f 00 00 48 89 44 24 20 e8 9b 97 eb ff 48 89 44 24
RIP: do_task_stat+0x8b4/0xaf0 RSP: ffffc90000607cc8
CR2: 0000000000003fd8

John Ogness said: for my tests I added an else case to verify that the
race is hit and correctly mitigated.

Link: http://lkml.kernel.org/r/20180116175054.GA11513@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: "Kohli, Gaurav" <gkohli@codeaurora.org>
Tested-by: John Ogness <john.ogness@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/proc/array.c~proc-fix-coredump-vs-read-proc-stat-race fs/proc/array.c
--- a/fs/proc/array.c~proc-fix-coredump-vs-read-proc-stat-race
+++ a/fs/proc/array.c
@@ -430,8 +430,11 @@ static int do_task_stat(struct seq_file
 		 * safe because the task has stopped executing permanently.
 		 */
 		if (permitted && (task->flags & PF_DUMPCORE)) {
-			eip = KSTK_EIP(task);
-			esp = KSTK_ESP(task);
+			if (try_get_task_stack(task)) {
+				eip = KSTK_EIP(task);
+				esp = KSTK_ESP(task);
+				put_task_stack(task);
+			}
 		}
 	}
 
_
