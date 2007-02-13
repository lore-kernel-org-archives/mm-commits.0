From: akpm@linux-foundation.org
Subject: + keep-track-of-network-interface-renaming.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:52:26 -0800
Message-ID: <200702130552.l1D5qQ6w023133@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55638 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbXBMFw3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:52:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de


The patch titled
     keep track of network interface renaming
has been added to the -mm tree.  Its filename is
     keep-track-of-network-interface-renaming.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: keep track of network interface renaming
From: Olaf Hering <olaf@aepfle.de>

On Sun, Feb 11, Paul Rolland wrote:

> I'm facing something quite strange... When booting one of these kernels
> (it's a new machine, I've not been running older kernels), the boot message
> says :
>
> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 19 (level, low) -> IRQ 19
> sky2 v1.10 addr 0xff8fc000 irq 19 Yukon-EC (0xb6) rev 2
> sky2 eth0: addr 00:18:f3:e0:5d:d4
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> sky2 v1.10 addr 0xff7fc000 irq 16 Yukon-EC (0xb6) rev 2
> sky2 eth1: addr 00:18:f3:e0:36:fd
>
> So, I'm expecting two interfaces : eth0 and eth1
>
> Unfortunately, at the end of the boot process, I can find eth1 and eth2,

Unfortunately, this patch was not applied to mainline last year.
Maybe this year.

Keep track about which network interface names were renamed after the
network device driver printed its banner.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/dev.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN net/core/dev.c~keep-track-of-network-interface-renaming net/core/dev.c
--- a/net/core/dev.c~keep-track-of-network-interface-renaming
+++ a/net/core/dev.c
@@ -748,8 +748,12 @@ int dev_change_name(struct net_device *d
 	}
 	else if (__dev_get_by_name(newname))
 		return -EEXIST;
-	else
+	else {
+		if (strncmp(newname, dev->name, IFNAMSIZ))
+			printk(KERN_INFO "%s renamed to %s\n",
+					dev->name, newname);
 		strlcpy(dev->name, newname, IFNAMSIZ);
+	}
 
 	err = device_rename(&dev->dev, dev->name);
 	if (!err) {
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
move-variables-in-drivers-macintosh-to-bss.patch
add-delay-around-sl82c105_reset_engine-calls.patch
cleanup-variable-usage-in-mesh-interrupt-handler.patch
keep-track-of-network-interface-renaming.patch
