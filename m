From: akpm@linux-foundation.org
Subject: [patch 076/162] mn10300: let exit_fpu accept a task
Date: Fri, 20 May 2016 17:00:11 -0700
Message-ID: <573fa50b.g/kXavvu4l/DpXyc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbcEUAAP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:00:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jslaby@suse.cz, a-jacquiot@ti.com, benh@kernel.crashing.org, catalin.marinas@arm.com, chris@zankel.net, cmetcalf@mellanox.com, dalias@libc.org, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, egtvedt@samfundet.no, fenghua.yu@intel.com, geert@linux-m68k.org, gxt@mprc.pku.edu.cn, heiko.carstens@de.ibm.com, hpa@zytor.com, hskinnemoen@gmail.com, ink@jurassic.park.msu.ru, james.hogan@imgtec.com, jcmvbkbc@gmail.com, jdike@addtoit.com, jejb@parisc-linux.org, jesper.nilsson@axis.com, jonas@southpole.se, lennox.wu@gmail.com, lftan@altera.com, linux@arm.linux.org.uk, liqin.linux@gmail.com, mattst88@gmail.com, mingo@redhat.com, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, realmz6@gmail.com, richard@nod.at, rkuo@cod

From: Jiri Slaby <jslaby@suse.cz>
Subject: mn10300: let exit_fpu accept a task

We need to call exit_thread from copy_process in a fail path.  Since
exit_thread on mn10300 calls exit_thread_runtime_instr, make it accept
task_struct as a parameter now.

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

 arch/mn10300/include/asm/fpu.h |    6 ++----
 arch/mn10300/kernel/process.c  |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff -puN arch/mn10300/include/asm/fpu.h~mn10300-let-exit_fpu-accept-a-task arch/mn10300/include/asm/fpu.h
--- a/arch/mn10300/include/asm/fpu.h~mn10300-let-exit_fpu-accept-a-task
+++ a/arch/mn10300/include/asm/fpu.h
@@ -76,11 +76,9 @@ static inline void unlazy_fpu(struct tas
 	preempt_enable();
 }
 
-static inline void exit_fpu(void)
+static inline void exit_fpu(struct task_struct *tsk)
 {
 #ifdef CONFIG_LAZY_SAVE_FPU
-	struct task_struct *tsk = current;
-
 	preempt_disable();
 	if (fpu_state_owner == tsk)
 		fpu_state_owner = NULL;
@@ -123,7 +121,7 @@ static inline void fpu_init_state(void)
 static inline void fpu_save(struct fpu_state_struct *s) {}
 static inline void fpu_kill_state(struct task_struct *tsk) {}
 static inline void unlazy_fpu(struct task_struct *tsk) {}
-static inline void exit_fpu(void) {}
+static inline void exit_fpu(struct task_struct *tsk) {}
 static inline void flush_fpu(void) {}
 static inline int fpu_setup_sigcontext(struct fpucontext *buf) { return 0; }
 static inline int fpu_restore_sigcontext(struct fpucontext *buf) { return 0; }
diff -puN arch/mn10300/kernel/process.c~mn10300-let-exit_fpu-accept-a-task arch/mn10300/kernel/process.c
--- a/arch/mn10300/kernel/process.c~mn10300-let-exit_fpu-accept-a-task
+++ a/arch/mn10300/kernel/process.c
@@ -105,7 +105,7 @@ void show_regs(struct pt_regs *regs)
  */
 void exit_thread(void)
 {
-	exit_fpu();
+	exit_fpu(current);
 }
 
 void flush_thread(void)
_
