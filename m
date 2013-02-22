From: akpm@linux-foundation.org
Subject: [merged] mn10300-use-for_each_pci_dev-to-simplify-the-code.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:42 -0800
Message-ID: <20130222203742.9AF045A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:56328 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab3BVUhn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:43 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so118708qaj.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: use for_each_pci_dev to simplify the code
has been removed from the -mm tree.  Its filename was
     mn10300-use-for_each_pci_dev-to-simplify-the-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: mn10300: use for_each_pci_dev to simplify the code

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/unit-asb2305/pci-irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mn10300/unit-asb2305/pci-irq.c~mn10300-use-for_each_pci_dev-to-simplify-the-code arch/mn10300/unit-asb2305/pci-irq.c
--- a/arch/mn10300/unit-asb2305/pci-irq.c~mn10300-use-for_each_pci_dev-to-simplify-the-code
+++ a/arch/mn10300/unit-asb2305/pci-irq.c
@@ -29,7 +29,7 @@ void __init pcibios_fixup_irqs(void)
 	struct pci_dev *dev = NULL;
 	u8 line, pin;
 
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	for_each_pci_dev(dev) {
 		pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 		if (pin) {
 			dev->irq = XIRQ1;
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch
memstick-move-the-dereference-below-the-null-test.patch

