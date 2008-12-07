From: akpm@linux-foundation.org
Subject: + mn10300-remove-pci_dac_dma_-apis.patch added to -mm tree
Date: Sat, 06 Dec 2008 23:41:38 -0800
Message-ID: <200812070741.mB77fc51001927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752684AbYLGHmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 02:42:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, dhowells@redhat.com, jbarnes@virtuousgeek.org, jbeulich@novell.com


The patch titled
     mn10300: remove pci_dac_dma_... APIs
has been added to the -mm tree.  Its filename is
     mn10300-remove-pci_dac_dma_-apis.patch

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
Subject: mn10300: remove pci_dac_dma_... APIs
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

It seems that mn10300 made it upstream after Jan Beulich's pci_dac_dma_*
cleanup work and still defines pci_dac_dma_supported().  This API is not
required by the PCI subsystem anymore, so remove it.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mn10300/pci.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/asm-mn10300/pci.h~mn10300-remove-pci_dac_dma_-apis include/asm-mn10300/pci.h
--- a/include/asm-mn10300/pci.h~mn10300-remove-pci_dac_dma_-apis
+++ a/include/asm-mn10300/pci.h
@@ -70,10 +70,6 @@ struct pci_dev;
  */
 #define PCI_DMA_BUS_IS_PHYS	(1)
 
-
-/* This is always fine. */
-#define pci_dac_dma_supported(pci_dev, mask)	(0)
