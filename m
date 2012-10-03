From: akpm@linux-foundation.org
Subject: + rapidio-add-destination-id-allocation-mechanism.patch added to -mm tree
Date: Wed, 03 Oct 2012 15:37:15 -0700
Message-ID: <20121003223716.544AA100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:41977 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab2JCWhT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2012 18:37:19 -0400
Received: by qcqs25 with SMTP id s25so998761qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 03 Oct 2012 15:37:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, leoli@freescale.com, mporter@kernel.crashing.org


The patch titled
     Subject: rapidio: add destination ID allocation mechanism
has been added to the -mm tree.  Its filename is
     rapidio-add-destination-id-allocation-mechanism.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: add destination ID allocation mechanism

Replace the single global destination ID counter with per-net allocation
mechanism to allow independent destID management for each available
RapidIO network.  Using bitmap based mechanism instead of counters allows
destination ID release and reuse in systems that support hot-swap.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |  205 +++++++++++++++++++++++++++++------
 include/linux/rio.h        |    9 +
 2 files changed, 179 insertions(+), 35 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-add-destination-id-allocation-mechanism drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-add-destination-id-allocation-mechanism
+++ a/drivers/rapidio/rio-scan.c
@@ -54,6 +54,114 @@ static int rio_mport_phys_table[] = {
 	-1,
 };
 
+
+/*
+ * rio_destid_alloc - Allocate next available destID for given network
+ * net: RIO network
+ *
+ * Returns next available device destination ID for the specified RIO network.
+ * Marks allocated ID as one in use.
+ * Returns RIO_INVALID_DESTID if new destID is not available.
+ */
+static u16 rio_destid_alloc(struct rio_net *net)
+{
+	int destid;
+	struct rio_id_table *idtab = &net->destid_table;
+
+	spin_lock(&idtab->lock);
+	destid = find_next_zero_bit(idtab->table, idtab->max, idtab->next);
+	if (destid >= idtab->max)
+		destid = find_first_zero_bit(idtab->table, idtab->max);
+
+	if (destid < idtab->max) {
+		idtab->next = destid + 1;
+		if (idtab->next >= idtab->max)
+			idtab->next = 0;
+		set_bit(destid, idtab->table);
+		destid += idtab->start;
+	} else
+		destid = RIO_INVALID_DESTID;
+
+	spin_unlock(&idtab->lock);
+	return (u16)destid;
+}
+
+/*
+ * rio_destid_reserve - Reserve the specivied destID
+ * net: RIO network
+ * destid: destID to reserve
+ *
+ * Tries to reserve the specified destID.
+ * Returns 0 if successfull.
+ */
+static int rio_destid_reserve(struct rio_net *net, u16 destid)
+{
+	int oldbit;
+	struct rio_id_table *idtab = &net->destid_table;
+
+	destid -= idtab->start;
+	spin_lock(&idtab->lock);
+	oldbit = test_and_set_bit(destid, idtab->table);
+	spin_unlock(&idtab->lock);
+	return oldbit;
+}
+
+/*
+ * rio_destid_free - free a previously allocated destID
+ * net: RIO network
+ * destid: destID to free
+ *
+ * Makes the specified destID available for use.
+ */
+static void rio_destid_free(struct rio_net *net, u16 destid)
+{
+	struct rio_id_table *idtab = &net->destid_table;
+
+	destid -= idtab->start;
+	spin_lock(&idtab->lock);
+	clear_bit(destid, idtab->table);
+	spin_unlock(&idtab->lock);
+}
+
+/*
+ * rio_destid_first - return first destID in use
+ * net: RIO network
+ */
+static u16 rio_destid_first(struct rio_net *net)
+{
+	int destid;
+	struct rio_id_table *idtab = &net->destid_table;
+
+	spin_lock(&idtab->lock);
+	destid = find_first_bit(idtab->table, idtab->max);
+	if (destid >= idtab->max)
+		destid = RIO_INVALID_DESTID;
+	else
+		destid += idtab->start;
+	spin_unlock(&idtab->lock);
+	return (u16)destid;
+}
+
+/*
+ * rio_destid_next - return next destID in use
+ * net: RIO network
+ * from: destination ID from which search shall continue
+ */
+static u16 rio_destid_next(struct rio_net *net, u16 from)
+{
+	int destid;
+	struct rio_id_table *idtab = &net->destid_table;
+
+	spin_lock(&idtab->lock);
+	destid = find_next_bit(idtab->table, idtab->max, from);
+	if (destid >= idtab->max)
+		destid = RIO_INVALID_DESTID;
+	else
+		destid += idtab->start;
+	spin_unlock(&idtab->lock);
+	return (u16)destid;
+}
+
 /**
  * rio_get_device_id - Get the base/extended device id for a device
  * @port: RIO master port
@@ -171,10 +279,6 @@ static int rio_enum_host(struct rio_mpor
 
 	/* Set master port destid and init destid ctr */
 	rio_local_set_device_id(port, port->host_deviceid);
-
-	if (next_destid == port->host_deviceid)
-		next_destid++;
-
 	return 0;
 }
 
@@ -441,9 +545,8 @@ static struct rio_dev __devinit *rio_set
 	if (rio_device_has_destid(port, rdev->src_ops, rdev->dst_ops)) {
 		if (do_enum) {
 			rio_set_device_id(port, destid, hopcount, next_destid);
-			rdev->destid = next_destid++;
-			if (next_destid == port->host_deviceid)
-				next_destid++;
+			rdev->destid = next_destid;
+			next_destid = rio_destid_alloc(net);
 		} else
 			rdev->destid = rio_get_device_id(port, destid, hopcount);
 
@@ -742,12 +845,7 @@ static u16 rio_get_host_deviceid_lock(st
 static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 			 u8 hopcount, struct rio_dev *prev, int prev_port)
 {
-	int port_num;
-	int cur_destid;
-	int sw_destid;
-	int sw_inport;
 	struct rio_dev *rdev;
-	u16 destid;
 	u32 regval;
 	int tmp;
 
@@ -813,19 +911,26 @@ static int __devinit rio_enum_peer(struc
 		return -1;
 
 	if (rio_is_switch(rdev)) {
+		int sw_destid;
+		int cur_destid;
+		int sw_inport;
+		u16 destid;
+		int port_num;
+
 		sw_inport = RIO_GET_PORT_NUM(rdev->swpinfo);
 		rio_route_add_entry(rdev, RIO_GLOBAL_TABLE,
 				    port->host_deviceid, sw_inport, 0);
 		rdev->rswitch->route_table[port->host_deviceid] = sw_inport;
 
-		for (destid = 0; destid < next_destid; destid++) {
-			if (destid == port->host_deviceid)
-				continue;
-			rio_route_add_entry(rdev, RIO_GLOBAL_TABLE,
-					    destid, sw_inport, 0);
-			rdev->rswitch->route_table[destid] = sw_inport;
+		destid = rio_destid_first(net);
+		while (destid != RIO_INVALID_DESTID && destid < next_destid) {
+			if (destid != port->host_deviceid) {
+				rio_route_add_entry(rdev, RIO_GLOBAL_TABLE,
+						    destid, sw_inport, 0);
+				rdev->rswitch->route_table[destid] = sw_inport;
+			}
+			destid = rio_destid_next(net, destid + 1);
 		}
-
 		pr_debug(
 		    "RIO: found %s (vid %4.4x did %4.4x) with %d ports\n",
 		    rio_name(rdev), rdev->vid, rdev->did,
@@ -863,19 +968,22 @@ static int __devinit rio_enum_peer(struc
 					return -1;
 
 				/* Update routing tables */
-				if (next_destid > cur_destid) {
+				destid = rio_destid_next(net, cur_destid + 1);
+				if (destid != RIO_INVALID_DESTID) {
 					for (destid = cur_destid;
-					     destid < next_destid; destid++) {
-						if (destid == port->host_deviceid)
-							continue;
-						rio_route_add_entry(rdev,
+					     destid < next_destid;) {
+						if (destid != port->host_deviceid) {
+							rio_route_add_entry(rdev,
 								    RIO_GLOBAL_TABLE,
 								    destid,
 								    port_num,
 								    0);
-						rdev->rswitch->
-						    route_table[destid] =
-						    port_num;
+							rdev->rswitch->
+								route_table[destid] =
+								port_num;
+						}
+						destid = rio_destid_next(net,
+								destid + 1);
 					}
 				}
 			} else {
@@ -901,11 +1009,8 @@ static int __devinit rio_enum_peer(struc
 		rio_init_em(rdev);
 
 		/* Check for empty switch */
-		if (next_destid == sw_destid) {
-			next_destid++;
-			if (next_destid == port->host_deviceid)
-				next_destid++;
-		}
+		if (next_destid == sw_destid)
+			next_destid = rio_destid_alloc(net);
 
 		rdev->destid = sw_destid;
 	} else
@@ -1043,17 +1148,39 @@ static int rio_mport_is_active(struct ri
 /**
  * rio_alloc_net- Allocate and configure a new RIO network
  * @port: Master port associated with the RIO network
+ * @do_enum: Enumeration/Discovery mode flag
+ * @start: logical minimal start id for new net
  *
  * Allocates a RIO network structure, initializes per-network
  * list heads, and adds the associated master port to the
  * network list of associated master ports. Returns a
  * RIO network pointer on success or %NULL on failure.
  */
-static struct rio_net __devinit *rio_alloc_net(struct rio_mport *port)
+static struct rio_net __devinit *rio_alloc_net(struct rio_mport *port,
+					       int do_enum, u16 start)
 {
 	struct rio_net *net;
 
 	net = kzalloc(sizeof(struct rio_net), GFP_KERNEL);
+	if (net && do_enum) {
+		net->destid_table.table = kzalloc(
+			BITS_TO_LONGS(RIO_MAX_ROUTE_ENTRIES(port->sys_size)) *
+			sizeof(long),
+			GFP_KERNEL);
+
+		if (net->destid_table.table == NULL) {
+			pr_err("RIO: failed to allocate destID table\n");
+			kfree(net);
+			net = NULL;
+		} else {
+			net->destid_table.start = start;
+			net->destid_table.next = 0;
+			net->destid_table.max =
+					RIO_MAX_ROUTE_ENTRIES(port->sys_size);
+			spin_lock_init(&net->destid_table.lock);
+		}
+	}
+
 	if (net) {
 		INIT_LIST_HEAD(&net->node);
 		INIT_LIST_HEAD(&net->devices);
@@ -1163,12 +1290,16 @@ int __devinit rio_enum_mport(struct rio_
 
 	/* If master port has an active link, allocate net and enum peers */
 	if (rio_mport_is_active(mport)) {
-		if (!(net = rio_alloc_net(mport))) {
+		net = rio_alloc_net(mport, 1, 0);
+		if (!net) {
 			printk(KERN_ERR "RIO: failed to allocate new net\n");
 			rc = -ENOMEM;
 			goto out;
 		}
 
+		/* reserve mport destID in new net */
+		rio_destid_reserve(net, mport->host_deviceid);
+
 		/* Enable Input Output Port (transmitter reviever) */
 		rio_enable_rx_tx_port(mport, 1, 0, 0, 0);
 
@@ -1176,6 +1307,8 @@ int __devinit rio_enum_mport(struct rio_
 		rio_local_write_config_32(mport, RIO_COMPONENT_TAG_CSR,
 					  next_comptag++);
 
+		next_destid = rio_destid_alloc(net);
+
 		if (rio_enum_peer(net, mport, 0, NULL, 0) < 0) {
 			/* A higher priority host won enumeration, bail. */
 			printk(KERN_INFO
@@ -1185,6 +1318,8 @@ int __devinit rio_enum_mport(struct rio_
 			rc = -EBUSY;
 			goto out;
 		}
+		/* free the last allocated destID (unused) */
+		rio_destid_free(net, next_destid);
 		rio_update_route_tables(net);
 		rio_clear_locks(net);
 		rio_pw_enable(mport, 1);
@@ -1265,7 +1400,7 @@ int __devinit rio_disc_mport(struct rio_
 enum_done:
 		pr_debug("RIO: ... enumeration done\n");
 
-		net = rio_alloc_net(mport);
+		net = rio_alloc_net(mport, 0, 0);
 		if (!net) {
 			printk(KERN_ERR "RIO: Failed to allocate new net\n");
 			goto bail;
diff -puN include/linux/rio.h~rapidio-add-destination-id-allocation-mechanism include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-destination-id-allocation-mechanism
+++ a/include/linux/rio.h
@@ -264,6 +264,14 @@ struct rio_mport {
 #endif
 };
 
+struct rio_id_table {
+	u16 start;	/* logical minimal id */
+	u16 next;	/* hint for find */
+	u32 max;	/* max number of IDs in table */
+	spinlock_t lock;
+	unsigned long *table;
+};
+
 /**
  * struct rio_net - RIO network info
  * @node: Node in global list of RIO networks
@@ -279,6 +287,7 @@ struct rio_net {
 	struct list_head mports;	/* list of ports accessing net */
 	struct rio_mport *hport;	/* primary port for accessing net */
 	unsigned char id;	/* RIO network ID */
+	struct rio_id_table destid_table;  /* destID allocation table */
 };
 
 /* Definitions used by switch sysfs initialization callback */
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch
rapidio-rionet-fix-multicast-packet-transmit-logic.patch
rapidio-tsi721-modify-mport-name-assignment.patch
rapidio-fix-kerneldoc-warnings-after-dma-support-was-added.patch
drivers-rapidio-devices-tsi721c-fix-error-return-code.patch
rapidio-add-inbound-memory-mapping-interface.patch
rapidio-tsi721-add-inbound-memory-mapping-callbacks.patch
rapidio-apply-rx-tx-enable-to-active-switch-ports-only.patch
rapidio-fix-blocking-wait-for-discovery-ready.patch
rapidio-use-device-lists-handling-on-per-net-basis.patch
rapidio-run-discovery-as-an-asynchronous-process.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch
rapidio-rionet-rework-to-support-multiple-rio-master-ports.patch
rapidio-add-destination-id-allocation-mechanism.patch

