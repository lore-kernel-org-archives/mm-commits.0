From: akpm@linux-foundation.org
Subject: [merged] rapidio-update-for-destination-id-allocation.patch removed from -mm tree
Date: Thu, 11 Oct 2012 13:59:09 -0700
Message-ID: <20121011205909.A8D70100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:55579 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2JKU7K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 16:59:10 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so270580ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 13:59:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, leoli@freescale.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: update for destination ID allocation
has been removed from the -mm tree.  Its filename was
     rapidio-update-for-destination-id-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: update for destination ID allocation

Address comments provided by Andrew Morton:
https://lkml.org/lkml/2012/10/3/550

- Keeps consistent kerneldoc compatible comments style for new static functions.
- Removes unnecessary complexity from destination ID allocation routine.
- Uses kcalloc() for code clarity.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |   38 ++++++++++++++---------------------
 include/linux/rio.h        |    1 
 2 files changed, 16 insertions(+), 23 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-update-for-destination-id-allocation drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-update-for-destination-id-allocation
+++ a/drivers/rapidio/rio-scan.c
@@ -55,9 +55,9 @@ static int rio_mport_phys_table[] = {
 };
 
 
-/*
+/**
  * rio_destid_alloc - Allocate next available destID for given network
- * net: RIO network
+ * @net: RIO network
  *
  * Returns next available device destination ID for the specified RIO network.
  * Marks allocated ID as one in use.
@@ -69,14 +69,9 @@ static u16 rio_destid_alloc(struct rio_n
 	struct rio_id_table *idtab = &net->destid_table;
 
 	spin_lock(&idtab->lock);
-	destid = find_next_zero_bit(idtab->table, idtab->max, idtab->next);
-	if (destid >= idtab->max)
-		destid = find_first_zero_bit(idtab->table, idtab->max);
+	destid = find_first_zero_bit(idtab->table, idtab->max);
 
 	if (destid < idtab->max) {
-		idtab->next = destid + 1;
-		if (idtab->next >= idtab->max)
-			idtab->next = 0;
 		set_bit(destid, idtab->table);
 		destid += idtab->start;
 	} else
@@ -86,10 +81,10 @@ static u16 rio_destid_alloc(struct rio_n
 	return (u16)destid;
 }
 
-/*
+/**
  * rio_destid_reserve - Reserve the specivied destID
- * net: RIO network
- * destid: destID to reserve
+ * @net: RIO network
+ * @destid: destID to reserve
  *
  * Tries to reserve the specified destID.
  * Returns 0 if successfull.
@@ -106,10 +101,10 @@ static int rio_destid_reserve(struct rio
 	return oldbit;
 }
 
-/*
+/**
  * rio_destid_free - free a previously allocated destID
- * net: RIO network
- * destid: destID to free
+ * @net: RIO network
+ * @destid: destID to free
  *
  * Makes the specified destID available for use.
  */
@@ -123,9 +118,9 @@ static void rio_destid_free(struct rio_n
 	spin_unlock(&idtab->lock);
 }
 
-/*
+/**
  * rio_destid_first - return first destID in use
- * net: RIO network
+ * @net: RIO network
  */
 static u16 rio_destid_first(struct rio_net *net)
 {
@@ -142,10 +137,10 @@ static u16 rio_destid_first(struct rio_n
 	return (u16)destid;
 }
 
-/*
+/**
  * rio_destid_next - return next destID in use
- * net: RIO network
- * from: destination ID from which search shall continue
+ * @net: RIO network
+ * @from: destination ID from which search shall continue
  */
 static u16 rio_destid_next(struct rio_net *net, u16 from)
 {
@@ -1163,8 +1158,8 @@ static struct rio_net __devinit *rio_all
 
 	net = kzalloc(sizeof(struct rio_net), GFP_KERNEL);
 	if (net && do_enum) {
-		net->destid_table.table = kzalloc(
-			BITS_TO_LONGS(RIO_MAX_ROUTE_ENTRIES(port->sys_size)) *
+		net->destid_table.table = kcalloc(
+			BITS_TO_LONGS(RIO_MAX_ROUTE_ENTRIES(port->sys_size)),
 			sizeof(long),
 			GFP_KERNEL);
 
@@ -1174,7 +1169,6 @@ static struct rio_net __devinit *rio_all
 			net = NULL;
 		} else {
 			net->destid_table.start = start;
-			net->destid_table.next = 0;
 			net->destid_table.max =
 					RIO_MAX_ROUTE_ENTRIES(port->sys_size);
 			spin_lock_init(&net->destid_table.lock);
diff -puN include/linux/rio.h~rapidio-update-for-destination-id-allocation include/linux/rio.h
--- a/include/linux/rio.h~rapidio-update-for-destination-id-allocation
+++ a/include/linux/rio.h
@@ -266,7 +266,6 @@ struct rio_mport {
 
 struct rio_id_table {
 	u16 start;	/* logical minimal id */
-	u16 next;	/* hint for find */
 	u32 max;	/* max number of IDs in table */
 	spinlock_t lock;
 	unsigned long *table;
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

