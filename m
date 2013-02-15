From: akpm@linux-foundation.org
Subject: + mn10300-use-for_each_pci_dev-to-simplify-the-code.patch added to -mm tree
Date: Thu, 14 Feb 2013 16:12:43 -0800
Message-ID: <20130215001243.95F0231C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:52017 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935136Ab3BOAMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Feb 2013 19:12:44 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so305386yen.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Feb 2013 16:12:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, dhowells@redhat.com


The patch titled
     Subject: mn10300: use for_each_pci_dev to simplify the code
has been added to the -mm tree.  Its filename is
     mn10300-use-for_each_pci_dev-to-simplify-the-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
mn10300-use-for_each_pci_dev-to-simplify-the-code.patch

