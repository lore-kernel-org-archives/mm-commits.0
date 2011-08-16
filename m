From: akpm@linux-foundation.org
Subject: [merged] cris-add-missing-declaration-of-kgdb_init-and-breakpoint.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:50:54 -0700
Message-ID: <201108161848.p7GIm1UM015208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab1HPSsp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:48:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, geert@linux-m68k.org, jesper.nilsson@axis.com, stable@kernel.org, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: add missing declaration of kgdb_init() and breakpoint()
has been removed from the -mm tree.  Its filename was
     cris-add-missing-declaration-of-kgdb_init-and-breakpoint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: add missing declaration of kgdb_init() and breakpoint()
From: WANG Cong <xiyou.wangcong@gmail.com>

arch/cris/arch-v10/kernel/irq.c:239: error: implicit declaration of function 'kgdb_init'
arch/cris/arch-v10/kernel/irq.c:240: error: implicit declaration of function 'breakpoint'

Declare these two functions.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/irq.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/cris/arch-v10/kernel/irq.c~cris-add-missing-declaration-of-kgdb_init-and-breakpoint arch/cris/arch-v10/kernel/irq.c
--- a/arch/cris/arch-v10/kernel/irq.c~cris-add-missing-declaration-of-kgdb_init-and-breakpoint
+++ a/arch/cris/arch-v10/kernel/irq.c
@@ -20,6 +20,9 @@
 #define crisv10_mask_irq(irq_nr) (*R_VECT_MASK_CLR = 1 << (irq_nr));
 #define crisv10_unmask_irq(irq_nr) (*R_VECT_MASK_SET = 1 << (irq_nr));
 
+extern void kgdb_init(void);
+extern void breakpoint(void);
+
 /* don't use set_int_vector, it bypasses the linux interrupt handlers. it is
  * global just so that the kernel gdb can use it.
  */
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
kexec-remove-kmsg_dump_kexec.patch

