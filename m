From: akpm@linux-foundation.org
Subject: + ata-pata_arasan-remove-conditional-compilation-of-clk-code.patch added to -mm tree
Date: Tue, 08 May 2012 15:32:58 -0700
Message-ID: <20120508223258.C9B74A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:51669 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab2EHWdB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 18:33:01 -0400
Received: by vbnl22 with SMTP id l22so256119vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 15:32:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar@st.com, jgarzik@redhat.com, mturquette@linaro.org, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com


The patch titled
     Subject: ata/pata_arasan: remove conditional compilation of clk code
has been added to the -mm tree.  Its filename is
     ata-pata_arasan-remove-conditional-compilation-of-clk-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@st.com>
Subject: ata/pata_arasan: remove conditional compilation of clk code

With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in
clk.h, there is no need to have clk code enclosed in #ifdef
CONFIG_HAVE_CLK, #endif macros.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_arasan_cf.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/ata/pata_arasan_cf.c~ata-pata_arasan-remove-conditional-compilation-of-clk-code drivers/ata/pata_arasan_cf.c
--- a/drivers/ata/pata_arasan_cf.c~ata-pata_arasan-remove-conditional-compilation-of-clk-code
+++ a/drivers/ata/pata_arasan_cf.c
@@ -184,10 +184,8 @@
 struct arasan_cf_dev {
 	/* pointer to ata_host structure */
 	struct ata_host *host;
-	/* clk structure, only if HAVE_CLK is defined */
-#ifdef CONFIG_HAVE_CLK
+	/* clk structure */
 	struct clk *clk;
-#endif
 
 	/* physical base address of controller */
 	dma_addr_t pbase;
@@ -312,13 +310,11 @@ static int cf_init(struct arasan_cf_dev 
 	unsigned long flags;
 	int ret = 0;
 
-#ifdef CONFIG_HAVE_CLK
 	ret = clk_enable(acdev->clk);
 	if (ret) {
 		dev_dbg(acdev->host->dev, "clock enable failed");
 		return ret;
 	}
-#endif
 
 	spin_lock_irqsave(&acdev->host->lock, flags);
 	/* configure CF interface clock */
@@ -344,9 +340,7 @@ static void cf_exit(struct arasan_cf_dev
 	writel(readl(acdev->vbase + OP_MODE) & ~CFHOST_ENB,
 			acdev->vbase + OP_MODE);
 	spin_unlock_irqrestore(&acdev->host->lock, flags);
-#ifdef CONFIG_HAVE_CLK
 	clk_disable(acdev->clk);
-#endif
 }
 
 static void dma_callback(void *dev)
@@ -828,13 +822,11 @@ static int __devinit arasan_cf_probe(str
 		return -ENOMEM;
 	}
 
-#ifdef CONFIG_HAVE_CLK
 	acdev->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(acdev->clk)) {
 		dev_warn(&pdev->dev, "Clock not found\n");
 		return PTR_ERR(acdev->clk);
 	}
-#endif
 
 	/* allocate host */
 	host = ata_host_alloc(&pdev->dev, 1);
@@ -899,9 +891,7 @@ static int __devinit arasan_cf_probe(str
 			&arasan_cf_sht);
 
 free_clk:
-#ifdef CONFIG_HAVE_CLK
 	clk_put(acdev->clk);
-#endif
 	return ret;
 }
 
@@ -912,9 +902,7 @@ static int __devexit arasan_cf_remove(st
 
 	ata_host_detach(host);
 	cf_exit(acdev);
-#ifdef CONFIG_HAVE_CLK
 	clk_put(acdev->clk);
-#endif
 
 	return 0;
 }
_
Subject: Subject: ata/pata_arasan: remove conditional compilation of clk code

Patches currently in -mm which might be from viresh.kumar@st.com are

linux-next.patch
drivers-thermal-spear_thermalc-add-device-tree-probing-capability.patch
clk-add-non-config_have_clk-routines.patch
clk-remove-redundant-depends-on-from-drivers-kconfig.patch
i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch
usb-marvell-remove-conditional-compilation-of-clk-code.patch
usb-musb-remove-conditional-compilation-of-clk-code.patch
ata-pata_arasan-remove-conditional-compilation-of-clk-code.patch
ata-sata_mv-remove-conditional-compilation-of-clk-code.patch
net-c_can-remove-conditional-compilation-of-clk-code.patch
net-stmmac-remove-conditional-compilation-of-clk-code.patch
gadget-m66592-remove-conditional-compilation-of-clk-code.patch
gadget-r8a66597-remove-conditional-compilation-of-clk-code.patch
usb-host-r8a66597-remove-conditional-compilation-of-clk-code.patch
rtc-spear-add-device-tree-probing-capability.patch

