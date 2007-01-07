From: akpm@osdl.org
Subject: - kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:58:04 -0800
Message-ID: <200701070758.l077w4Zn012930@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40699 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433AbXAGH6I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:58:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard@telegraafnet.nl, mm-commits@vger.kernel.org


The patch titled
     kernelparams: detect if and which parameter parsing enabled irq's
has been removed from the -mm tree.  Its filename was
     kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernelparams: detect if and which parameter parsing enabled irq's
From: Ard van Breemen <ard@telegraafnet.nl>

The parsing of some kernel parameters seem to enable irq's at a stage that
irq's are not supposed to be enabled (Particularly the ide kernel parameters).

Having irq's enabled before the irq controller is initialized might lead to a
kernel panic.  This patch only detects this behaviour and warns about wich
parameter caused it.

[akpm@osdl.org: cleanups]
Signed-off-by: Ard van Breemen <ard@telegraafnet.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/params.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/params.c~kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs kernel/params.c
--- a/kernel/params.c~kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs
+++ a/kernel/params.c
@@ -143,9 +143,15 @@ int parse_args(const char *name,
 
 	while (*args) {
 		int ret;
+		int irq_was_disabled;
 
 		args = next_arg(args, &param, &val);
+		irq_was_disabled = irqs_disabled();
 		ret = parse_one(param, val, params, num, unknown);
+		if (irq_was_disabled && !irqs_disabled()) {
+			printk(KERN_WARNING "parse_args(): option '%s' enabled "
+					"irq's!\n", param);
+		}
 		switch (ret) {
 		case -ENOENT:
 			printk(KERN_ERR "%s: Unknown parameter `%s'\n",
_

Patches currently in -mm which might be from ard@telegraafnet.nl are

pci-prevent-down_read-when-pci_devices-is-empty.patch
