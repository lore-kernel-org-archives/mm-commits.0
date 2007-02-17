From: akpm@linux-foundation.org
Subject: + dmaengine-uninline-large-functions.patch added to -mm tree
Date: Sat, 17 Feb 2007 02:15:46 -0800
Message-ID: <200702171017.l1HAH4OS024563@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54382 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946622AbXBQKRK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 05:17:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, christopher.leech@intel.com, dan.j.williams@intel.com


The patch titled
     dmaengine: uninline large functions
has been added to the -mm tree.  Its filename is
     dmaengine-uninline-large-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dmaengine: uninline large functions
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 allnoconfig:

In file included from include/linux/skbuff.h:29,
                 from include/linux/netlink.h:139,
                 from include/linux/genetlink.h:4,
                 from include/net/genetlink.h:4,
                 from include/linux/taskstats_kern.h:12,
                 from init/main.c:44:
include/linux/dmaengine.h: In function 'dma_async_memcpy_buf_to_pg':
include/linux/dmaengine.h:372: warning: implicit declaration of function 'page_address'
include/linux/dmaengine.h:372: warning: passing argument 2 of 'dma_map_single' makes pointer from integer without a cast
include/linux/dmaengine.h: In function 'dma_async_memcpy_pg_to_pg':
include/linux/dmaengine.h:413: warning: passing argument 2 of 'dma_map_single' makes pointer from integer without a cast
include/linux/dmaengine.h:415: warning: passing argument 2 of 'dma_map_single' makes pointer from integer without a cast

Including mm.h in dmaengine.h would be painful, plus those functions are way
too large to be inlined anyway.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmaengine.c   |  138 +++++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h |  141 ++----------------------------------
 2 files changed, 146 insertions(+), 133 deletions(-)

diff -puN include/linux/dmaengine.h~dmaengine-uninline-large-functions include/linux/dmaengine.h
--- a/include/linux/dmaengine.h~dmaengine-uninline-large-functions
+++ a/include/linux/dmaengine.h
@@ -299,140 +299,15 @@ struct dma_device {
 struct dma_client *dma_async_client_register(dma_event_callback event_callback);
 void dma_async_client_unregister(struct dma_client *client);
 void dma_async_client_chan_request(struct dma_client *client, int number);
-
-/**
- * dma_async_memcpy_buf_to_buf - offloaded copy between virtual addresses
- * @chan: DMA channel to offload copy to
- * @dest: destination address (virtual)
- * @src: source address (virtual)
- * @len: length
- *
- * Both @dest and @src must be mappable to a bus address according to the
- * DMA mapping API rules for streaming mappings.
- * Both @dest and @src must stay memory resident (kernel memory or locked
- * user space pages).
- */
-static inline dma_cookie_t dma_async_memcpy_buf_to_buf(struct dma_chan *chan,
-        void *dest, void *src, size_t len)
-{
-	struct dma_device *dev = chan->device;
-	struct dma_async_tx_descriptor *tx;
-	dma_addr_t addr;
-	dma_cookie_t cookie;
-	int cpu;
-
-	tx = dev->device_prep_dma_memcpy(chan, len, 0);
-	if (!tx)
-		return -ENOMEM;
-
-	tx->ack = 1;
-	addr = dma_map_single(dev->dev, src, len, DMA_TO_DEVICE);
-	dev->device_set_src(addr, tx, 0);
-	addr = dma_map_single(dev->dev, dest, len, DMA_FROM_DEVICE);
-	dev->device_set_dest(addr, tx, 0);
-	cookie = dev->device_tx_submit(tx);
-
-	cpu = get_cpu();
-	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
-	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
-	put_cpu();
-
-	return cookie;
-}
-
-/**
- * dma_async_memcpy_buf_to_pg - offloaded copy from address to page
- * @chan: DMA channel to offload copy to
- * @page: destination page
- * @offset: offset in page to copy to
- * @kdata: source address (virtual)
- * @len: length
- *
- * Both @page/@offset and @kdata must be mappable to a bus address according
- * to the DMA mapping API rules for streaming mappings.
- * Both @page/@offset and @kdata must stay memory resident (kernel memory or
- * locked user space pages)
- */
-static inline dma_cookie_t dma_async_memcpy_buf_to_pg(struct dma_chan *chan,
-        struct page *page, unsigned int offset, void *kdata, size_t len)
-{
-	struct dma_device *dev = chan->device;
-	struct dma_async_tx_descriptor *tx;
-	dma_addr_t addr;
-	dma_cookie_t cookie;
-	int cpu;
-
-	tx = dev->device_prep_dma_memcpy(chan, len, 0);
-	if (!tx)
-		return -ENOMEM;
-
-	tx->ack = 1;
-	addr = dma_map_single(dev->dev, kdata, len, DMA_TO_DEVICE);
-	dev->device_set_src(addr, tx, 0);
-	addr = dma_map_page(dev->dev, page, offset, len, DMA_FROM_DEVICE);
-	dev->device_set_dest(addr, tx, 0);
-	cookie = dev->device_tx_submit(tx);
-
-	cpu = get_cpu();
-	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
-	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
-	put_cpu();
-
-	return cookie;
-}
-
-/**
- * dma_async_memcpy_pg_to_pg - offloaded copy from page to page
- * @chan: DMA channel to offload copy to
- * @dest_pg: destination page
- * @dest_off: offset in page to copy to
- * @src_pg: source page
- * @src_off: offset in page to copy from
- * @len: length
- *
- * Both @dest_page/@dest_off and @src_page/@src_off must be mappable to a bus
- * address according to the DMA mapping API rules for streaming mappings.
- * Both @dest_page/@dest_off and @src_page/@src_off must stay memory resident
- * (kernel memory or locked user space pages).
- */
-static inline dma_cookie_t dma_async_memcpy_pg_to_pg(struct dma_chan *chan,
+dma_cookie_t dma_async_memcpy_buf_to_buf(struct dma_chan *chan,
+        void *dest, void *src, size_t len);
+dma_cookie_t dma_async_memcpy_buf_to_pg(struct dma_chan *chan,
+        struct page *page, unsigned int offset, void *kdata, size_t len);
+dma_cookie_t dma_async_memcpy_pg_to_pg(struct dma_chan *chan,
         struct page *dest_pg, unsigned int dest_off, struct page *src_pg,
-        unsigned int src_off, size_t len)
-{
-	struct dma_device *dev = chan->device;
-	struct dma_async_tx_descriptor *tx;
-	dma_addr_t addr;
-	dma_cookie_t cookie;
-	int cpu;
-
-	tx = dev->device_prep_dma_memcpy(chan, len, 0);
-	if (!tx)
-		return -ENOMEM;
-
-	tx->ack = 1;
-	addr = dma_map_page(dev->dev, src_pg, src_off, len, DMA_TO_DEVICE);
-	dev->device_set_src(addr, tx, 0);
-	addr = dma_map_page(dev->dev, dest_pg, dest_off, len, DMA_FROM_DEVICE);
-	dev->device_set_dest(addr, tx, 0);
-	cookie = dev->device_tx_submit(tx);
-
-	cpu = get_cpu();
-	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
-	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
-	put_cpu();
-
-	return cookie;
-}
-
-static inline void
-dma_async_tx_descriptor_init(struct dma_async_tx_descriptor *tx,
-	struct dma_chan *chan)
-{
-	tx->chan = chan;
-	spin_lock_init(&tx->lock);
-	INIT_LIST_HEAD(&tx->depend_node);
-	INIT_LIST_HEAD(&tx->depend_list);
-}
+        unsigned int src_off, size_t len);
+void dma_async_tx_descriptor_init(struct dma_async_tx_descriptor *tx,
+	struct dma_chan *chan);
 
 /**
  * dma_async_issue_pending - flush pending transactions to HW
diff -puN drivers/dma/dmaengine.c~dmaengine-uninline-large-functions drivers/dma/dmaengine.c
--- a/drivers/dma/dmaengine.c~dmaengine-uninline-large-functions
+++ a/drivers/dma/dmaengine.c
@@ -59,6 +59,7 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/mm.h>
 #include <linux/device.h>
 #include <linux/dmaengine.h>
 #include <linux/hardirq.h>
@@ -440,6 +441,143 @@ void dma_async_device_unregister(struct 
 }
 EXPORT_SYMBOL(dma_async_device_unregister);
 
+/**
+ * dma_async_memcpy_buf_to_buf - offloaded copy between virtual addresses
+ * @chan: DMA channel to offload copy to
+ * @dest: destination address (virtual)
+ * @src: source address (virtual)
+ * @len: length
+ *
+ * Both @dest and @src must be mappable to a bus address according to the
+ * DMA mapping API rules for streaming mappings.
+ * Both @dest and @src must stay memory resident (kernel memory or locked
+ * user space pages).
+ */
+dma_cookie_t dma_async_memcpy_buf_to_buf(struct dma_chan *chan,
+        void *dest, void *src, size_t len)
+{
+	struct dma_device *dev = chan->device;
+	struct dma_async_tx_descriptor *tx;
+	dma_addr_t addr;
+	dma_cookie_t cookie;
+	int cpu;
+
+	tx = dev->device_prep_dma_memcpy(chan, len, 0);
+	if (!tx)
+		return -ENOMEM;
+
+	tx->ack = 1;
+	addr = dma_map_single(dev->dev, src, len, DMA_TO_DEVICE);
+	dev->device_set_src(addr, tx, 0);
+	addr = dma_map_single(dev->dev, dest, len, DMA_FROM_DEVICE);
+	dev->device_set_dest(addr, tx, 0);
+	cookie = dev->device_tx_submit(tx);
+
+	cpu = get_cpu();
+	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
+	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
+	put_cpu();
+
+	return cookie;
+}
+EXPORT_SYMBOL(dma_async_memcpy_buf_to_buf);
+
+/**
+ * dma_async_memcpy_buf_to_pg - offloaded copy from address to page
+ * @chan: DMA channel to offload copy to
+ * @page: destination page
+ * @offset: offset in page to copy to
+ * @kdata: source address (virtual)
+ * @len: length
+ *
+ * Both @page/@offset and @kdata must be mappable to a bus address according
+ * to the DMA mapping API rules for streaming mappings.
+ * Both @page/@offset and @kdata must stay memory resident (kernel memory or
+ * locked user space pages)
+ */
+dma_cookie_t dma_async_memcpy_buf_to_pg(struct dma_chan *chan,
+        struct page *page, unsigned int offset, void *kdata, size_t len)
+{
+	struct dma_device *dev = chan->device;
+	struct dma_async_tx_descriptor *tx;
+	dma_addr_t addr;
+	dma_cookie_t cookie;
+	int cpu;
+
+	tx = dev->device_prep_dma_memcpy(chan, len, 0);
+	if (!tx)
+		return -ENOMEM;
+
+	tx->ack = 1;
+	addr = dma_map_single(dev->dev, kdata, len, DMA_TO_DEVICE);
+	dev->device_set_src(addr, tx, 0);
+	addr = dma_map_page(dev->dev, page, offset, len, DMA_FROM_DEVICE);
+	dev->device_set_dest(addr, tx, 0);
+	cookie = dev->device_tx_submit(tx);
+
+	cpu = get_cpu();
+	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
+	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
+	put_cpu();
+
+	return cookie;
+}
+EXPORT_SYMBOL(dma_async_memcpy_buf_to_pg);
+
+/**
+ * dma_async_memcpy_pg_to_pg - offloaded copy from page to page
+ * @chan: DMA channel to offload copy to
+ * @dest_pg: destination page
+ * @dest_off: offset in page to copy to
+ * @src_pg: source page
+ * @src_off: offset in page to copy from
+ * @len: length
+ *
+ * Both @dest_page/@dest_off and @src_page/@src_off must be mappable to a bus
+ * address according to the DMA mapping API rules for streaming mappings.
+ * Both @dest_page/@dest_off and @src_page/@src_off must stay memory resident
+ * (kernel memory or locked user space pages).
+ */
+dma_cookie_t dma_async_memcpy_pg_to_pg(struct dma_chan *chan,
+        struct page *dest_pg, unsigned int dest_off, struct page *src_pg,
+        unsigned int src_off, size_t len)
+{
+	struct dma_device *dev = chan->device;
+	struct dma_async_tx_descriptor *tx;
+	dma_addr_t addr;
+	dma_cookie_t cookie;
+	int cpu;
+
+	tx = dev->device_prep_dma_memcpy(chan, len, 0);
+	if (!tx)
+		return -ENOMEM;
+
+	tx->ack = 1;
+	addr = dma_map_page(dev->dev, src_pg, src_off, len, DMA_TO_DEVICE);
+	dev->device_set_src(addr, tx, 0);
+	addr = dma_map_page(dev->dev, dest_pg, dest_off, len, DMA_FROM_DEVICE);
+	dev->device_set_dest(addr, tx, 0);
+	cookie = dev->device_tx_submit(tx);
+
+	cpu = get_cpu();
+	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
+	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
+	put_cpu();
+
+	return cookie;
+}
+EXPORT_SYMBOL(dma_async_memcpy_pg_to_pg);
+
+void dma_async_tx_descriptor_init(struct dma_async_tx_descriptor *tx,
+	struct dma_chan *chan)
+{
+	tx->chan = chan;
+	spin_lock_init(&tx->lock);
+	INIT_LIST_HEAD(&tx->depend_node);
+	INIT_LIST_HEAD(&tx->depend_list);
+}
+EXPORT_SYMBOL(dma_async_tx_descriptor_init);
+
 static int __init dma_bus_init(void)
 {
 	mutex_init(&dma_list_mutex);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-arm.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
sis-warning-fixes.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
e1000-fix-shared-interrupt-warning-message-fix.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
git-s390.patch
git-scsi-misc.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs-fixup.patch
after-before-x86_64-mm-mmconfig-share.patch
xen-paravirt-core-xen-implementation-fix.patch
mincore-warning-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
git-gccbug-fixup.patch
