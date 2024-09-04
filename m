Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869636F2E3
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423441; cv=none; b=p+R3pfovFPTMjNq9tA4C29xEpHNTUWflYV2I2dVIrZWj0594Fj3GDwC1ZHW26HZ6Twdu1fG585NUcwbxepoya14qwdR4cvOe/Mu6kRE/KjoUhwfgBfMShjEAw5J7llsvfaw+aso++I8tcIJTJrQkx3BgzIHBoLPlW4x12dIvEQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423441; c=relaxed/simple;
	bh=xnoKnprV3G6ekwvEyIdq0Suyv2vmGnrgiCZbYyirJLY=;
	h=Date:To:From:Subject:Message-Id; b=VIcQaW3H4BoMLtGAsYtWox9kRHja2tHoxVvp+uJTEsgCw0zBZzt3wim0RjS500kdkRJS+2x6Hw0/H5qF98MwY5iszfFsKG1fB5e4y8Q5QbGIrA9CM2UozuyvS/8Fe0bxrWPIcuIr15xhTocVrWOHS5Wgmd1pVtPb83iR0g2Zs4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QHciMxqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QHciMxqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53999C4CEC2;
	Wed,  4 Sep 2024 04:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423441;
	bh=xnoKnprV3G6ekwvEyIdq0Suyv2vmGnrgiCZbYyirJLY=;
	h=Date:To:From:Subject:From;
	b=QHciMxqBjFqXRPf7oN+Kn/hKIv7TlzaxtYLFdmRtF/qnmO4Xrzh9eBD95AZ8ljXWA
	 l2c0KgQLhzdwx7DoADTZ6451plfs93l9iCCbZhsojo+CZmZf6g1uvIi+GB4OtK6kn4
	 6+YUuMsGlB3xcIFGrborLHGbiqk/FfL/IKaR5RvI=
Date: Tue, 03 Sep 2024 21:17:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-numa_distance-and-related-code-from-x86-to-numa_memblks.patch removed from -mm tree
Message-Id: <20240904041721.53999C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move numa_distance and related code from x86 to numa_memblks
has been removed from the -mm tree.  Its filename was
     mm-move-numa_distance-and-related-code-from-x86-to-numa_memblks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm: move numa_distance and related code from x86 to numa_memblks
Date: Wed, 7 Aug 2024 09:41:02 +0300

Move code dealing with numa_distance array from arch/x86 to
mm/numa_memblks.c

This code will be later reused by arch_numa.

No functional changes.

Link: https://lkml.kernel.org/r/20240807064110.1003856-19-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Zi Yan <ziy@nvidia.com> # for x86_64 and arm64
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> [arm64 + CXL via QEMU]
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Rob Herring (Arm) <robh@kernel.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/numa.h  |    2 
 arch/x86/mm/numa.c           |  104 ---------------------------------
 arch/x86/mm/numa_internal.h  |    2 
 include/linux/numa_memblks.h |    4 +
 mm/numa_memblks.c            |  104 +++++++++++++++++++++++++++++++++
 5 files changed, 108 insertions(+), 108 deletions(-)

--- a/arch/x86/include/asm/numa.h~mm-move-numa_distance-and-related-code-from-x86-to-numa_memblks
+++ a/arch/x86/include/asm/numa.h
@@ -23,8 +23,6 @@ extern int numa_off;
 extern s16 __apicid_to_node[MAX_LOCAL_APIC];
 extern nodemask_t numa_nodes_parsed __initdata;
 
-extern void __init numa_set_distance(int from, int to, int distance);
-
 static inline void set_apicid_to_node(int apicid, s16 node)
 {
 	__apicid_to_node[apicid] = node;
--- a/arch/x86/mm/numa.c~mm-move-numa_distance-and-related-code-from-x86-to-numa_memblks
+++ a/arch/x86/mm/numa.c
@@ -24,9 +24,6 @@
 
 int numa_off;
 
-static int numa_distance_cnt;
-static u8 *numa_distance;
-
 static __init int numa_setup(char *opt)
 {
 	if (!opt)
@@ -118,107 +115,6 @@ void __init setup_node_to_cpumask_map(vo
 	pr_debug("Node to cpumask map for %u nodes\n", nr_node_ids);
 }
 
-/**
- * numa_reset_distance - Reset NUMA distance table
- *
- * The current table is freed.  The next numa_set_distance() call will
- * create a new one.
- */
-void __init numa_reset_distance(void)
-{
-	size_t size = numa_distance_cnt * numa_distance_cnt * sizeof(numa_distance[0]);
-
-	/* numa_distance could be 1LU marking allocation failure, test cnt */
-	if (numa_distance_cnt)
-		memblock_free(numa_distance, size);
-	numa_distance_cnt = 0;
-	numa_distance = NULL;	/* enable table creation */
-}
-
-static int __init numa_alloc_distance(void)
-{
-	nodemask_t nodes_parsed;
-	size_t size;
-	int i, j, cnt = 0;
-
-	/* size the new table and allocate it */
-	nodes_parsed = numa_nodes_parsed;
-	numa_nodemask_from_meminfo(&nodes_parsed, &numa_meminfo);
-
-	for_each_node_mask(i, nodes_parsed)
-		cnt = i;
-	cnt++;
-	size = cnt * cnt * sizeof(numa_distance[0]);
-
-	numa_distance = memblock_alloc(size, PAGE_SIZE);
-	if (!numa_distance) {
-		pr_warn("Warning: can't allocate distance table!\n");
-		/* don't retry until explicitly reset */
-		numa_distance = (void *)1LU;
-		return -ENOMEM;
-	}
-
-	numa_distance_cnt = cnt;
-
-	/* fill with the default distances */
-	for (i = 0; i < cnt; i++)
-		for (j = 0; j < cnt; j++)
-			numa_distance[i * cnt + j] = i == j ?
-				LOCAL_DISTANCE : REMOTE_DISTANCE;
-	printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
-
-	return 0;
-}
-
-/**
- * numa_set_distance - Set NUMA distance from one NUMA to another
- * @from: the 'from' node to set distance
- * @to: the 'to'  node to set distance
- * @distance: NUMA distance
- *
- * Set the distance from node @from to @to to @distance.  If distance table
- * doesn't exist, one which is large enough to accommodate all the currently
- * known nodes will be created.
- *
- * If such table cannot be allocated, a warning is printed and further
- * calls are ignored until the distance table is reset with
- * numa_reset_distance().
- *
- * If @from or @to is higher than the highest known node or lower than zero
- * at the time of table creation or @distance doesn't make sense, the call
- * is ignored.
- * This is to allow simplification of specific NUMA config implementations.
- */
-void __init numa_set_distance(int from, int to, int distance)
-{
-	if (!numa_distance && numa_alloc_distance() < 0)
-		return;
-
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt ||
-			from < 0 || to < 0) {
-		pr_warn_once("Warning: node ids are out of bound, from=%d to=%d distance=%d\n",
-			     from, to, distance);
-		return;
-	}
-
-	if ((u8)distance != distance ||
-	    (from == to && distance != LOCAL_DISTANCE)) {
-		pr_warn_once("Warning: invalid distance parameter, from=%d to=%d distance=%d\n",
-			     from, to, distance);
-		return;
-	}
-
-	numa_distance[from * numa_distance_cnt + to] = distance;
-}
-
-int __node_distance(int from, int to)
-{
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
-		return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
-	return numa_distance[from * numa_distance_cnt + to];
-}
-EXPORT_SYMBOL(__node_distance);
-
 static int __init numa_register_memblks(struct numa_meminfo *mi)
 {
 	int nid, err;
--- a/arch/x86/mm/numa_internal.h~mm-move-numa_distance-and-related-code-from-x86-to-numa_memblks
+++ a/arch/x86/mm/numa_internal.h
@@ -5,8 +5,6 @@
 #include <linux/types.h>
 #include <asm/numa.h>
 
-void __init numa_reset_distance(void);
-
 void __init x86_numa_init(void);
 
 struct numa_meminfo;
--- a/include/linux/numa_memblks.h~mm-move-numa_distance-and-related-code-from-x86-to-numa_memblks
+++ a/include/linux/numa_memblks.h
@@ -7,6 +7,10 @@
 
 #define NR_NODE_MEMBLKS		(MAX_NUMNODES * 2)
 
+extern int numa_distance_cnt;
+void __init numa_set_distance(int from, int to, int distance);
+void __init numa_reset_distance(void);
+
 struct numa_memblk {
 	u64			start;
 	u64			end;
--- a/mm/numa_memblks.c~mm-move-numa_distance-and-related-code-from-x86-to-numa_memblks
+++ a/mm/numa_memblks.c
@@ -7,11 +7,115 @@
 #include <linux/numa.h>
 #include <linux/numa_memblks.h>
 
+int numa_distance_cnt;
+static u8 *numa_distance;
+
 nodemask_t numa_nodes_parsed __initdata;
 
 struct numa_meminfo numa_meminfo __initdata_or_meminfo;
 struct numa_meminfo numa_reserved_meminfo __initdata_or_meminfo;
 
+/**
+ * numa_reset_distance - Reset NUMA distance table
+ *
+ * The current table is freed.  The next numa_set_distance() call will
+ * create a new one.
+ */
+void __init numa_reset_distance(void)
+{
+	size_t size = numa_distance_cnt * numa_distance_cnt * sizeof(numa_distance[0]);
+
+	/* numa_distance could be 1LU marking allocation failure, test cnt */
+	if (numa_distance_cnt)
+		memblock_free(numa_distance, size);
+	numa_distance_cnt = 0;
+	numa_distance = NULL;	/* enable table creation */
+}
+
+static int __init numa_alloc_distance(void)
+{
+	nodemask_t nodes_parsed;
+	size_t size;
+	int i, j, cnt = 0;
+
+	/* size the new table and allocate it */
+	nodes_parsed = numa_nodes_parsed;
+	numa_nodemask_from_meminfo(&nodes_parsed, &numa_meminfo);
+
+	for_each_node_mask(i, nodes_parsed)
+		cnt = i;
+	cnt++;
+	size = cnt * cnt * sizeof(numa_distance[0]);
+
+	numa_distance = memblock_alloc(size, PAGE_SIZE);
+	if (!numa_distance) {
+		pr_warn("Warning: can't allocate distance table!\n");
+		/* don't retry until explicitly reset */
+		numa_distance = (void *)1LU;
+		return -ENOMEM;
+	}
+
+	numa_distance_cnt = cnt;
+
+	/* fill with the default distances */
+	for (i = 0; i < cnt; i++)
+		for (j = 0; j < cnt; j++)
+			numa_distance[i * cnt + j] = i == j ?
+				LOCAL_DISTANCE : REMOTE_DISTANCE;
+	printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
+
+	return 0;
+}
+
+/**
+ * numa_set_distance - Set NUMA distance from one NUMA to another
+ * @from: the 'from' node to set distance
+ * @to: the 'to'  node to set distance
+ * @distance: NUMA distance
+ *
+ * Set the distance from node @from to @to to @distance.  If distance table
+ * doesn't exist, one which is large enough to accommodate all the currently
+ * known nodes will be created.
+ *
+ * If such table cannot be allocated, a warning is printed and further
+ * calls are ignored until the distance table is reset with
+ * numa_reset_distance().
+ *
+ * If @from or @to is higher than the highest known node or lower than zero
+ * at the time of table creation or @distance doesn't make sense, the call
+ * is ignored.
+ * This is to allow simplification of specific NUMA config implementations.
+ */
+void __init numa_set_distance(int from, int to, int distance)
+{
+	if (!numa_distance && numa_alloc_distance() < 0)
+		return;
+
+	if (from >= numa_distance_cnt || to >= numa_distance_cnt ||
+			from < 0 || to < 0) {
+		pr_warn_once("Warning: node ids are out of bound, from=%d to=%d distance=%d\n",
+			     from, to, distance);
+		return;
+	}
+
+	if ((u8)distance != distance ||
+	    (from == to && distance != LOCAL_DISTANCE)) {
+		pr_warn_once("Warning: invalid distance parameter, from=%d to=%d distance=%d\n",
+			     from, to, distance);
+		return;
+	}
+
+	numa_distance[from * numa_distance_cnt + to] = distance;
+}
+
+int __node_distance(int from, int to)
+{
+	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
+		return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
+	return numa_distance[from * numa_distance_cnt + to];
+}
+EXPORT_SYMBOL(__node_distance);
+
 static int __init numa_add_memblk_to(int nid, u64 start, u64 end,
 				     struct numa_meminfo *mi)
 {
_

Patches currently in -mm which might be from rppt@kernel.org are


