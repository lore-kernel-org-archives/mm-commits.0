From: akpm@linux-foundation.org
Subject: + change-__init-to-__devinit-for-isp116x_probe.patch added to -mm tree
Date: Fri, 09 Feb 2007 01:51:15 -0800
Message-ID: <200702090951.l199pF03010007@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40234 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946268AbXBIJvY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 04:51:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: prarit@redhat.com, greg@kroah.com


The patch titled
     change __init to __devinit for isp116x_probe
has been added to the -mm tree.  Its filename is
     change-__init-to-__devinit-for-isp116x_probe.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: change __init to __devinit for isp116x_probe
From: Prarit Bhargava <prarit@redhat.com>

Change __init to __devinit for isp116x_probe.

Resolves MODPOST warning:

WARNING: drivers/usb/host/isp116x-hcd.o - Section mismatch: reference to
.init.text:isp116x_probe from .data.rel.local between 'isp116x_driver' (at
offset 0x0) and 'isp116x_hc_driver'

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/isp116x-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/host/isp116x-hcd.c~change-__init-to-__devinit-for-isp116x_probe drivers/usb/host/isp116x-hcd.c
--- a/drivers/usb/host/isp116x-hcd.c~change-__init-to-__devinit-for-isp116x_probe
+++ a/drivers/usb/host/isp116x-hcd.c
@@ -1577,7 +1577,7 @@ static int isp116x_remove(struct platfor
 
 #define resource_len(r) (((r)->end - (r)->start) + 1)
 
-static int __init isp116x_probe(struct platform_device *pdev)
+static int __devinit isp116x_probe(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd;
 	struct isp116x *isp116x;
_

Patches currently in -mm which might be from prarit@redhat.com are

change-__init-to-__devinit-for-isp116x_probe.patch
change-__init-to-__devinit-in-2-rtc-drivers.patch
