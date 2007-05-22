From: akpm@linux-foundation.org
Subject: - fix-confusion-in-fusion-driver-update.patch removed from -mm tree
Date: Tue, 22 May 2007 12:55:14 -0700
Message-ID: <200705221955.l4MJtEpu008638@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45805 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756775AbXEVUFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 16:05:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, James.Bottomley@SteelEye.com, eric.moore@lsi.com, mm-commits@vger.kernel.org


The patch titled
     Fix |/|| confusion in fusion driver (update)
has been removed from the -mm tree.  Its filename was
     fix-confusion-in-fusion-driver-update.patch

This patch was dropped because it was folded into fix--confusion-in-fusion-driver.patch

------------------------------------------------------
Subject: Fix |/|| confusion in fusion driver (update)
From: Dave Jones <davej@redhat.com>

The last time this was posted, Eric picked up on some other flaws in the
same area.  James asked him to followup with a patch, but unless I'm
mistaken, that never arrived.  This diff should replace the one in your
tree until Eric has an equivalent or better.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Eric Moore <eric.moore@lsi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.h  |    2 +-
 drivers/message/fusion/mptscsih.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/message/fusion/mptbase.h~fix-confusion-in-fusion-driver-update drivers/message/fusion/mptbase.h
--- a/drivers/message/fusion/mptbase.h~fix-confusion-in-fusion-driver-update
+++ a/drivers/message/fusion/mptbase.h
@@ -436,7 +436,7 @@ typedef struct _MPT_SAS_MGMT {
 typedef struct _mpt_ioctl_events {
 	u32	event;		/* Specified by define above */
 	u32	eventContext;	/* Index or counter */
-	int	data[2];	/* First 8 bytes of Event Data */
+	u32	data[2];	/* First 8 bytes of Event Data */
 } MPT_IOCTL_EVENTS;
 
 /*
diff -puN drivers/message/fusion/mptscsih.c~fix-confusion-in-fusion-driver-update drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~fix-confusion-in-fusion-driver-update
+++ a/drivers/message/fusion/mptscsih.c
@@ -2467,7 +2467,7 @@ mptscsih_copy_sense_data(struct scsi_cmn
 					(MPI_EVENT_SCSI_DEV_STAT_RC_SMART_DATA << 16) |
 					(sc->device->channel << 8) | sc->device->id;
 
-				ioc->events[idx].data[1] = (sense_data[13] << 8) || sense_data[12];
+				ioc->events[idx].data[1] = (sense_data[13] << 8) | sense_data[12];
 
 				ioc->eventContext++;
 				if (hd->ioc->pcidev->vendor ==
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
git-cpufreq.patch
ide-add-seagate-stt20000a-to-dma-blacklist.patch
fix--confusion-in-fusion-driver.patch
fix-confusion-in-fusion-driver-update.patch
fix-up-codingstyle-in-isofs.patch
