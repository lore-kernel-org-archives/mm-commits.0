From: akpm@linux-foundation.org
Subject: [wrecked] keep-track-of-network-interface-renaming.patch removed from -mm tree
Date: Thu, 19 Nov 2009 13:34:45 -0800
Message-ID: <200911192134.nAJLYjQD022272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756793AbZKSVfL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Nov 2009 16:35:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, mm-commits@vger.kernel.org


The patch titled
     keep track of network interface renaming
has been removed from the -mm tree.  Its filename was
     keep-track-of-network-interface-renaming.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -969,8 +969,12 @@ int dev_change_name(struct net_device *d
 			return err;
 	} else if (__dev_get_by_name(net, newname))
 		return -EEXIST;
-	else
+	else {
+		if (strncmp(newname, dev->name, IFNAMSIZ))
+			printk(KERN_INFO "%s renamed to %s\n",
+					dev->name, newname);
 		strlcpy(dev->name, newname, IFNAMSIZ);
+	}
 
 rollback:
 	/* For now only devices in the initial network namespace
_

Patches currently in -mm which might be from olaf@aepfle.de are

keep-track-of-network-interface-renaming.patch

