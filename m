From: akpm@linux-foundation.org
Subject: - fix-for-bugzilla-8426-massive-slowdown-on-scsi-cd-dvd-drive-connected-to-mptspi-driver.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:34:53 -0700
Message-ID: <200706081734.l58HYrqf006325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60471 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932158AbXFHRfh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:35:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: doug.chapman@hp.com, Eric.Moore@lsil.com, James.Bottomley@steeleye.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fix for bugzilla 8426: massive slowdown on SCSI CD/DVD drive connected to mptspi driver
has been removed from the -mm tree.  Its filename was
     fix-for-bugzilla-8426-massive-slowdown-on-scsi-cd-dvd-drive-connected-to-mptspi-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix for bugzilla 8426: massive slowdown on SCSI CD/DVD drive connected to mptspi driver
From: Doug Chapman <doug.chapman@hp.com>

Patch for: http://bugzilla.kernel.org/show_bug.cgi?id=8426

A recent code cleanup that moved code from mptscsih to mptspi inadvertently
change the order some code was called.  This caused a massive slowdown (of
150x to 300x) on the CD/DVD drive on the high-end HP Integrity servers.

Signed-off-by: Doug Chapman <doug.chapman@hp.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptspi.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/message/fusion/mptspi.c~fix-for-bugzilla-8426-massive-slowdown-on-scsi-cd-dvd-drive-connected-to-mptspi-driver drivers/message/fusion/mptspi.c
--- a/drivers/message/fusion/mptspi.c~fix-for-bugzilla-8426-massive-slowdown-on-scsi-cd-dvd-drive-connected-to-mptspi-driver
+++ a/drivers/message/fusion/mptspi.c
@@ -727,13 +727,15 @@ static int mptspi_slave_configure(struct
 	struct _MPT_SCSI_HOST *hd =
 		(struct _MPT_SCSI_HOST *)sdev->host->hostdata;
 	VirtTarget *vtarget = scsi_target(sdev)->hostdata;
-	int ret = mptscsih_slave_configure(sdev);
+	int ret;
+
+	mptspi_initTarget(hd, vtarget, sdev);
+
+	ret = mptscsih_slave_configure(sdev);
 
 	if (ret)
 		return ret;
 
-	mptspi_initTarget(hd, vtarget, sdev);
-
 	ddvprintk((MYIOC_s_INFO_FMT "id=%d min_period=0x%02x"
 		" max_offset=0x%02x max_width=%d\n", hd->ioc->name,
 		sdev->id, spi_min_period(scsi_target(sdev)),
_

Patches currently in -mm which might be from doug.chapman@hp.com are

git-scsi-rc-fixes.patch
