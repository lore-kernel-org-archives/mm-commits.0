From: akpm@linux-foundation.org
Subject: + cris-add-missing-declaration-of-kgdb_init-and-breakpoint.patch added to -mm tree
Date: Wed, 01 Jun 2011 15:12:23 -0700
Message-ID: <201106012212.p51MCNCI012660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355Ab1FAWMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 18:12:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, geert@linux-m68k.org, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris: add missing declaration of kgdb_init() and breakpoint()
has been added to the -mm tree.  Its filename is
     cris-add-missing-declaration-of-kgdb_init-and-breakpoint.patch

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
Subject: cris: add missing declaration of kgdb_init() and breakpoint()
From: WANG Cong <xiyou.wangcong@gmail.com>

arch/cris/arch-v10/kernel/irq.c:239: error: implicit declaration of function 'kgdb_init'
arch/cris/arch-v10/kernel/irq.c:240: error: implicit declaration of function 'breakpoint'

Declare these two functions.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>

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

cris-fix-a-build-error-in-kernel-forkc.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
cris-fix-a-build-error-in-sync_serial_open.patch
cris-fix-the-prototype-of-sync_serial_ioctl.patch
cris-add-missing-declaration-of-kgdb_init-and-breakpoint.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

