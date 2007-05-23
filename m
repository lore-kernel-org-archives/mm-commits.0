From: akpm@linux-foundation.org
Subject: - fix--confusion-in-fusion-driver.patch removed from -mm tree
Date: Wed, 23 May 2007 13:21:09 -0700
Message-ID: <200705232021.l4NKL8Vf031011@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757005AbXEWUVX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 16:21:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmueller@suse.de, James.Bottomley@SteelEye.com, davej@redhat.com, eric.moore@lsi.com, mm-commits@vger.kernel.org


The patch titled
     Fix |/|| confusion in fusion driver
has been removed from the -mm tree.  Its filename was
     fix--confusion-in-fusion-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix |/|| confusion in fusion driver
From: Dirk Mueller <dmueller@suse.de>

This patch corrects a |/|| confusion in mptscsih_copy_sense_data.  Using ||
means that the data that ends up being written is (almost always) 1,
instead of being bit-wise or'ed.

Acked-by: Eric Moore <eric.moore@lsi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Dave Jones <davej@redhat.com>
[davej@redhat.com: updates]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.h  |    2 +-
 drivers/message/fusion/mptscsih.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/message/fusion/mptscsih.c~fix--confusion-in-fusion-driver drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~fix--confusion-in-fusion-driver
+++ a/drivers/message/fusion/mptscsih.c
@@ -2463,11 +2463,11 @@ mptscsih_copy_sense_data(struct scsi_cmn
 				ioc->events[idx].event = MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE;
 				ioc->events[idx].eventContext = ioc->eventContext;
 
-				ioc->events[idx].data[0] = (pReq->LUN[1] << 24) ||
-					(MPI_EVENT_SCSI_DEV_STAT_RC_SMART_DATA << 16) ||
-					(sc->device->channel << 8) || sc->device->id;
+				ioc->events[idx].data[0] = (pReq->LUN[1] << 24) |
+					(MPI_EVENT_SCSI_DEV_STAT_RC_SMART_DATA << 16) |
+					(sc->device->channel << 8) | sc->device->id;
 
-				ioc->events[idx].data[1] = (sense_data[13] << 8) || sense_data[12];
+				ioc->events[idx].data[1] = (sense_data[13] << 8) | sense_data[12];
 
 				ioc->eventContext++;
 				if (hd->ioc->pcidev->vendor ==
diff -puN drivers/message/fusion/mptbase.h~fix--confusion-in-fusion-driver drivers/message/fusion/mptbase.h
--- a/drivers/message/fusion/mptbase.h~fix--confusion-in-fusion-driver
+++ a/drivers/message/fusion/mptbase.h
@@ -436,7 +436,7 @@ typedef struct _MPT_SAS_MGMT {
 typedef struct _mpt_ioctl_events {
 	u32	event;		/* Specified by define above */
 	u32	eventContext;	/* Index or counter */
-	int	data[2];	/* First 8 bytes of Event Data */
+	u32	data[2];	/* First 8 bytes of Event Data */
 } MPT_IOCTL_EVENTS;
 
 /*
_

Patches currently in -mm which might be from dmueller@suse.de are
