From: akpm@linux-foundation.org
Subject: [patch 079/162] fork: free thread in copy_process on failure
Date: Fri, 20 May 2016 17:00:25 -0700
Message-ID: <573fa519.Pzg78T/bY3FcUWNR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbcEUAAa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:00:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jslaby@suse.cz, a-jacquiot@ti.com, benh@kernel.crashing.org, catalin.marinas@arm.com, chris@zankel.net, cmetcalf@mellanox.com, dalias@libc.org, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, egtvedt@samfundet.no, fenghua.yu@intel.com, geert@linux-m68k.org, gxt@mprc.pku.edu.cn, heiko.carstens@de.ibm.com, hpa@zytor.com, hskinnemoen@gmail.com, ink@jurassic.park.msu.ru, james.hogan@imgtec.com, jcmvbkbc@gmail.com, jdike@addtoit.com, jejb@parisc-linux.org, jesper.nilsson@axis.com, jonas@southpole.se, lennox.wu@gmail.com, lftan@altera.com, linux@arm.linux.org.uk, liqin.linux@gmail.com, mattst88@gmail.com, mingo@redhat.com, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, realmz6@gmail.com, richard@nod.at, rkuo@cod

From: Jiri Slaby <jslaby@suse.cz>
Subject: fork: free thread in copy_process on failure

When using this program (as root):
	#include <err.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <unistd.h>

	#include <sys/io.h>
	#include <sys/types.h>
	#include <sys/wait.h>

	#define ITER 1000
	#define FORKERS 15
	#define THREADS (6000/FORKERS) // 1850 is proc max

	static void fork_100_wait()
	{
		unsigned a, to_wait = 0;

		printf("\t%d forking %d\n", THREADS, getpid());

		for (a = 0; a < THREADS; a++) {
			switch (fork()) {
			case 0:
				usleep(1000);
				exit(0);
				break;
			case -1:
				break;
			default:
				to_wait++;
				break;
			}
		}

		printf("\t%d forked from %d, waiting for %d\n", THREADS, getpid(),
				to_wait);

		for (a = 0; a < to_wait; a++)
			wait(NULL);

		printf("\t%d waited from %d\n", THREADS, getpid());
	}

	static void run_forkers()
	{
		pid_t forkers[FORKERS];
		unsigned a;

		for (a = 0; a < FORKERS; a++) {
			switch ((forkers[a] = fork())) {
			case 0:
				fork_100_wait();
				exit(0);
				break;
			case -1:
				err(1, "DIE fork of %d'th forker", a);
				break;
			default:
				break;
			}
		}

		for (a = 0; a < FORKERS; a++)
			waitpid(forkers[a], NULL, 0);
	}

	int main()
	{
		unsigned a;
		int ret;

		ret = ioperm(10, 20, 0);
		if (ret < 0)
			err(1, "ioperm");

		for (a = 0; a < ITER; a++)
			run_forkers();

		return 0;
	}

kmemleak reports many occurences of this leak:
unreferenced object 0xffff8805917c8000 (size 8192):
  comm "fork-leak", pid 2932, jiffies 4295354292 (age 1871.028s)
  hex dump (first 32 bytes):
    ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
    ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
  backtrace:
    [<ffffffff814cfbf5>] kmemdup+0x25/0x50
    [<ffffffff8103ab43>] copy_thread_tls+0x6c3/0x9a0
    [<ffffffff81150174>] copy_process+0x1a84/0x5790
    [<ffffffff811dc375>] wake_up_new_task+0x2d5/0x6f0
    [<ffffffff8115411d>] _do_fork+0x12d/0x820
...

Due to the leakage of the memory items which should have been freed in
arch/x86/kernel/process.c:exit_thread().

Make sure the memory is freed when fork fails later in copy_process.
This is done by calling exit_thread with the thread to kill.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Howells <dhowells@redhat.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Ley Foon Tan <lftan@altera.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/fork.c~fork-free-thread-in-copy_process-on-failure kernel/fork.c
--- a/kernel/fork.c~fork-free-thread-in-copy_process-on-failure
+++ a/kernel/fork.c
@@ -1490,7 +1490,7 @@ static struct task_struct *copy_process(
 		pid = alloc_pid(p->nsproxy->pid_ns_for_children);
 		if (IS_ERR(pid)) {
 			retval = PTR_ERR(pid);
-			goto bad_fork_cleanup_io;
+			goto bad_fork_cleanup_thread;
 		}
 	}
 
@@ -1652,6 +1652,8 @@ bad_fork_cancel_cgroup:
 bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
+bad_fork_cleanup_thread:
+	exit_thread(p);
 bad_fork_cleanup_io:
 	if (p->io_context)
 		exit_io_context(p);
_
