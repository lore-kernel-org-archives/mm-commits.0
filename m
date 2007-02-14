From: akpm@linux-foundation.org
Subject: + fix--confusion-in-fusion-driver.patch added to -mm tree
Date: Wed, 14 Feb 2007 13:08:07 -0800
Message-ID: <200702142108.l1EL87gC009119@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45677 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932589AbXBNVIO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 16:08:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmueller@osuse.de, James.Bottomley@SteelEye.com, eric.moore@lsi.com


The patch titled
     Fix |/|| confusion in fusion driver
has been added to the -mm tree.  Its filename is
     fix--confusion-in-fusion-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix |/|| confusion in fusion driver
From: Dirk Mueller <dmueller@osuse.de>

This patch corrects a |/|| confusion in mptscsih_copy_sense_data.  Using ||
means that the data that ends up being written is (almost always) 1,
instead of being bit-wise or'ed.

Cc: Eric Moore <eric.moore@lsi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptscsih.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/message/fusion/mptscsih.c~fix--confusion-in-fusion-driver drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~fix--confusion-in-fusion-driver
+++ a/drivers/message/fusion/mptscsih.c
@@ -2474,9 +2474,9 @@ mptscsih_copy_sense_data(struct scsi_cmn
 				ioc->events[idx].event = MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE;
 				ioc->events[idx].eventContext = ioc->eventContext;
 
-				ioc->events[idx].data[0] = (pReq->LUN[1] << 24) ||
-					(MPI_EVENT_SCSI_DEV_STAT_RC_SMART_DATA << 16) ||
-					(sc->device->channel << 8) || sc->device->id;
+				ioc->events[idx].data[0] = (pReq->LUN[1] << 24) |
+					(MPI_EVENT_SCSI_DEV_STAT_RC_SMART_DATA << 16) |
+					(sc->device->channel << 8) | sc->device->id;
 
 				ioc->events[idx].data[1] = (sense_data[13] << 8) || sense_data[12];
 
_

Patches currently in -mm which might be from dmueller@osuse.de are

fix--confusion-in-fusion-driver.patch
