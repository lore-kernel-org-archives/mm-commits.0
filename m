From: akpm@linux-foundation.org
Subject: + rapidio-modify-configuration-to-support-pci-srio-controller-fix-configuration-option.patch added to -mm tree
Date: Fri, 18 Mar 2011 14:09:55 -0700
Message-ID: <201103182109.p2IL9vMm011391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757428Ab1CRVKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Mar 2011 17:10:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, benh@kernel.crashing.org, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     RapidIO,powerpc/85xx: fix configuration option
has been added to the -mm tree.  Its filename is
     rapidio-modify-configuration-to-support-pci-srio-controller-fix-configuration-option.patch

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
Subject: RapidIO,powerpc/85xx: fix configuration option
From: Alexandre Bounine <alexandre.bounine@idt.com>

Follows set of patches in -mm tree. Replaces configuration option
missed in previous patches.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
gAcked-byc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/cpu_setup_fsl_booke.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/cpu_setup_fsl_booke.S~rapidio-modify-configuration-to-support-pci-srio-controller-fix-configuration-option arch/powerpc/kernel/cpu_setup_fsl_booke.S
--- a/arch/powerpc/kernel/cpu_setup_fsl_booke.S~rapidio-modify-configuration-to-support-pci-srio-controller-fix-configuration-option
+++ a/arch/powerpc/kernel/cpu_setup_fsl_booke.S
@@ -64,7 +64,7 @@ _GLOBAL(__setup_cpu_e500v2)
 	bl	__e500_icache_setup
 	bl	__e500_dcache_setup
 	bl	__setup_e500_ivors
-#ifdef CONFIG_RAPIDIO
+#ifdef CONFIG_FSL_RIO
 	/* Ensure that RFXE is set */
 	mfspr	r3,SPRN_HID1
 	oris	r3,r3,HID1_RFXE@h
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-new-sysfs-attributes.patch
rapidio-add-new-sysfs-attributes-v2.patch
rapidio-add-rapidio-documentation.patch
rapidio-add-rapidio-documentation-v2.patch
rapidio-add-architecture-specific-callbacks.patch
rapidio-modify-configuration-to-support-pci-srio-controller.patch
rapidio-modify-configuration-to-support-pci-srio-controller-fix-configuration-option.patch
rapidio-modify-subsystem-and-driver-initialization-sequence.patch
rapidio-modify-mport-id-assignment.patch
rapidio-remove-mport-resource-reservation-from-common-rio-code.patch

