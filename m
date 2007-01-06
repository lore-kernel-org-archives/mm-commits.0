From: akpm@osdl.org
Subject: - kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs-fix.patch removed from -mm tree
Date: Fri, 05 Jan 2007 16:11:11 -0800
Message-ID: <200701060011.l060BbWS011188@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44628 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbXAFALj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 19:11:39 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l060BbWi014557
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 5 Jan 2007 16:11:38 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, mm-commits@vger.kernel.org


The patch titled
     kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs-fix
has been removed from the -mm tree.  Its filename was
     kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs-fix.patch

This patch was dropped because it was folded into kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs.patch

------------------------------------------------------
Subject: kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs-fix
From: Andrew Morton <akpm@osdl.org>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/params.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/params.c~kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs-fix kernel/params.c
--- a/kernel/params.c~kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs-fix
+++ a/kernel/params.c
@@ -146,10 +146,11 @@ int parse_args(const char *name,
 		int irq_was_disabled;
 
 		args = next_arg(args, &param, &val);
-		irq_was_disabled=irqs_disabled();
+		irq_was_disabled = irqs_disabled();
 		ret = parse_one(param, val, params, num, unknown);
-		if(irq_was_disabled && !irqs_disabled()) {
-			printk(KERN_WARNING "parse_args(): option '%s' enabled irq's!\n",param);
+		if (irq_was_disabled && !irqs_disabled()) {
+			printk(KERN_WARNING "parse_args(): option '%s' enabled "
+					"irq's!\n", param);
 		}
 		switch (ret) {
 		case -ENOENT:
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again.patch
kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs.patch
kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs-fix.patch
pci-prevent-down_read-when-pci_devices-is-empty-fix.patch
atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy.patch
ip2-warning-fix.patch
pci-avoid-taking-pci_bus_sem-early-in-boot.patch
shrink_all_memory-fix-lru_pages-handling.patch
