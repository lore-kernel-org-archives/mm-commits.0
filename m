From: akpm@linux-foundation.org
Subject: + frv-remove-bogus-no_irq-=-1-define.patch added to -mm tree
Date: Wed, 07 Nov 2007 12:24:26 -0800
Message-ID: <200711072024.lA7KOR7R026139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754330AbXKGUYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2007 15:24:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, dhowells@redhat.com


The patch titled
     From: Alan Cox <alan@lxorguk.ukuu.org.uk>
has been added to the -mm tree.  Its filename is
     frv-remove-bogus-no_irq-=-1-define.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: Alan Cox <alan@lxorguk.ukuu.org.uk>


The old NO_IRQ define some platforms had was long ago declared obsolete
and wrong. FRV should therefore not be re-introducing this, especially as
IRQs are usually unsigned in the kernel. The "no IRQ" case is defined to be
zero and Linus made this rather clear at the time.

arch/frv shows no dependancy on this but it might show up driver fixes
needing doing I guess

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/irq.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/asm-frv/irq.h~frv-remove-bogus-no_irq-=-1-define include/asm-frv/irq.h
--- a/include/asm-frv/irq.h~frv-remove-bogus-no_irq-=-1-define
+++ a/include/asm-frv/irq.h
@@ -12,9 +12,6 @@
 #ifndef _ASM_IRQ_H_
 #define _ASM_IRQ_H_
 
-/* this number is used when no interrupt has been assigned */
-#define NO_IRQ				(-1)
-
 #define NR_IRQS				48
 #define IRQ_BASE_CPU			(0 * 16)
 #define IRQ_BASE_FPGA			(1 * 16)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
frv-remove-bogus-no_irq-=-1-define.patch
git-libata-all.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
quirk_vialatency-omit-reading-pci-revision-id.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
initio-fix-conflict-when-loading-driver.patch
serial-only-use-pnp-irq-if-its-valid.patch
keyspan-init-termios-properly.patch
geode-lists-are-subscriber-only.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
