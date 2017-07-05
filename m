From: akpm@linux-foundation.org
Subject: + frv-tlbflush-move-asmlinkage-before-return-type.patch added to
 -mm tree
Date: Wed, 05 Jul 2017 13:45:12 -0700
Message-ID: <595d4fd8.O/kYvwOsj/3CdDXW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54684 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753445AbdGEUpX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 16:45:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: FRV: tlbflush: move asmlinkage before return type
has been added to the -mm tree.  Its filename is
     frv-tlbflush-move-asmlinkage-before-return-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frv-tlbflush-move-asmlinkage-before-return-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/frv-tlbflush-move-asmlinkage-before-return-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: FRV: tlbflush: move asmlinkage before return type

Make the use of asmlinkage like the rest of the kernel.

Link: http://lkml.kernel.org/r/efb2dfed4d9315bf68ec0334c81b65af176a0174.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/tlbflush.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/frv/include/asm/tlbflush.h~frv-tlbflush-move-asmlinkage-before-return-type arch/frv/include/asm/tlbflush.h
--- a/arch/frv/include/asm/tlbflush.h~frv-tlbflush-move-asmlinkage-before-return-type
+++ a/arch/frv/include/asm/tlbflush.h
@@ -18,10 +18,10 @@
 #ifdef CONFIG_MMU
 
 #ifndef __ASSEMBLY__
-extern void asmlinkage __flush_tlb_all(void);
-extern void asmlinkage __flush_tlb_mm(unsigned long contextid);
-extern void asmlinkage __flush_tlb_page(unsigned long contextid, unsigned long start);
-extern void asmlinkage __flush_tlb_range(unsigned long contextid,
+extern asmlinkage void __flush_tlb_all(void);
+extern asmlinkage void __flush_tlb_mm(unsigned long contextid);
+extern asmlinkage void __flush_tlb_page(unsigned long contextid, unsigned long start);
+extern asmlinkage void __flush_tlb_range(unsigned long contextid,
 					 unsigned long start, unsigned long end);
 #endif /* !__ASSEMBLY__ */
 
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
checkpatch-improve-tests-for-multiple-line-function-definitions.patch
checkpatch-improve-macro-reuse-test.patch
checkpatch-improve-multi-line-alignment-test.patch
checkpatch-improve-the-storage_class-test.patch
arm-kvm-move-asmlinkage-before-type.patch
arm-hp-jornada-7xx-move-inline-before-return-type.patch
cris-gpio-move-inline-before-return-type.patch
frv-tlbflush-move-asmlinkage-before-return-type.patch
ia64-move-inline-before-return-type.patch
ia64-sn-pci-move-inline-before-type.patch
m68k-coldfire-move-inline-before-return-type.patch
mips-smp-move-asmlinkage-before-return-type.patch
sh-move-inline-before-return-type.patch
x86-efi-move-asmlinkage-before-return-type.patch
drivers-s390-move-static-and-inline-before-return-type.patch
drivers-tty-serial-move-inline-before-return-type.patch
usb-serial-safe_serial-move-__inline__-before-return-type.patch
video-fbdev-intelfb-move-inline-before-return-type.patch
video-fbdev-omap-move-inline-before-return-type.patch
arm-samsung-usb-ohci-move-inline-before-return-type.patch
alsa-opl4-move-inline-before-return-type.patch

