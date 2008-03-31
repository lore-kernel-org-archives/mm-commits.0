From: akpm@linux-foundation.org
Subject: - 3w-raid-drivers-memset-not-needed-in-probe.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:19:00 -0700
Message-ID: <200803312019.m2VKJ0NT024099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754382AbYCaUTw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:19:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, linuxraid@amcc.com, mm-commits@vger.kernel.org


The patch titled
     3W RAID drivers: memset not needed in probe
has been removed from the -mm tree.  Its filename was
     3w-raid-drivers-memset-not-needed-in-probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 3W RAID drivers: memset not needed in probe
From: Denis Cheng <crquan@gmail.com>

The memory return from scsi_host_alloc is alloced by kzalloc, which is
already zero initilized, so memset not needed.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Acked-by: Adam Radford <linuxraid@amcc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/3w-9xxx.c |    2 --
 drivers/scsi/3w-xxxx.c |    2 --
 2 files changed, 4 deletions(-)

diff -puN drivers/scsi/3w-9xxx.c~3w-raid-drivers-memset-not-needed-in-probe drivers/scsi/3w-9xxx.c
--- a/drivers/scsi/3w-9xxx.c~3w-raid-drivers-memset-not-needed-in-probe
+++ a/drivers/scsi/3w-9xxx.c
@@ -2029,8 +2029,6 @@ static int __devinit twa_probe(struct pc
 	}
 	tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	memset(tw_dev, 0, sizeof(TW_Device_Extension));
-
 	/* Save values to device extension */
 	tw_dev->host = host;
 	tw_dev->tw_pci_dev = pdev;
diff -puN drivers/scsi/3w-xxxx.c~3w-raid-drivers-memset-not-needed-in-probe drivers/scsi/3w-xxxx.c
--- a/drivers/scsi/3w-xxxx.c~3w-raid-drivers-memset-not-needed-in-probe
+++ a/drivers/scsi/3w-xxxx.c
@@ -2295,8 +2295,6 @@ static int __devinit tw_probe(struct pci
 	}
 	tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	memset(tw_dev, 0, sizeof(TW_Device_Extension));
