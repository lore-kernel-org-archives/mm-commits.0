From: akpm@linux-foundation.org
Subject: + memblock-numa-introduce-flags-field-into-memblock.patch added
 to -mm tree
Date: Tue, 03 Dec 2013 15:54:38 -0800
Message-ID: <529e6f3e.l+B8yDgMZxfJ//dn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3LCXyj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 18:54:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, wency@cn.fujitsu.com, vasilis.liaskovitis@profitbricks.com, trenn@suse.de, toshi.kani@hp.com, tj@kernel.org, tglx@linutronix.de, rjw@sisk.pl, riel@redhat.com, prarit@redhat.com, mingo@elte.hu, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, lwoodman@redhat.com, liwanp@linux.vnet.ibm.com, lenb@kernel.org, laijs@cn.fujitsu.com, jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, imtangchen@gmail.com, hpa@zytor.com, hannes@cmpxchg.org, gong.chen@linux.intel.com, tangchen@cn.fujitsu.com

Subject: + memblock-numa-introduce-flags-field-into-memblock.patch added to -mm tree
To: tangchen@cn.fujitsu.com,gong.chen@linux.intel.com,hannes@cmpxchg.org,hpa@zytor.com,imtangchen@gmail.com,isimatu.yasuaki@jp.fujitsu.com,izumi.taku@jp.fujitsu.com,jiang.liu@huawei.com,laijs@cn.fujitsu.com,lenb@kernel.org,liwanp@linux.vnet.ibm.com,lwoodman@redhat.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,mingo@elte.hu,prarit@redhat.com,riel@redhat.com,rjw@sisk.pl,tglx@linutronix.de,tj@kernel.org,toshi.kani@hp.com,trenn@suse.de,vasilis.liaskovitis@profitbricks.com,wency@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 15:54:37 -0800


The patch titled
     Subject: memblock, numa: introduce flags field into memblock
has been added to the -mm tree.  Its filename is
     memblock-numa-introduce-flags-field-into-memblock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memblock-numa-introduce-flags-field-into-memblock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memblock-numa-introduce-flags-field-into-memblock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: memblock, numa: introduce flags field into memblock

There is no flag in memblock to describe what type the memory is. 
Sometimes, we may use memblock to reserve some memory for special usage. 
And we want to know what kind of memory it is.  So we need a way to

In hotplug environment, we want to reserve hotpluggable memory so the
kernel won't be able to use it.  And when the system is up, we have to
free these hotpluggable memory to buddy.  So we need to mark these memory
first.

In order to do so, we need to mark out these special memory in memblock.
In this patch, we introduce a new "flags" member into memblock_region:
   struct memblock_region {
           phys_addr_t base;
           phys_addr_t size;
           unsigned long flags;		/* This is new. */
   #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
           int nid;
   #endif
   };

This patch does the following things:
1) Add "flags" member to memblock_region.
2) Modify the following APIs' prototype:
	memblock_add_region()
	memblock_insert_region()
3) Add memblock_reserve_region() to support reserve memory with flags, and keep
   memblock_reserve()'s prototype unmodified.
4) Modify other APIs to support flags, but keep their prototype unmodified.

The idea is from Wen Congyang <wency@cn.fujitsu.com> and Liu Jiang <jiang.liu@huawei.com>.

Suggested-by: Wen Congyang <wency@cn.fujitsu.com>
Suggested-by: Liu Jiang <jiang.liu@huawei.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Chen Tang <imtangchen@gmail.com>
Cc: Gong Chen <gong.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    1 
 mm/memblock.c            |   53 ++++++++++++++++++++++++++-----------
 2 files changed, 39 insertions(+), 15 deletions(-)

diff -puN include/linux/memblock.h~memblock-numa-introduce-flags-field-into-memblock include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-numa-introduce-flags-field-into-memblock
+++ a/include/linux/memblock.h
@@ -22,6 +22,7 @@
 struct memblock_region {
 	phys_addr_t base;
 	phys_addr_t size;
+	unsigned long flags;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	int nid;
 #endif
diff -puN mm/memblock.c~memblock-numa-introduce-flags-field-into-memblock mm/memblock.c
--- a/mm/memblock.c~memblock-numa-introduce-flags-field-into-memblock
+++ a/mm/memblock.c
@@ -255,6 +255,7 @@ static void __init_memblock memblock_rem
 		type->cnt = 1;
 		type->regions[0].base = 0;
 		type->regions[0].size = 0;
+		type->regions[0].flags = 0;
 		memblock_set_region_node(&type->regions[0], MAX_NUMNODES);
 	}
 }
@@ -405,7 +406,8 @@ static void __init_memblock memblock_mer
 
 		if (this->base + this->size != next->base ||
 		    memblock_get_region_node(this) !=
-		    memblock_get_region_node(next)) {
+		    memblock_get_region_node(next) ||
+		    this->flags != next->flags) {
 			BUG_ON(this->base + this->size > next->base);
 			i++;
 			continue;
@@ -425,13 +427,15 @@ static void __init_memblock memblock_mer
  * @base:	base address of the new region
  * @size:	size of the new region
  * @nid:	node id of the new region
+ * @flags:	flags of the new region
  *
  * Insert new memblock region [@base,@base+@size) into @type at @idx.
  * @type must already have extra room to accomodate the new region.
  */
 static void __init_memblock memblock_insert_region(struct memblock_type *type,
 						   int idx, phys_addr_t base,
-						   phys_addr_t size, int nid)
+						   phys_addr_t size,
+						   int nid, unsigned long flags)
 {
 	struct memblock_region *rgn = &type->regions[idx];
 
@@ -439,6 +443,7 @@ static void __init_memblock memblock_ins
 	memmove(rgn + 1, rgn, (type->cnt - idx) * sizeof(*rgn));
 	rgn->base = base;
 	rgn->size = size;
+	rgn->flags = flags;
 	memblock_set_region_node(rgn, nid);
 	type->cnt++;
 	type->total_size += size;
@@ -450,6 +455,7 @@ static void __init_memblock memblock_ins
  * @base: base address of the new region
  * @size: size of the new region
  * @nid: nid of the new region
+ * @flags: flags of the new region
  *
  * Add new memblock region [@base,@base+@size) into @type.  The new region
  * is allowed to overlap with existing ones - overlaps don't affect already
@@ -460,7 +466,8 @@ static void __init_memblock memblock_ins
  * 0 on success, -errno on failure.
  */
 static int __init_memblock memblock_add_region(struct memblock_type *type,
-				phys_addr_t base, phys_addr_t size, int nid)
+				phys_addr_t base, phys_addr_t size,
+				int nid, unsigned long flags)
 {
 	bool insert = false;
 	phys_addr_t obase = base;
@@ -475,6 +482,7 @@ static int __init_memblock memblock_add_
 		WARN_ON(type->cnt != 1 || type->total_size);
 		type->regions[0].base = base;
 		type->regions[0].size = size;
+		type->regions[0].flags = flags;
 		memblock_set_region_node(&type->regions[0], nid);
 		type->total_size = size;
 		return 0;
@@ -505,7 +513,8 @@ repeat:
 			nr_new++;
 			if (insert)
 				memblock_insert_region(type, i++, base,
-						       rbase - base, nid);
+						       rbase - base, nid,
+						       flags);
 		}
 		/* area below @rend is dealt with, forget about it */
 		base = min(rend, end);
@@ -515,7 +524,8 @@ repeat:
 	if (base < end) {
 		nr_new++;
 		if (insert)
-			memblock_insert_region(type, i, base, end - base, nid);
+			memblock_insert_region(type, i, base, end - base,
+					       nid, flags);
 	}
 
 	/*
@@ -537,12 +547,13 @@ repeat:
 int __init_memblock memblock_add_node(phys_addr_t base, phys_addr_t size,
 				       int nid)
 {
-	return memblock_add_region(&memblock.memory, base, size, nid);
+	return memblock_add_region(&memblock.memory, base, size, nid, 0);
 }
 
 int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
 {
-	return memblock_add_region(&memblock.memory, base, size, MAX_NUMNODES);
+	return memblock_add_region(&memblock.memory, base, size,
+				   MAX_NUMNODES, 0);
 }
 
 /**
@@ -597,7 +608,8 @@ static int __init_memblock memblock_isol
 			rgn->size -= base - rbase;
 			type->total_size -= base - rbase;
 			memblock_insert_region(type, i, rbase, base - rbase,
-					       memblock_get_region_node(rgn));
+					       memblock_get_region_node(rgn),
+					       rgn->flags);
 		} else if (rend > end) {
 			/*
 			 * @rgn intersects from above.  Split and redo the
@@ -607,7 +619,8 @@ static int __init_memblock memblock_isol
 			rgn->size -= end - rbase;
 			type->total_size -= end - rbase;
 			memblock_insert_region(type, i--, rbase, end - rbase,
-					       memblock_get_region_node(rgn));
+					       memblock_get_region_node(rgn),
+					       rgn->flags);
 		} else {
 			/* @rgn is fully contained, record it */
 			if (!*end_rgn)
@@ -649,16 +662,24 @@ int __init_memblock memblock_free(phys_a
 	return __memblock_remove(&memblock.reserved, base, size);
 }
 
-int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
+static int __init_memblock memblock_reserve_region(phys_addr_t base,
+						   phys_addr_t size,
+						   int nid,
+						   unsigned long flags)
 {
 	struct memblock_type *_rgn = &memblock.reserved;
 
-	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] %pF\n",
+	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] flags %#02lx %pF\n",
 		     (unsigned long long)base,
 		     (unsigned long long)base + size,
-		     (void *)_RET_IP_);
+		     flags, (void *)_RET_IP_);
+
+	return memblock_add_region(_rgn, base, size, nid, flags);
+}
 
-	return memblock_add_region(_rgn, base, size, MAX_NUMNODES);
+int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_reserve_region(base, size, MAX_NUMNODES, 0);
 }
 
 /**
@@ -1101,6 +1122,7 @@ void __init_memblock memblock_set_curren
 static void __init_memblock memblock_dump(struct memblock_type *type, char *name)
 {
 	unsigned long long base, size;
+	unsigned long flags;
 	int i;
 
 	pr_info(" %s.cnt  = 0x%lx\n", name, type->cnt);
@@ -1111,13 +1133,14 @@ static void __init_memblock memblock_dum
 
 		base = rgn->base;
 		size = rgn->size;
+		flags = rgn->flags;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 		if (memblock_get_region_node(rgn) != MAX_NUMNODES)
 			snprintf(nid_buf, sizeof(nid_buf), " on node %d",
 				 memblock_get_region_node(rgn));
 #endif
-		pr_info(" %s[%#x]\t[%#016llx-%#016llx], %#llx bytes%s\n",
-			name, i, base, base + size - 1, size, nid_buf);
+		pr_info(" %s[%#x]\t[%#016llx-%#016llx], %#llx bytes%s flags: %#lx\n",
+			name, i, base, base + size - 1, size, nid_buf, flags);
 	}
 }
 
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch

