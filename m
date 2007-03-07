From: akpm@linux-foundation.org
Subject: + netxen-fix-warnings.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:43:09 -0800
Message-ID: <200703070143.l271h9N4015874@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42527 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161178AbXCGBq1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:46:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     netxen: fix warnings
has been added to the -mm tree.  Its filename is
     netxen-fix-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: netxen: fix warnings
From: Ralf Baechle <ralf@linux-mips.org>

  CC [M]  drivers/net/netxen/netxen_nic_hw.o
drivers/net/netxen/netxen_nic_hw.c: In function 'netxen_nic_hw_resources':
drivers/net/netxen/netxen_nic_hw.c:231: warning: format '%llx' expects type 'long long unsigned int', but argument 2 has type 'dma_addr_t'
drivers/net/netxen/netxen_nic_hw.c:250: warning: format '%llx' expects type 'long long unsigned int', but argument 2 has type 'dma_addr_t'

u64 is unsigned long so the cast to u64 will result in a warning on the
printf arguments for 64-bit builds.  So cast to unsigned long long instead.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/netxen/netxen_nic_hw.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/net/netxen/netxen_nic_hw.c~netxen-fix-warnings drivers/net/netxen/netxen_nic_hw.c
--- a/drivers/net/netxen/netxen_nic_hw.c~netxen-fix-warnings
+++ a/drivers/net/netxen/netxen_nic_hw.c
@@ -228,7 +228,7 @@ int netxen_nic_hw_resources(struct netxe
 			    &adapter->ctx_desc_pdev);
 
 	printk("ctx_desc_phys_addr: 0x%llx\n",
-	       (u64) adapter->ctx_desc_phys_addr);
+	       (unsigned long long) adapter->ctx_desc_phys_addr);
 	if (addr == NULL) {
 		DPRINTK(ERR, "bad return from pci_alloc_consistent\n");
 		err = -ENOMEM;
@@ -247,7 +247,8 @@ int netxen_nic_hw_resources(struct netxe
 			    adapter->max_tx_desc_count,
 			    (dma_addr_t *) & hw->cmd_desc_phys_addr,
 			    &adapter->ahw.cmd_desc_pdev);
-	printk("cmd_desc_phys_addr: 0x%llx\n", (u64) hw->cmd_desc_phys_addr);
+	printk("cmd_desc_phys_addr: 0x%llx\n",
+	       (unsigned long long) hw->cmd_desc_phys_addr);
 
 	if (addr == NULL) {
 		DPRINTK(ERR, "bad return from pci_alloc_consistent\n");
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
git-netdev-all.patch
netxen-fix-warnings.patch
div64_64-common-code.patch
serial-driver-pmc-msp71xx.patch
rm9000-serial-driver.patch
rm9000-serial-driver-tidy.patch
x86_64-fix-ia32_binfmtc-build-error.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
simplify-the-stacktrace-code.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
tgafb-turbochannel-support.patch
