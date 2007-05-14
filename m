From: akpm@linux-foundation.org
Subject: + aacraid-fix.patch added to -mm tree
Date: Mon, 14 May 2007 12:54:01 -0700
Message-ID: <200705141954.l4EJs1I8024724@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753278AbXENTyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 15:54:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark_salyzyn@adaptec.com, malitzke@metronets.com


The patch titled
     aacraid fix
has been added to the -mm tree.  Its filename is
     aacraid-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: aacraid fix
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>

Try to address http://bugzilla.kernel.org/show_bug.cgi?id=3D8469

As discussed in the bugzilla, I figure you have an 'sa' based RAID
adapter on the system. Either an HP NetRAID or an Adaptec 5400S. We no
longer have these cards in test or development, so I can not confirm a
fix.

If you have one of these cards in the test machine, please apply the
enclosed patch to see if the problem goes away.

Cc: "Rainer Malitzke-Goes" <malitzke@metronets.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/aacraid.h |    1 +
 drivers/scsi/aacraid/rx.c      |    2 +-
 drivers/scsi/aacraid/sa.c      |    9 ++++++++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/aacraid/aacraid.h~aacraid-fix drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h~aacraid-fix
+++ a/drivers/scsi/aacraid/aacraid.h
@@ -1823,6 +1823,7 @@ int aac_send_shutdown(struct aac_dev *de
 int aac_probe_container(struct aac_dev *dev, int cid);
 int _aac_rx_init(struct aac_dev *dev);
 int aac_rx_select_comm(struct aac_dev *dev, int comm);
+int aac_rx_deliver_producer(struct fib * fib);
 extern int numacb;
 extern int acbsize;
 extern char aac_driver_version[];
diff -puN drivers/scsi/aacraid/rx.c~aacraid-fix drivers/scsi/aacraid/rx.c
--- a/drivers/scsi/aacraid/rx.c~aacraid-fix
+++ a/drivers/scsi/aacraid/rx.c
@@ -378,7 +378,7 @@ static int aac_rx_check_health(struct aa
  *
  *	Will send a fib, returning 0 if successful.
  */
-static int aac_rx_deliver_producer(struct fib * fib)
+int aac_rx_deliver_producer(struct fib * fib)
 {
 	struct aac_dev *dev = fib->dev;
 	struct aac_queue *q = &dev->queues->queue[AdapNormCmdQueue];
diff -puN drivers/scsi/aacraid/sa.c~aacraid-fix drivers/scsi/aacraid/sa.c
--- a/drivers/scsi/aacraid/sa.c~aacraid-fix
+++ a/drivers/scsi/aacraid/sa.c
@@ -5,7 +5,7 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -257,6 +257,11 @@ static void aac_sa_start_adapter(struct 
 			NULL, NULL, NULL, NULL, NULL);
 }
 
+static int aac_sa_restart_adapter(struct aac_dev *dev, int bled)
+{
+	return -EINVAL;
+}
+
 /**
  *	aac_sa_check_health
  *	@dev: device to check if healthy
@@ -366,7 +371,9 @@ int aac_sa_init(struct aac_dev *dev)
 	dev->a_ops.adapter_notify = aac_sa_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = sa_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_sa_check_health;
+	dev->a_ops.adapter_restart = aac_sa_restart_adapter;
 	dev->a_ops.adapter_intr = aac_sa_intr;
+	dev->a_ops.adapter_deliver = aac_rx_deliver_producer;
 	dev->a_ops.adapter_ioremap = aac_sa_ioremap;
 
 	/*
_

Patches currently in -mm which might be from mark_salyzyn@adaptec.com are

aacraid-fix.patch
