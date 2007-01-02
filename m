From: akpm@osdl.org
Subject: + kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:49:43 -0800
Message-ID: <200701022149.l02Lnhvc030889@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35721 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964894AbXABVtx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:49:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ard@telegraafnet.nl


The patch titled
     kernelparams: detect if and which parameter parsing enabled irq's
has been added to the -mm tree.  Its filename is
     kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernelparams: detect if and which parameter parsing enabled irq's
From: Ard van Breemen <ard@telegraafnet.nl>

The parsing of some kernel parameters seem to enable irq's at a stage that
irq's are not supposed to be enabled (Particularly the ide kernel parameters).
 Having irq's enabled before the irq controller is initialized might lead to a
kernel panic.  This patch only detects this behaviour and warns about wich
parameter caused it.

Signed-off-by: Ard van Breemen <ard@telegraafnet.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/params.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN kernel/params.c~kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs kernel/params.c
--- a/kernel/params.c~kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs
+++ a/kernel/params.c
@@ -143,9 +143,14 @@ int parse_args(const char *name,
 
 	while (*args) {
 		int ret;
+		int irq_was_disabled;
 
 		args = next_arg(args, &param, &val);
+		irq_was_disabled=irqs_disabled();
 		ret = parse_one(param, val, params, num, unknown);
+		if(irq_was_disabled && !irqs_disabled()) {
+			printk(KERN_WARNING "parse_args(): option '%s' enabled irq's!\n",param);
+		}
 		switch (ret) {
 		case -ENOENT:
 			printk(KERN_ERR "%s: Unknown parameter `%s'\n",
_

Patches currently in -mm which might be from ard@telegraafnet.nl are

start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again.patch
kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs.patch
pci-prevent-down_read-when-pci_devices-is-empty.patch
pci-avoid-taking-pci_bus_sem-early-in-boot.patch
down_write-preserve-local-irqs.patch
