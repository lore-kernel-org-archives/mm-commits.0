From: akpm@linux-foundation.org
Subject: +
 drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup.patch
 added to -mm tree
Date: Thu, 09 Jan 2020 14:00:17 -0800
Message-ID: <20200109220017.1MKFeiAQb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgAIWAT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 17:00:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cheloha@linux.ibm.com, cheloha@linux.vnet.ibm.com, david@redhat.com, gregkh@linuxfoundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, nathanl@linux.ibm.com, rafael@kernel.org, ricklind@linux.vnet.ibm.com


The patch titled
     Subject: drivers/base/memory.c: cache blocks in radix tree to accelerate lookup
has been added to the -mm tree.  Its filename is
     drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Scott Cheloha <cheloha@linux.vnet.ibm.com>
Subject: drivers/base/memory.c: cache blocks in radix tree to accelerate lookup

Searching for a particular memory block by id is an O(n) operation because
each memory block's underlying device is kept in an unsorted linked list
on the subsystem bus.

We can cut the lookup cost to O(log n) if we cache the memory blocks in a
radix tree.  With a radix tree cache in place both memory subsystem
initialization and memory hotplug run palpably faster on systems with a
large number of memory blocks.

1. A 32GB POWER9 VM with 16MB memblocks has 2048 blocks:

# Unpatched
[    0.005121] adding memory block 0... ok
[...]
[    0.095230] adding memory block 1024... ok
[...]
[    0.304248] adding memory block 2047... ok
[    0.304508] added all memory blocks

# Patched
[    0.004701] adding memory block 0... ok
[...]
[    0.033383] adding memory block 1024... ok
[...]
[    0.061387] adding memory block 2047... ok
[    0.061414] added all memory blocks

   Unpatched, memory_dev_init() runs in about 0.299 seconds.  Patched,
   it runs in about 0.057 seconds.  Savings of .242 seconds, or nearly
   a quarter of a second.

2. A 32TB POWER9 LPAR with 256MB memblocks has 131072 blocks:

# Unpatched
[   13.703907] memory_dev_init: adding blocks
[   13.703931] memory_dev_init: added block 0
[   13.762678] memory_dev_init: added block 1024
[   13.910359] memory_dev_init: added block 2048
[   14.146941] memory_dev_init: added block 3072
[...]
[  218.516235] memory_dev_init: added block 57344
[  229.310467] memory_dev_init: added block 58368
[  240.590857] memory_dev_init: added block 59392
[  252.351665] memory_dev_init: added block 60416
[...]
[ 2152.023248] memory_dev_init: added block 128000
[ 2196.464430] memory_dev_init: added block 129024
[ 2241.746515] memory_dev_init: added block 130048
[ 2287.406099] memory_dev_init: added all blocks

# Patched
[   13.696898] memory_dev_init: adding blocks
[   13.696920] memory_dev_init: added block 0
[   13.710966] memory_dev_init: added block 1024
[   13.724865] memory_dev_init: added block 2048
[   13.738802] memory_dev_init: added block 3072
[...]
[   14.520999] memory_dev_init: added block 57344
[   14.536355] memory_dev_init: added block 58368
[   14.551747] memory_dev_init: added block 59392
[   14.567128] memory_dev_init: added block 60416
[...]
[   15.595638] memory_dev_init: added block 126976
[   15.611761] memory_dev_init: added block 128000
[   15.627889] memory_dev_init: added block 129024
[   15.644048] memory_dev_init: added block 130048
[   15.660035] memory_dev_init: added all blocks

   Unpatched, memory_dev_init() runs in about 2275 seconds, or ~37
   minutes.  Patched, memory_dev_init() runs in about 1.97 seconds. 
   Savings of ~37 minutes.

   I did not actually measure walk_memory_blocks(), but during boot on
   this machine without the patch I got the following (abbreviated)
   traces:

[ 2347.494986] [c000000014c5bb60] [c000000000869af4] walk_memory_blocks+0x94/0x160
[ 2527.625378] [c000000014c5bb60] [c000000000869af4] walk_memory_blocks+0x94/0x160
[ 2707.761977] [c000000014c5bb60] [c000000000869af4] walk_memory_blocks+0x94/0x160
[ 2887.899975] [c000000014c5bb60] [c000000000869af4] walk_memory_blocks+0x94/0x160
[ 3068.028318] [c000000014c5bb60] [c000000000869af4] walk_memory_blocks+0x94/0x160
[ 3248.158764] [c000000014c5bb60] [c000000000869af4] walk_memory_blocks+0x94/0x160
[ 3428.287296] [c000000014c5bb60] [c000000000869af4] walk_memory_blocks+0x94/0x160
[ 3608.425357] [c000000014c5bb60] [c000000000869af4] walk_memory_blocks+0x94/0x160
[ 3788.554572] [c000000014c5bb60] [c000000000869af4] walk_memory_blocks+0x94/0x160
[ 3968.695071] [c000000014c5bb60] [c000000000869af4] walk_memory_blocks+0x94/0x160
[ 4148.823970] [c000000014c5bb60] [c000000000869af4] walk_memory_blocks+0x94/0x160

   Those traces disappeared with the patch, so I'm pretty sure this
   patch shaves ~30 minutes off of walk_memory_blocks() at boot.

Given the above results I think it is safe to say that this patch will
dramatically improve boot times on large POWER systems.

Link: http://lkml.kernel.org/r/20200109212516.17849-1-cheloha@linux.vnet.ibm.com
Signed-off-by: Scott Cheloha <cheloha@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Nathan Lynch <nathanl@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Rick Lindsley <ricklind@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup
+++ a/drivers/base/memory.c
@@ -19,6 +19,7 @@
 #include <linux/memory.h>
 #include <linux/memory_hotplug.h>
 #include <linux/mm.h>
+#include <linux/radix-tree.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
 
@@ -56,6 +57,13 @@ static struct bus_type memory_subsys = {
 	.offline = memory_subsys_offline,
 };
 
+/*
+ * Memory blocks are cached in a local radix tree to avoid
+ * a costly linear search for the corresponding device on
+ * the subsystem bus.
+ */
+static RADIX_TREE(memory_blocks, GFP_KERNEL);
+
 static BLOCKING_NOTIFIER_HEAD(memory_chain);
 
 int register_memory_notifier(struct notifier_block *nb)
@@ -572,20 +580,14 @@ int __weak arch_get_memory_phys_device(u
 /* A reference for the returned memory block device is acquired. */
 static struct memory_block *find_memory_block_by_id(unsigned long block_id)
 {
-	struct device *dev;
+	struct memory_block *mem;
 
-	dev = subsys_find_device_by_id(&memory_subsys, block_id, NULL);
-	return dev ? to_memory_block(dev) : NULL;
+	mem = radix_tree_lookup(&memory_blocks, block_id);
+	if (mem)
+		get_device(&mem->dev);
+	return mem;
 }
 
-/*
- * For now, we have a linear search to go find the appropriate
- * memory_block corresponding to a particular phys_index. If
- * this gets to be a real problem, we can always use a radix
- * tree or something here.
- *
- * This could be made generic for all device subsystems.
- */
 struct memory_block *find_memory_block(struct mem_section *section)
 {
 	unsigned long block_id = base_memory_block_id(__section_nr(section));
@@ -628,9 +630,15 @@ int register_memory(struct memory_block
 	memory->dev.offline = memory->state == MEM_OFFLINE;
 
 	ret = device_register(&memory->dev);
-	if (ret)
+	if (ret) {
 		put_device(&memory->dev);
