From: akpm@linux-foundation.org
Subject: + drivers-serial-8250_earlyc-print-early-console-device-address-in-hex.patch added to -mm tree
Date: Thu, 12 Aug 2010 12:22:57 -0700
Message-ID: <201008121922.o7CJMvqB008155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760813Ab0HLTXA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 15:23:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tony.luck@intel.com, greg@kroah.com


The patch titled
     drivers/serial/8250_early.c: print early console device address in hex
has been added to the -mm tree.  Its filename is
     drivers-serial-8250_earlyc-print-early-console-device-address-in-hex.patch

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
Subject: drivers/serial/8250_early.c: print early console device address in hex
From: "Luck, Tony" <tony.luck@intel.com>

Device addresses are usually printed in hex.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_early.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/8250_early.c~drivers-serial-8250_earlyc-print-early-console-device-address-in-hex drivers/serial/8250_early.c
--- a/drivers/serial/8250_early.c~drivers-serial-8250_earlyc-print-early-console-device-address-in-hex
+++ a/drivers/serial/8250_early.c
@@ -203,13 +203,13 @@ static int __init parse_options(struct e
 
 	if (mmio || mmio32)
 		printk(KERN_INFO
-		       "Early serial console at MMIO%s 0x%llu (options '%s')\n",
+		       "Early serial console at MMIO%s 0x%llx (options '%s')\n",
 			mmio32 ? "32" : "",
 			(unsigned long long)port->mapbase,
 			device->options);
 	else
 		printk(KERN_INFO
-		      "Early serial console at I/O port 0x%lu (options '%s')\n",
+		      "Early serial console at I/O port 0x%lx (options '%s')\n",
 			port->iobase,
 			device->options);
 
_

Patches currently in -mm which might be from tony.luck@intel.com are

origin.patch
linux-next.patch
drivers-serial-8250_earlyc-print-early-console-device-address-in-hex.patch

