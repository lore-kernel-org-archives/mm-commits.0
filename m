From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-allow-setting-of-phys_device.patch removed from -mm tree
Date: Fri, 19 Mar 2010 12:49:11 -0400
Message-ID: <201003191949.o2JJnsaD009009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966Ab0CSTuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 15:50:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, gerald.schaefer@de.ibm.com, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: allow setting of phys_device
has been removed from the -mm tree.  Its filename was
     memory-hotplug-allow-setting-of-phys_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: allow setting of phys_device
From: Heiko Carstens <heiko.carstens@de.ibm.com>

/sys/devices/system/memory/memoryX/phys_device is supposed to contain the
number of the physical device that the corresponding piece of memory
belongs to.

In case a physical device should be replaced or taken offline for whatever
reason it is necessary to set all corresponding memory pieces offline. 
The current implementation always sets phys_device to '0' and there is no
way or hook to change that.  Seems like there was a plan to implement that
but it wasn't finished for whatever reason.

So add a weak function which architectures can override to actually set
the phys_device from within add_memory_block().

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |   15 ++++++++++-----
 include/linux/memory.h |    2 ++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff -puN drivers/base/memory.c~memory-hotplug-allow-setting-of-phys_device drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-allow-setting-of-phys_device
+++ a/drivers/base/memory.c
@@ -429,12 +429,16 @@ static inline int memory_fail_init(void)
  * differentiation between which *physical* devices each
  * section belongs to...
  */
+int __weak arch_get_memory_phys_device(unsigned long start_pfn)
+{
+	return 0;
+}
 
 static int add_memory_block(int nid, struct mem_section *section,
-			unsigned long state, int phys_device,
-			enum mem_add_context context)
+			unsigned long state, enum mem_add_context context)
 {
 	struct memory_block *mem = kzalloc(sizeof(*mem), GFP_KERNEL);
+	unsigned long start_pfn;
 	int ret = 0;
 
 	if (!mem)
@@ -443,7 +447,8 @@ static int add_memory_block(int nid, str
 	mem->phys_index = __section_nr(section);
 	mem->state = state;
 	mutex_init(&mem->state_mutex);
-	mem->phys_device = phys_device;
+	start_pfn = section_nr_to_pfn(mem->phys_index);
+	mem->phys_device = arch_get_memory_phys_device(start_pfn);
 
 	ret = register_memory(mem, section);
 	if (!ret)
@@ -515,7 +520,7 @@ int remove_memory_block(unsigned long no
  */
 int register_new_memory(int nid, struct mem_section *section)
 {
-	return add_memory_block(nid, section, MEM_OFFLINE, 0, HOTPLUG);
+	return add_memory_block(nid, section, MEM_OFFLINE, HOTPLUG);
 }
 
 int unregister_memory_section(struct mem_section *section)
@@ -548,7 +553,7 @@ int __init memory_dev_init(void)
 		if (!present_section_nr(i))
 			continue;
 		err = add_memory_block(0, __nr_to_section(i), MEM_ONLINE,
-					0, BOOT);
+				       BOOT);
 		if (!ret)
 			ret = err;
 	}
diff -puN include/linux/memory.h~memory-hotplug-allow-setting-of-phys_device include/linux/memory.h
--- a/include/linux/memory.h~memory-hotplug-allow-setting-of-phys_device
+++ a/include/linux/memory.h
@@ -36,6 +36,8 @@ struct memory_block {
 	struct sys_device sysdev;
 };
 
+int arch_get_memory_phys_device(unsigned long start_pfn);
+
 /* These states are exposed to userspace as text strings in sysfs */
 #define	MEM_ONLINE		(1<<0) /* exposed to userspace */
 #define	MEM_GOING_OFFLINE	(1<<1) /* exposed to userspace */
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
improve-sys_personality-for-compat-architectures.patch

