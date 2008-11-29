From: akpm@linux-foundation.org
Subject: + i82875p_edac-fix-overflow-device-resource-setup.patch added to -mm tree
Date: Fri, 28 Nov 2008 23:56:53 -0800
Message-ID: <200811290756.mAT7uroJ003205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbYK2H5N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 02:57:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlavi@iki.fi, alan@lxorguk.ukuu.org.uk, jbarnes@virtuousgeek.org, norsk5@yahoo.com


The patch titled
     i82875p_edac: fix overflow device resource setup
has been added to the -mm tree.  Its filename is
     i82875p_edac-fix-overflow-device-resource-setup.patch

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
Subject: i82875p_edac: fix overflow device resource setup
From: Jarkko Lavinen <jlavi@iki.fi>

When I do "modprobe i82875p_edac" on my Asus P4C800 MB on kernels 2.6.26
or later, the module load fails due to BAR 0 collision.  On 2.6.25 the
module loads just fine.

The overflow device on the MB seems to be hidden and its resources are not
allocated at normal PCI bus init.  Log shows the missing resource problem:

  EDAC DEBUG: i82875p_probe1()
  PCI: 0000:00:06.0 reg 10 32bit mmio: [fecf0000, fecf0fff]
  pci 0000:00:06.0: device not available because of BAR 0
[0xfecf0000-0xfecf0fff] collisions
  EDAC i82875p: i82875p_setup_overfl_dev(): Failed to enable overflow
device

The patch below fixes this by calling pci_bus_assign_resources() after
the overflow device is revealed and added to the bus. With this patch
I am again able to load and use the module.

Signed-off-by: Jarkko Lavinen <jlavi@iki.fi>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i82875p_edac.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/edac/i82875p_edac.c~i82875p_edac-fix-overflow-device-resource-setup drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~i82875p_edac-fix-overflow-device-resource-setup
+++ a/drivers/edac/i82875p_edac.c
@@ -295,6 +295,7 @@ static int i82875p_setup_overfl_dev(stru
 				"%s(): pci_bus_add_device() Failed\n",
 				__func__);
 		}
+		pci_bus_assign_resources(dev->bus);
 	}
 
 	*ovrfl_pdev = dev;
_

Patches currently in -mm which might be from jlavi@iki.fi are

i82875p_edac-fix-overflow-device-resource-setup.patch
i82875p_edac-fix-module-remove.patch

