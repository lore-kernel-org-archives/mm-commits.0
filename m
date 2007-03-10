From: akpm@linux-foundation.org
Subject: + rm-pointless-dmaengine-exports.patch added to -mm tree
Date: Fri, 09 Mar 2007 18:41:30 -0800
Message-ID: <200703100241.l2A2fUvL009524@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57655 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993165AbXCJCli (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Mar 2007 21:41:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, christopher.leech@intel.com, dan.j.williams@intel.com, dbrownell@users.sourceforge.net


The patch titled
     rm pointless dmaengine exports
has been added to the -mm tree.  Its filename is
     rm-pointless-dmaengine-exports.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rm pointless dmaengine exports
From: David Brownell <david-b@pacbell.net>

This removes several pointless exports from drivers/dma/dmaengine.c; the
dma_async_memcpy_*() functions are inlined by <linux/dmaengine.h> so those
exports are inappropriate.

It also moves the existing EXPORT_SYMBOL declarations next to their functions,
so it's now trivial to confirm one-to-one correspondence between exports and
nonstatic symbols.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmaengine.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN drivers/dma/dmaengine.c~rm-pointless-dmaengine-exports drivers/dma/dmaengine.c
--- a/drivers/dma/dmaengine.c~rm-pointless-dmaengine-exports
+++ a/drivers/dma/dmaengine.c
@@ -176,6 +176,7 @@ void dma_chan_cleanup(struct kref *kref)
 	chan->client = NULL;
 	kref_put(&chan->device->refcount, dma_async_device_cleanup);
 }
+EXPORT_SYMBOL(dma_chan_cleanup);
 
 static void dma_chan_free_rcu(struct rcu_head *rcu)
 {
@@ -261,6 +262,7 @@ struct dma_client *dma_async_client_regi
 
 	return client;
 }
+EXPORT_SYMBOL(dma_async_client_register);
 
 /**
  * dma_async_client_unregister - unregister a client and free the &dma_client
@@ -287,6 +289,7 @@ void dma_async_client_unregister(struct 
 	kfree(client);
 	dma_chans_rebalance();
 }
+EXPORT_SYMBOL(dma_async_client_unregister);
 
 /**
  * dma_async_client_chan_request - request DMA channels
@@ -304,6 +307,7 @@ void dma_async_client_chan_request(struc
 	client->chans_desired = number;
 	dma_chans_rebalance();
 }
+EXPORT_SYMBOL(dma_async_client_chan_request);
 
 /**
  * dma_async_device_register - registers DMA devices found
@@ -346,6 +350,7 @@ int dma_async_device_register(struct dma
 
 	return 0;
 }
+EXPORT_SYMBOL(dma_async_device_register);
 
 /**
  * dma_async_device_cleanup - function called when all references are released
@@ -390,23 +395,12 @@ void dma_async_device_unregister(struct 
 	kref_put(&device->refcount, dma_async_device_cleanup);
 	wait_for_completion(&device->done);
 }
+EXPORT_SYMBOL(dma_async_device_unregister);
 
 static int __init dma_bus_init(void)
 {
 	mutex_init(&dma_list_mutex);
 	return class_register(&dma_devclass);
 }
-
 subsys_initcall(dma_bus_init);
 
-EXPORT_SYMBOL(dma_async_client_register);
-EXPORT_SYMBOL(dma_async_client_unregister);
-EXPORT_SYMBOL(dma_async_client_chan_request);
-EXPORT_SYMBOL(dma_async_memcpy_buf_to_buf);
-EXPORT_SYMBOL(dma_async_memcpy_buf_to_pg);
-EXPORT_SYMBOL(dma_async_memcpy_pg_to_pg);
-EXPORT_SYMBOL(dma_async_memcpy_complete);
-EXPORT_SYMBOL(dma_async_memcpy_issue_pending);
-EXPORT_SYMBOL(dma_async_device_register);
-EXPORT_SYMBOL(dma_async_device_unregister);
-EXPORT_SYMBOL(dma_chan_cleanup);
_

Patches currently in -mm which might be from david-b@pacbell.net are

reduce-pnp-syslog-spam.patch
rm-pointless-dmaengine-exports.patch
git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-i2c-driver-update-2.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
