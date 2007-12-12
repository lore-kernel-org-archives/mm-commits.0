From: akpm@linux-foundation.org
Subject: + 3w-raid-drivers-memset-not-needed-in-probe.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:24:58 -0800
Message-ID: <200712120524.lBC5Owm7027314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42928 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbXLLFZC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:25:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, linuxraid@amcc.com


The patch titled
     3W RAID drivers: memset not needed in probe
has been added to the -mm tree.  Its filename is
     3w-raid-drivers-memset-not-needed-in-probe.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 3W RAID drivers: memset not needed in probe
From: Denis Cheng <crquan@gmail.com>

The memory return from scsi_host_alloc is alloced by kzalloc, which is
already zero initilized, so memset not needed.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Cc: Adam Radford <linuxraid@amcc.com>
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
-
 	/* Save values to device extension */
 	tw_dev->host = host;
 	tw_dev->tw_pci_dev = pdev;
_

Patches currently in -mm which might be from crquan@gmail.com are

git-net.patch
git-s390.patch
3w-raid-drivers-memset-not-needed-in-probe.patch
git-cryptodev.patch
drivers-char-use-list_head-instead-of-list_head_init.patch
