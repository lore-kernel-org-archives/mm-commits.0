Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBE62EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011365; cv=none; b=FZB5cHRH7ugcyRcFFn99GHS/lY8ytYf4sBlZls3bbqEzp5/D0HQGbs+tnbqChB+1FhsES9pGJRb4BBnz6OJMKqL1ucErAhKenlGMr9Rk2uGtl0Z5TS7jFbmJIKl/gvbbmLUhC46FQxDr8MiTQwnVg5uzP5MHGGjUjdIFN5IH24U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011365; c=relaxed/simple;
	bh=uSDA3dXwP53SKTCoMmkUiYrH0xL5IeR0S7N2lH1p/cw=;
	h=Date:To:From:Subject:Message-Id; b=ncpsmUZrNcyZPDpdNMXbL0vY/AVAIWHgUke3C8QnjvFWGfrZ0BgNFesUHRwZUmeTv9OU5w5nrLE5AClt0KjxPE0Peifm83QfTPvtbAkMqjtGSd3C/tsF9juQFZqM/fhyNGfVjAZOrda1kGnPuTeKNlHeBOU1w034mtDkMdZVlhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oAY8r31C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oAY8r31C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24022C4CEE4;
	Mon, 12 May 2025 00:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011365;
	bh=uSDA3dXwP53SKTCoMmkUiYrH0xL5IeR0S7N2lH1p/cw=;
	h=Date:To:From:Subject:From;
	b=oAY8r31C9RCvBx9n5iPfgXCT1R3lw3/NYtoA9KURwejHzi1OACOBz9BwGu3wuEYcf
	 PvWiBQ1WqxV8a/21AnOcjkwlTHuOlurhTO85BSSuX5e9XZYRLQ6/aO64dUnk73iDRB
	 CH+8cIdMREj32eUwGNMdfimMJTLchYEq9xAM92xQ=
Date: Sun, 11 May 2025 17:56:04 -0700
To: mm-commits@vger.kernel.org,mporter@kernel.crashing.org,alex.bou9@gmail.com,linux@treblig.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rapidio-remove-unused-functions.patch removed from -mm tree
Message-Id: <20250512005605.24022C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rapidio: remove unused functions
has been removed from the -mm tree.  Its filename was
     rapidio-remove-unused-functions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: rapidio: remove unused functions
Date: Sat, 19 Apr 2025 21:30:12 +0100

rio_request_dma() and rio_dma_prep_slave_sg() were added in 2012 by commit
e42d98ebe7d7 ("rapidio: add DMA engine support for RIO data transfers")
but never used.

rio_find_mport() last use was removed in 2013 by commit 9edbc30b434f
("rapidio: update enumerator registration mechanism")

rio_unregister_scan() was added in 2013 by commit a11650e11093 ("rapidio:
make enumeration/discovery configurable") but never used.

Remove them.

Link: https://lkml.kernel.org/r/20250419203012.429787-3-linux@treblig.org
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c   |  103 --------------------------------------
 drivers/rapidio/rio.h   |    2 
 include/linux/rio_drv.h |    5 -
 3 files changed, 110 deletions(-)

--- a/drivers/rapidio/rio.c~rapidio-remove-unused-functions
+++ a/drivers/rapidio/rio.c
@@ -1775,19 +1775,6 @@ struct dma_chan *rio_request_mport_dma(s
 EXPORT_SYMBOL_GPL(rio_request_mport_dma);
 
 /**
- * rio_request_dma - request RapidIO capable DMA channel that supports
- *   specified target RapidIO device.
- * @rdev: RIO device associated with DMA transfer
- *
- * Returns pointer to allocated DMA channel or NULL if failed.
- */
-struct dma_chan *rio_request_dma(struct rio_dev *rdev)
-{
-	return rio_request_mport_dma(rdev->net->hport);
-}
-EXPORT_SYMBOL_GPL(rio_request_dma);
-
-/**
  * rio_release_dma - release specified DMA channel
  * @dchan: DMA channel to release
  */
@@ -1834,57 +1821,9 @@ struct dma_async_tx_descriptor *rio_dma_
 }
 EXPORT_SYMBOL_GPL(rio_dma_prep_xfer);
 
-/**
- * rio_dma_prep_slave_sg - RapidIO specific wrapper
- *   for device_prep_slave_sg callback defined by DMAENGINE.
- * @rdev: RIO device control structure
- * @dchan: DMA channel to configure
- * @data: RIO specific data descriptor
- * @direction: DMA data transfer direction (TO or FROM the device)
- * @flags: dmaengine defined flags
- *
- * Initializes RapidIO capable DMA channel for the specified data transfer.
- * Uses DMA channel private extension to pass information related to remote
- * target RIO device.
- *
- * Returns: pointer to DMA transaction descriptor if successful,
- *          error-valued pointer or NULL if failed.
- */
-struct dma_async_tx_descriptor *rio_dma_prep_slave_sg(struct rio_dev *rdev,
-	struct dma_chan *dchan, struct rio_dma_data *data,
-	enum dma_transfer_direction direction, unsigned long flags)
-{
-	return rio_dma_prep_xfer(dchan,	rdev->destid, data, direction, flags);
-}
-EXPORT_SYMBOL_GPL(rio_dma_prep_slave_sg);
-
 #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
 
 /**
- * rio_find_mport - find RIO mport by its ID
- * @mport_id: number (ID) of mport device
- *
- * Given a RIO mport number, the desired mport is located
- * in the global list of mports. If the mport is found, a pointer to its
- * data structure is returned.  If no mport is found, %NULL is returned.
- */
-struct rio_mport *rio_find_mport(int mport_id)
-{
-	struct rio_mport *port;
-
-	mutex_lock(&rio_mport_list_lock);
-	list_for_each_entry(port, &rio_mports, node) {
-		if (port->id == mport_id)
-			goto found;
-	}
-	port = NULL;
-found:
-	mutex_unlock(&rio_mport_list_lock);
-
-	return port;
-}
-
-/**
  * rio_register_scan - enumeration/discovery method registration interface
  * @mport_id: mport device ID for which fabric scan routine has to be set
  *            (RIO_MPORT_ANY = set for all available mports)
@@ -1962,48 +1901,6 @@ err_out:
 EXPORT_SYMBOL_GPL(rio_register_scan);
 
 /**
- * rio_unregister_scan - removes enumeration/discovery method from mport
- * @mport_id: mport device ID for which fabric scan routine has to be
- *            unregistered (RIO_MPORT_ANY = apply to all mports that use
- *            the specified scan_ops)
- * @scan_ops: enumeration/discovery operations structure
- *
- * Removes enumeration or discovery method assigned to the specified mport
- * device. If RIO_MPORT_ANY is specified, removes the specified operations from
- * all mports that have them attached.
- */
-int rio_unregister_scan(int mport_id, struct rio_scan *scan_ops)
-{
-	struct rio_mport *port;
-	struct rio_scan_node *scan;
-
-	pr_debug("RIO: %s for mport_id=%d\n", __func__, mport_id);
-
-	if (mport_id != RIO_MPORT_ANY && mport_id >= RIO_MAX_MPORTS)
-		return -EINVAL;
-
-	mutex_lock(&rio_mport_list_lock);
-
-	list_for_each_entry(port, &rio_mports, node)
-		if (port->id == mport_id ||
-		    (mport_id == RIO_MPORT_ANY && port->nscan == scan_ops))
-			port->nscan = NULL;
-
-	list_for_each_entry(scan, &rio_scans, node) {
-		if (scan->mport_id == mport_id) {
-			list_del(&scan->node);
-			kfree(scan);
-			break;
-		}
-	}
-
-	mutex_unlock(&rio_mport_list_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rio_unregister_scan);
-
-/**
  * rio_mport_scan - execute enumeration/discovery on the specified mport
  * @mport_id: number (ID) of mport device
  */
--- a/drivers/rapidio/rio.h~rapidio-remove-unused-functions
+++ a/drivers/rapidio/rio.h
@@ -41,9 +41,7 @@ extern void rio_del_device(struct rio_de
 extern int rio_enable_rx_tx_port(struct rio_mport *port, int local, u16 destid,
 				 u8 hopcount, u8 port_num);
 extern int rio_register_scan(int mport_id, struct rio_scan *scan_ops);
-extern int rio_unregister_scan(int mport_id, struct rio_scan *scan_ops);
 extern void rio_attach_device(struct rio_dev *rdev);
-extern struct rio_mport *rio_find_mport(int mport_id);
 extern int rio_mport_scan(int mport_id);
 
 /* Structures internal to the RIO core code */
--- a/include/linux/rio_drv.h~rapidio-remove-unused-functions
+++ a/include/linux/rio_drv.h
@@ -391,13 +391,8 @@ struct rio_dev *rio_dev_get(struct rio_d
 void rio_dev_put(struct rio_dev *);
 
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
-extern struct dma_chan *rio_request_dma(struct rio_dev *rdev);
 extern struct dma_chan *rio_request_mport_dma(struct rio_mport *mport);
 extern void rio_release_dma(struct dma_chan *dchan);
-extern struct dma_async_tx_descriptor *rio_dma_prep_slave_sg(
-		struct rio_dev *rdev, struct dma_chan *dchan,
-		struct rio_dma_data *data,
-		enum dma_transfer_direction direction, unsigned long flags);
 extern struct dma_async_tx_descriptor *rio_dma_prep_xfer(
 		struct dma_chan *dchan,	u16 destid,
 		struct rio_dma_data *data,
_

Patches currently in -mm which might be from linux@treblig.org are


