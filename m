From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-char-rio-rio_linuxc.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:51 -0800
Message-ID: <200612072300.kB7N0pkj029678@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51415 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163748AbWLGXBJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/char/rio/rio_linux.c
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-char-rio-rio_linuxc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/char/rio/rio_linux.c
From: Amol Lad <amol@verismonetworks.com>

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/rio/rio_linux.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/char/rio/rio_linux.c~ioremap-balanced-with-iounmap-for-drivers-char-rio-rio_linuxc drivers/char/rio/rio_linux.c
--- a/drivers/char/rio/rio_linux.c~ioremap-balanced-with-iounmap-for-drivers-char-rio-rio_linuxc
+++ a/drivers/char/rio/rio_linux.c
@@ -1026,6 +1026,7 @@ static int __init rio_init(void)
 			found++;
 		} else {
 			iounmap(p->RIOHosts[p->RIONumHosts].Caddr);
+			p->RIOHosts[p->RIONumHosts].Caddr = NULL;
 		}
 	}
 
@@ -1078,6 +1079,7 @@ static int __init rio_init(void)
 			found++;
 		} else {
 			iounmap(p->RIOHosts[p->RIONumHosts].Caddr);
+			p->RIOHosts[p->RIONumHosts].Caddr = NULL;
 		}
 #else
 		printk(KERN_ERR "Found an older RIO PCI card, but the driver is not " "compiled to support it.\n");
@@ -1117,8 +1119,10 @@ static int __init rio_init(void)
 				}
 			}
 
-			if (!okboard)
+			if (!okboard) {
 				iounmap(hp->Caddr);
+				hp->Caddr = NULL;
+			}
 		}
 	}
 
@@ -1188,6 +1192,8 @@ static void __exit rio_exit(void)
 		}
 		/* It is safe/allowed to del_timer a non-active timer */
 		del_timer(&hp->timer);
+		if (hp->Caddr)
+			iounmap(hp->Caddr);
 		if (hp->Type == RIO_PCI)
 			pci_dev_put(hp->pdev);
 	}
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
git-cpufreq.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-megaraidc-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
drivers-isdn-handcrafted-min-max-macro-removal.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
ioremap-balanced-with-iounmap-for-drivers-video-virgefb.patch
ioremap-balanced-with-iounmap-for-drivers-video-vesafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-tridentfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-tgafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-stifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-retz3fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-pvr2fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-platinumfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-offb.patch
ioremap-balanced-with-iounmap-for-drivers-video-macfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-hpfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-fm2fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-ffb.patch
ioremap-balanced-with-iounmap-for-drivers-video-cyberfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-cirrusfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-atyfb_base.patch
ioremap-balanced-with-iounmap-for-drivers-video-atafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-amifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-S3triofb.patch

