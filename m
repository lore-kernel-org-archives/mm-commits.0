From: akpm@osdl.org
Subject: - start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again-fix.patch removed from -mm tree
Date: Fri, 05 Jan 2007 16:10:55 -0800
Message-ID: <200701060011.l060BMCa011162@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44584 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbXAFALX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 19:11:23 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l060BMWi014544
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 5 Jan 2007 16:11:22 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, mm-commits@vger.kernel.org


The patch titled
     start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again-fix
has been removed from the -mm tree.  Its filename was
     start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again-fix.patch

This patch was dropped because it was folded into start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again.patch

------------------------------------------------------
Subject: start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again-fix
From: Andrew Morton <akpm@osdl.org>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 init/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN init/main.c~start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again-fix init/main.c
--- a/init/main.c~start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again-fix
+++ a/init/main.c
@@ -539,7 +539,8 @@ asmlinkage void __init start_kernel(void
 		   __stop___param - __start___param,
 		   &unknown_bootoption);
 	if (!irqs_disabled()) {
-		printk(KERN_WARNING "start_kernel(): bug: interrupts were enabled *very* early, fixing it\n");
+		printk(KERN_WARNING "start_kernel(): bug: interrupts were "
+				"enabled *very* early, fixing it\n");
 		local_irq_disable();
 	}
 	sort_main_extable();
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again.patch
start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again-fix.patch
kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs-fix.patch
pci-prevent-down_read-when-pci_devices-is-empty-fix.patch
atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy.patch
ip2-warning-fix.patch
pci-avoid-taking-pci_bus_sem-early-in-boot.patch
shrink_all_memory-fix-lru_pages-handling.patch
