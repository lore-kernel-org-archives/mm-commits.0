From: akpm@linux-foundation.org
Subject: + pci-fix-printk-warnings-in-setup-busc.patch added to -mm tree
Date: Fri, 22 Aug 2008 11:58:37 -0700
Message-ID: <200808221858.m7MIwbsb011120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491AbYHVS7T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 14:59:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johfel@users.sourceforge.net


The patch titled
     pci: fix printk warnings in setup-bus.c
has been added to the -mm tree.  Its filename is
     pci-fix-printk-warnings-in-setup-busc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: fix printk warnings in setup-bus.c
From: Johann Felix Soden <johfel@users.sourceforge.net>

drivers/pci/setup-bus.c: In function 'pci_bus_dump_res':
drivers/pci/setup-bus.c:542: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'resource_size_t'
drivers/pci/setup-bus.c:542: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'resource_size_t'

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/setup-bus.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/pci/setup-bus.c~pci-fix-printk-warnings-in-setup-busc drivers/pci/setup-bus.c
--- a/drivers/pci/setup-bus.c~pci-fix-printk-warnings-in-setup-busc
+++ a/drivers/pci/setup-bus.c
@@ -539,7 +539,11 @@ static void pci_bus_dump_res(struct pci_
                 if (!res)
                         continue;
 
-		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n", bus->number, i, (res->flags & IORESOURCE_IO)? "io port":"mmio", res->start, res->end);
+		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n",
+			bus->number, i,
+			(res->flags & IORESOURCE_IO) ? "io port" : "mmio",
+			(unsigned long long) res->start,
+			(unsigned long long) res->end);
         }
 }
 
_

Patches currently in -mm which might be from johfel@users.sourceforge.net are

pci-fix-printk-warnings-in-setup-busc.patch

