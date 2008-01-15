From: akpm@linux-foundation.org
Subject: + pnpacpi-print-resource-shortage-message-only-once-more.patch added to -mm tree
Date: Tue, 15 Jan 2008 02:57:34 -0800
Message-ID: <200801151057.m0FAvESE012119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48859 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbYAOK5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 05:57:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: len.brown@intel.com, oliver.hartkopp@volkswagen.de


The patch titled
     pnpacpi: print resource shortage message only once (more)
has been added to the -mm tree.  Its filename is
     pnpacpi-print-resource-shortage-message-only-once-more.patch

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
Subject: pnpacpi: print resource shortage message only once (more)
From: Len Brown <len.brown@intel.com>

Wups, previous patch was ineffective in 2 cases.

http://bugzilla.kernel.org/show_bug.cgi?id=9535

Signed-off-by: Len Brown <len.brown@intel.com>
Reported-by: "Hartkopp, Oliver (K-EFE/E)" <oliver.hartkopp@volkswagen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/rsparser.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/pnp/pnpacpi/rsparser.c~pnpacpi-print-resource-shortage-message-only-once-more drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnpacpi-print-resource-shortage-message-only-once-more
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -210,6 +210,7 @@ static void pnpacpi_parse_allocated_iore
 	} else {
 		printk(KERN_ERR "pnpacpi: exceeded the max number of IO "
 				"resources: %d \n", PNP_MAX_PORT);
+		warned = 1;
 	}
 }
 
@@ -236,6 +237,7 @@ static void pnpacpi_parse_allocated_memr
 	} else {
 		printk(KERN_ERR "pnpacpi: exceeded the max number of mem "
 				"resources: %d\n", PNP_MAX_MEM);
+		warned = 1;
 	}
 }
 
_

Patches currently in -mm which might be from len.brown@intel.com are

pnpacpi-print-resource-shortage-message-only-once-more.patch
git-acpi.patch
git-libata-all.patch
git-x86.patch
