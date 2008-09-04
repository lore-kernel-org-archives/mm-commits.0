From: akpm@linux-foundation.org
Subject: + show-memory-section-to-node-relationship-in-sysfs.patch added to -mm tree
Date: Thu, 04 Sep 2008 14:40:10 -0700
Message-ID: <200809042140.m84LeA6O032541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbYIDVl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 17:41:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: garyhade@us.ibm.com, lcm@us.ibm.com, mel@csn.ul.ie, pbadari@us.ibm.com, y-goto@jp.fujitsu.com


The patch titled
     mm: show memory section to node relationship in sysfs
has been added to the -mm tree.  Its filename is
     show-memory-section-to-node-relationship-in-sysfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: show memory section to node relationship in sysfs
From: Gary Hade <garyhade@us.ibm.com>

Show memory section to node relationship in sysfs

Add /sys/devices/system/memory/memoryX/node files to show
the node on which each memory section resides.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Chris McDermott <lcm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-hotplug.txt |    1 -
 drivers/base/memory.c            |   20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff -puN Documentation/memory-hotplug.txt~show-memory-section-to-node-relationship-in-sysfs Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~show-memory-section-to-node-relationship-in-sysfs
+++ a/Documentation/memory-hotplug.txt
@@ -365,7 +365,6 @@ node if necessary.
   - allowing memory hot-add to ZONE_MOVABLE. maybe we need some switch like
     sysctl or new control file.
   - showing memory section and physical device relationship.
-  - showing memory section and node relationship (maybe good for NUMA)
   - showing memory section is under ZONE_MOVABLE or not
   - test and make it better memory offlining.
   - support HugeTLB page migration and offlining.
diff -puN drivers/base/memory.c~show-memory-section-to-node-relationship-in-sysfs drivers/base/memory.c
--- a/drivers/base/memory.c~show-memory-section-to-node-relationship-in-sysfs
+++ a/drivers/base/memory.c
@@ -150,6 +150,22 @@ static ssize_t show_mem_state(struct sys
 	return len;
 }
 
+/*
+ * node on which memory section resides
+ */
+static ssize_t show_mem_node(struct sys_device *dev,
+			struct sysdev_attribute *attr, char *buf)
+{
+	unsigned long start_pfn;
+	int ret;
+	struct memory_block *mem =
+		container_of(dev, struct memory_block, sysdev);
+
+	start_pfn = section_nr_to_pfn(mem->phys_index);
+	ret = pfn_to_nid(start_pfn);
+	return sprintf(buf, "%d\n", ret);
+}
+
 int memory_notify(unsigned long val, void *v)
 {
 	return blocking_notifier_call_chain(&memory_chain, val, v);
@@ -278,6 +294,7 @@ static SYSDEV_ATTR(phys_index, 0444, sho
 static SYSDEV_ATTR(state, 0644, show_mem_state, store_mem_state);
 static SYSDEV_ATTR(phys_device, 0444, show_phys_device, NULL);
 static SYSDEV_ATTR(removable, 0444, show_mem_removable, NULL);
+static SYSDEV_ATTR(node, 0444, show_mem_node, NULL);
 
 #define mem_create_simple_file(mem, attr_name)	\
 	sysdev_create_file(&mem->sysdev, &attr_##attr_name)
@@ -368,6 +385,8 @@ static int add_memory_block(unsigned lon
 		ret = mem_create_simple_file(mem, phys_device);
 	if (!ret)
 		ret = mem_create_simple_file(mem, removable);
+	if (!ret)
+		ret = mem_create_simple_file(mem, node);
 
 	return ret;
 }
@@ -413,6 +432,7 @@ int remove_memory_block(unsigned long no
 	mem_remove_simple_file(mem, state);
 	mem_remove_simple_file(mem, phys_device);
 	mem_remove_simple_file(mem, removable);
+	mem_remove_simple_file(mem, node);
 	unregister_memory(mem, section);
 
 	return 0;
_

Patches currently in -mm which might be from garyhade@us.ibm.com are

x86_64-add-memory-hotremove-config-option.patch
show-memory-section-to-node-relationship-in-sysfs.patch

