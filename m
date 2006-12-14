From: akpm@osdl.org
Subject: + fix-kernel-doc-warnings-in-2620-rc1.patch added to -mm tree
Date: Thu, 14 Dec 2006 13:43:53 -0800
Message-ID: <200612142143.kBELhrZT029387@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:32886 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932950AbWLNVoI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 16:44:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     fix kernel-doc warnings in 2.6.20-rc1
has been added to the -mm tree.  Its filename is
     fix-kernel-doc-warnings-in-2620-rc1.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix kernel-doc warnings in 2.6.20-rc1
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in 2.6.20-rc1.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 block/ll_rw_blk.c              |    1 +
 drivers/base/firmware_class.c  |    1 +
 drivers/message/i2o/exec-osm.c |    2 +-
 kernel/relay.c                 |    2 +-
 kernel/workqueue.c             |    4 ++--
 mm/slab.c                      |    1 +
 6 files changed, 7 insertions(+), 4 deletions(-)

diff -puN block/ll_rw_blk.c~fix-kernel-doc-warnings-in-2620-rc1 block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~fix-kernel-doc-warnings-in-2620-rc1
+++ a/block/ll_rw_blk.c
@@ -2464,6 +2464,7 @@ EXPORT_SYMBOL(blk_rq_map_user);
  * @rq:		request to map data to
  * @iov:	pointer to the iovec
  * @iov_count:	number of elements in the iovec
+ * @len:	I/O byte count
  *
  * Description:
  *    Data will be mapped directly for zero copy io, if possible. Otherwise
diff -puN drivers/base/firmware_class.c~fix-kernel-doc-warnings-in-2620-rc1 drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~fix-kernel-doc-warnings-in-2620-rc1
+++ a/drivers/base/firmware_class.c
@@ -127,6 +127,7 @@ static ssize_t firmware_loading_show(str
 /**
  * firmware_loading_store - set value in the 'loading' control file
  * @dev: device pointer
+ * @attr: device attribute pointer
  * @buf: buffer to scan for loading control value
  * @count: number of bytes in @buf
  *
diff -puN drivers/message/i2o/exec-osm.c~fix-kernel-doc-warnings-in-2620-rc1 drivers/message/i2o/exec-osm.c
--- a/drivers/message/i2o/exec-osm.c~fix-kernel-doc-warnings-in-2620-rc1
+++ a/drivers/message/i2o/exec-osm.c
@@ -367,7 +367,7 @@ static int i2o_exec_remove(struct device
 
 /**
  *	i2o_exec_lct_modified - Called on LCT NOTIFY reply
- *	@work: work struct for a specific controller
+ *	@_work: work struct for a specific controller
  *
  *	This function handles asynchronus LCT NOTIFY replies. It parses the
  *	new LCT and if the buffer for the LCT was to small sends a LCT NOTIFY
diff -puN kernel/relay.c~fix-kernel-doc-warnings-in-2620-rc1 kernel/relay.c
--- a/kernel/relay.c~fix-kernel-doc-warnings-in-2620-rc1
+++ a/kernel/relay.c
@@ -302,7 +302,7 @@ static struct rchan_callbacks default_ch
 
 /**
  *	wakeup_readers - wake up readers waiting on a channel
- *	@private: the channel buffer
+ *	@work: work struct that contains the the channel buffer
  *
  *	This is the work function used to defer reader waking.  The
  *	reason waking is deferred is that calling directly from write
diff -puN kernel/workqueue.c~fix-kernel-doc-warnings-in-2620-rc1 kernel/workqueue.c
--- a/kernel/workqueue.c~fix-kernel-doc-warnings-in-2620-rc1
+++ a/kernel/workqueue.c
@@ -233,7 +233,7 @@ static void delayed_work_timer_fn(unsign
 /**
  * queue_delayed_work - queue work on a workqueue after delay
  * @wq: workqueue to use
- * @work: delayable work to queue
+ * @dwork: delayable work to queue
  * @delay: number of jiffies to wait before queueing
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
@@ -268,7 +268,7 @@ EXPORT_SYMBOL_GPL(queue_delayed_work);
  * queue_delayed_work_on - queue work on specific CPU after delay
  * @cpu: CPU number to execute work on
  * @wq: workqueue to use
- * @work: work to queue
+ * @dwork: work to queue
  * @delay: number of jiffies to wait before queueing
  *
  * Returns 0 if @work was already on a queue, non-zero otherwise.
diff -puN mm/slab.c~fix-kernel-doc-warnings-in-2620-rc1 mm/slab.c
--- a/mm/slab.c~fix-kernel-doc-warnings-in-2620-rc1
+++ a/mm/slab.c
@@ -3587,6 +3587,7 @@ out:
  * @cachep: The cache to allocate from.
  * @flags: See kmalloc().
  * @nodeid: node number of the target node.
+ * @caller: return address of caller, used for debug information
  *
  * Identical to kmem_cache_alloc but it will allocate memory on the given
  * node, which can improve the performance for cpu bound structures.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

fix-kernel-doc-warnings-in-2620-rc1.patch
git-acpi.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch

