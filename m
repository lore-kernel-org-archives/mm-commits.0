From: akpm@linux-foundation.org
Subject: [merged] m32r-fix-build-warning.patch removed from -mm tree
Date: Wed, 14 Dec 2016 11:22:56 -0800
Message-ID: <58519c10.pSaCYpG/g38SsSZA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43828 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756499AbcLNTW5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:22:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: fix build warning
has been removed from the -mm tree.  Its filename was
     m32r-fix-build-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: m32r: fix build warning

While building m32r defconfig we got warnings:

arch/m32r/platforms/m32700ut/setup.c:249:24: warning:
  'm32700ut_lcdpld_irq_type' defined but not used [-Wunused-variable]

m32700ut_lcdpld_irq_type is only used when CONFIG_USB is enabled.
Modify the code to declare the related variables and functions only
when CONFIG_USB is enabled.

Link: http://lkml.kernel.org/r/1479244406-7507-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/platforms/m32700ut/setup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/m32r/platforms/m32700ut/setup.c~m32r-fix-build-warning arch/m32r/platforms/m32700ut/setup.c
--- a/arch/m32r/platforms/m32700ut/setup.c~m32r-fix-build-warning
+++ a/arch/m32r/platforms/m32700ut/setup.c
@@ -201,6 +201,7 @@ static struct irq_chip m32700ut_lanpld_i
 #define lcdpldirq2port(x)	(unsigned long)((int)M32700UT_LCD_ICUCR1 + \
 				 (((x) - 1) * sizeof(unsigned short)))
 
+#ifdef CONFIG_USB
 static pld_icu_data_t lcdpld_icu_data[M32700UT_NUM_LCD_PLD_IRQ];
 
 static void disable_m32700ut_lcdpld_irq(unsigned int irq)
@@ -253,6 +254,7 @@ static struct irq_chip m32700ut_lcdpld_i
 	.irq_mask	= mask_m32700ut_lcdpld,
 	.irq_unmask	= unmask_m32700ut_lcdpld,
 };
+#endif
 
 void __init init_IRQ(void)
 {
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are


