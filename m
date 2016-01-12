From: akpm@linux-foundation.org
Subject: [to-be-updated]
 memory-hotplug-add-automatic-onlining-policy-for-the-newly-added-memory.patch removed from -mm tree
Date: Tue, 12 Jan 2016 15:01:26 -0800
Message-ID: <569585c6.abAIzYt/oJqRl2+R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbcALXB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jan 2016 18:01:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, boris.ostrovsky@oracle.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.kiper@oracle.com, david.vrabel@citrix.com, gregkh@linuxfoundation.org, imammedo@redhat.com, kay@vrfy.org, konrad.wilk@oracle.com, kys@microsoft.com, mgorman@techsingularity.net, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, rientjes@google.com, tangchen@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: add automatic onlining policy for the newly added memory
has been removed from the -mm tree.  Its filename was
     memory-hotplug-add-automatic-onlining-policy-for-the-newly-added-memory.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: memory-hotplug: add automatic onlining policy for the newly added memory

Currently, all newly added memory blocks remain in 'offline' state unless
someone onlines them, some linux distributions carry special udev rules
like:

SUBSYSTEM=="memory", ACTION=="add", ATTR{state}=="offline", ATTR{state}="online"

to make this happen automatically.  This is not a great solution for
virtual machines where memory hotplug is being used to address high memory
pressure situations as such onlining is slow and a userspace process doing
this (udev) has a chance of being killed by the OOM killer as it will
probably require to allocate some memory.

Introduce default policy for the newly added memory blocks in
/sys/devices/system/memory/auto_online_blocks file with two possible
values: "offline" which preserves the current behavior and "online" which
causes all newly added memory blocks to go online as soon as they're
added.  The default is "offline".

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-hotplug.txt |   19 +++++++++++++----
 drivers/base/memory.c            |   32 +++++++++++++++++++++++++++++
 drivers/xen/balloon.c            |    2 -
 include/linux/memory_hotplug.h   |    4 ++-
 mm/memory_hotplug.c              |   12 +++++++++-
 5 files changed, 61 insertions(+), 8 deletions(-)

diff -puN Documentation/memory-hotplug.txt~memory-hotplug-add-automatic-onlining-policy-for-the-newly-added-memory Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~memory-hotplug-add-automatic-onlining-policy-for-the-newly-added-memory
+++ a/Documentation/memory-hotplug.txt
@@ -254,12 +254,23 @@ If the memory block is online, you'll re
 If the memory block is offline, you'll read "offline".
 
 
-5.2. How to online memory
+5.2. Memory onlining
 ------------
-Even if the memory is hot-added, it is not at ready-to-use state.
-For using newly added memory, you have to "online" the memory block.
+When the memory is hot-added, the kernel decides whether or not to "online"
+it according to the policy which can be read from "auto_online_blocks" file:
 
-For onlining, you have to write "online" to the memory block's state file as:
+% cat /sys/devices/system/memory/auto_online_blocks
+
+The default is "offline" which means the newly added memory is not in a
+ready-to-use state and you have to "online" the newly added memory blocks
+manually. Automatic onlining can be requested by writing "online" to
+"auto_online_blocks" file:
+
+% echo online > /sys/devices/system/memory/auto_online_blocks
+
+If the automatic onlining wasn't requested or some memory block was offlined
+it is possible to change the individual block's state by writing to the "state"
+file:
 
 % echo online > /sys/devices/system/memory/memoryXXX/state
 
diff -puN drivers/base/memory.c~memory-hotplug-add-automatic-onlining-policy-for-the-newly-added-memory drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-add-automatic-onlining-policy-for-the-newly-added-memory
+++ a/drivers/base/memory.c
@@ -439,6 +439,37 @@ print_block_size(struct device *dev, str
 static DEVICE_ATTR(block_size_bytes, 0444, print_block_size, NULL);
 
 /*
+ * Memory auto online policy.
+ */
+
+static ssize_t
+show_auto_online_blocks(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	if (memhp_auto_online)
+		return sprintf(buf, "online\n");
+	else
+		return sprintf(buf, "offline\n");
+}
+
+static ssize_t
+store_auto_online_blocks(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	if (sysfs_streq(buf, "online"))
+		memhp_auto_online = true;
+	else if (sysfs_streq(buf, "offline"))
+		memhp_auto_online = false;
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+static DEVICE_ATTR(auto_online_blocks, 0644, show_auto_online_blocks,
+		   store_auto_online_blocks);
+
+/*
  * Some architectures will have custom drivers to do this, and
  * will not need to do it from userspace.  The fake hot-add code
  * as well as ppc64 will do all of their discovery in userspace
@@ -733,6 +764,7 @@ static struct attribute *memory_root_att
 #endif
 
 	&dev_attr_block_size_bytes.attr,
+	&dev_attr_auto_online_blocks.attr,
 	NULL
 };
 
diff -puN drivers/xen/balloon.c~memory-hotplug-add-automatic-onlining-policy-for-the-newly-added-memory drivers/xen/balloon.c
--- a/drivers/xen/balloon.c~memory-hotplug-add-automatic-onlining-policy-for-the-newly-added-memory
+++ a/drivers/xen/balloon.c
@@ -338,7 +338,7 @@ static enum bp_state reserve_additional_
 	}
 #endif
 
-	rc = add_memory_resource(nid, resource);
+	rc = add_memory_resource(nid, resource, false);
 	if (rc) {
 		pr_warn("Cannot add additional memory (%i)\n", rc);
 		goto err;
diff -puN include/linux/memory_hotplug.h~memory-hotplug-add-automatic-onlining-policy-for-the-newly-added-memory include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-add-automatic-onlining-policy-for-the-newly-added-memory
+++ a/include/linux/memory_hotplug.h
@@ -99,6 +99,8 @@ extern void __online_page_free(struct pa
 
 extern int try_online_node(int nid);
 
+extern bool memhp_auto_online;
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 extern bool is_pageblock_removable_nolock(struct page *page);
 extern int arch_remove_memory(u64 start, u64 size);
@@ -267,7 +269,7 @@ static inline void remove_memory(int nid
 extern int walk_memory_range(unsigned long start_pfn, unsigned long end_pfn,
 		void *arg, int (*func)(struct memory_block *, void *));
 extern int add_memory(int nid, u64 start, u64 size);
-extern int add_memory_resource(int nid, struct resource *resource);
+extern int add_memory_resource(int nid, struct resource *resource, bool online);
 extern int zone_for_memory(int nid, u64 start, u64 size, int zone_default,
 		bool for_device);
 extern int arch_add_memory(int nid, u64 start, u64 size, bool for_device);
diff -puN mm/memory_hotplug.c~memory-hotplug-add-automatic-onlining-policy-for-the-newly-added-memory mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-add-automatic-onlining-policy-for-the-newly-added-memory
+++ a/mm/memory_hotplug.c
@@ -76,6 +76,9 @@ static struct {
 #define memhp_lock_acquire()      lock_map_acquire(&mem_hotplug.dep_map)
 #define memhp_lock_release()      lock_map_release(&mem_hotplug.dep_map)
 
+bool memhp_auto_online;
+EXPORT_SYMBOL_GPL(memhp_auto_online);
+
 void get_online_mems(void)
 {
 	might_sleep();
@@ -1235,7 +1238,7 @@ int zone_for_memory(int nid, u64 start,
 }
 
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
-int __ref add_memory_resource(int nid, struct resource *res)
+int __ref add_memory_resource(int nid, struct resource *res, bool online)
 {
 	u64 start, size;
 	pg_data_t *pgdat = NULL;
@@ -1295,6 +1298,11 @@ int __ref add_memory_resource(int nid, s
 	/* create new memmap entry */
 	firmware_map_add_hotplug(start, start + size, "System RAM");
 
+	/* online pages if requested */
+	if (online)
+		online_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT,
+			     MMOP_ONLINE_KEEP);
+
 	goto out;
 
 error:
@@ -1318,7 +1326,7 @@ int __ref add_memory(int nid, u64 start,
 	if (IS_ERR(res))
 		return PTR_ERR(res);
 
-	ret = add_memory_resource(nid, res);
+	ret = add_memory_resource(nid, res, memhp_auto_online);
 	if (ret < 0)
 		release_memory_resource(res);
 	return ret;
_

Patches currently in -mm which might be from vkuznets@redhat.com are

memory-hotplug-dont-bug-in-register_memory_resource.patch
memory-hotplug-dont-bug-in-register_memory_resource-v2.patch
memory-hotplug-keep-the-request_resource-error-code.patch

