Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A2EC43217
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236797AbiCVVtQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236803AbiCVVsx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:48:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23556006F
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:47:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AE3E61663
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60AFC340F2;
        Tue, 22 Mar 2022 21:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985633;
        bh=NYdK6/dSUzC668bEuxDFIs438rTjM7GW+TuJibVSw0Y=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=O0yMAXAU6MtB8sYT0pGzfMcDX+UmbaedsHzktveIUlUxrGoB5SkjRo1qWDXaSaewv
         OX8c0iQNpVrB4PNfAjd1h2FTv0Apa9d6VXTPk8u/OpdEevqKZViod4UlIGO0wxX198
         Rg5Yzt71XU54Zf/1tWJApkBNFJsOQVBDYWKqET10=
Date:   Tue, 22 Mar 2022 14:47:13 -0700
To:     ysato@users.sourceforge.jp, will@kernel.org,
        tsbogend@alpha.franken.de, tglx@linutronix.de, rppt@kernel.org,
        rafael@kernel.org, paul.walmsley@sifive.com, paulus@samba.org,
        palmer@dabbelt.com, osalvador@suse.de, mpe@ellerman.id.au,
        mingo@redhat.com, mhocko@suse.com, matorola@gmail.com,
        hca@linux.ibm.com, gregkh@linuxfoundation.org, gor@linux.ibm.com,
        davem@davemloft.net, dave.hansen@linux.intel.com, dalias@libc.org,
        catalin.marinas@arm.com, bp@alien8.de, benh@kernel.crashing.org,
        aou@eecs.berkeley.edu, david@redhat.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 171/227] drivers/base/node: consolidate node device subsystem initialization in node_dev_init()
Message-Id: <20220322214713.B60AFC340F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/node: consolidate node device subsystem initialization in node_dev_init()

...  and call node_dev_init() after memory_dev_init() from driver_init(),
so before any of the existing arch/subsys calls.  All online nodes should
be known at that point: early during boot, arch code determines node and
zone ranges and sets the relevant nodes online; usually this happens in
setup_arch().

This is in line with memory_dev_init(), which initializes the memory
device subsystem and creates all memory block devices.

Similar to memory_dev_init(), panic() if anything goes wrong, we don't
want to continue with such basic initialization errors.

The important part is that node_dev_init() gets called after
memory_dev_init() and after cpu_dev_init(), but before any of the relevant
archs call register_cpu() to register the new cpu device under the node
device.  The latter should be the case for the current users of
topology_init().

Link: https://lkml.kernel.org/r/20220203105212.30385-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Anatoly Pugachev <matorola@gmail.com> (sparc64)
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/setup.c   |    3 ---
 arch/ia64/kernel/topology.c |   10 ----------
 arch/mips/kernel/topology.c |    5 -----
 arch/powerpc/kernel/sysfs.c |   17 -----------------
 arch/riscv/kernel/setup.c   |    3 ---
 arch/s390/kernel/numa.c     |    7 -------
 arch/sh/kernel/topology.c   |    5 -----
 arch/sparc/kernel/sysfs.c   |   12 ------------
 arch/x86/kernel/topology.c  |    5 -----
 drivers/base/init.c         |    1 +
 drivers/base/node.c         |   30 +++++++++++++++++-------------
 include/linux/node.h        |    4 ++++
 12 files changed, 22 insertions(+), 80 deletions(-)

--- a/arch/arm64/kernel/setup.c~drivers-base-node-consolidate-node-device-subsystem-initialization-in-node_dev_init
+++ a/arch/arm64/kernel/setup.c
@@ -406,9 +406,6 @@ static int __init topology_init(void)
 {
 	int i;
 
-	for_each_online_node(i)
-		register_one_node(i);
-
 	for_each_possible_cpu(i) {
 		struct cpu *cpu = &per_cpu(cpu_data.cpu, i);
 		cpu->hotpluggable = cpu_can_disable(i);
--- a/arch/ia64/kernel/topology.c~drivers-base-node-consolidate-node-device-subsystem-initialization-in-node_dev_init
+++ a/arch/ia64/kernel/topology.c
@@ -70,16 +70,6 @@ static int __init topology_init(void)
 {
 	int i, err = 0;
 
-#ifdef CONFIG_NUMA
-	/*
-	 * MCD - Do we want to register all ONLINE nodes, or all POSSIBLE nodes?
-	 */
-	for_each_online_node(i) {
-		if ((err = register_one_node(i)))
-			goto out;
-	}
-#endif
-
 	sysfs_cpus = kcalloc(NR_CPUS, sizeof(struct ia64_cpu), GFP_KERNEL);
 	if (!sysfs_cpus)
 		panic("kzalloc in topology_init failed - NR_CPUS too big?");
--- a/arch/mips/kernel/topology.c~drivers-base-node-consolidate-node-device-subsystem-initialization-in-node_dev_init
+++ a/arch/mips/kernel/topology.c
@@ -12,11 +12,6 @@ static int __init topology_init(void)
 {
 	int i, ret;
 
-#ifdef CONFIG_NUMA
-	for_each_online_node(i)
-		register_one_node(i);
-#endif /* CONFIG_NUMA */
-
 	for_each_present_cpu(i) {
 		struct cpu *c = &per_cpu(cpu_devices, i);
 
--- a/arch/powerpc/kernel/sysfs.c~drivers-base-node-consolidate-node-device-subsystem-initialization-in-node_dev_init
+++ a/arch/powerpc/kernel/sysfs.c
@@ -1110,14 +1110,6 @@ EXPORT_SYMBOL_GPL(cpu_remove_dev_attr_gr
 /* NUMA stuff */
 
 #ifdef CONFIG_NUMA
-static void __init register_nodes(void)
-{
-	int i;
-
-	for (i = 0; i < MAX_NUMNODES; i++)
-		register_one_node(i);
-}
-
 int sysfs_add_device_to_node(struct device *dev, int nid)
 {
 	struct node *node = node_devices[nid];
@@ -1132,13 +1124,6 @@ void sysfs_remove_device_from_node(struc
 	sysfs_remove_link(&node->dev.kobj, kobject_name(&dev->kobj));
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_device_from_node);
-
-#else
-static void __init register_nodes(void)
-{
-	return;
-}
-
 #endif
 
 /* Only valid if CPU is present. */
@@ -1155,8 +1140,6 @@ static int __init topology_init(void)
 {
 	int cpu, r;
 
-	register_nodes();
-
 	for_each_possible_cpu(cpu) {
 		struct cpu *c = &per_cpu(cpu_devices, cpu);
 
--- a/arch/riscv/kernel/setup.c~drivers-base-node-consolidate-node-device-subsystem-initialization-in-node_dev_init
+++ a/arch/riscv/kernel/setup.c
@@ -301,9 +301,6 @@ static int __init topology_init(void)
 {
 	int i, ret;
 
-	for_each_online_node(i)
-		register_one_node(i);
-
 	for_each_possible_cpu(i) {
 		struct cpu *cpu = &per_cpu(cpu_devices, i);
 
--- a/arch/s390/kernel/numa.c~drivers-base-node-consolidate-node-device-subsystem-initialization-in-node_dev_init
+++ a/arch/s390/kernel/numa.c
@@ -33,10 +33,3 @@ void __init numa_setup(void)
 	NODE_DATA(0)->node_spanned_pages = memblock_end_of_DRAM() >> PAGE_SHIFT;
 	NODE_DATA(0)->node_id = 0;
 }
-
-static int __init numa_init_late(void)
-{
-	register_one_node(0);
-	return 0;
-}
-arch_initcall(numa_init_late);
--- a/arch/sh/kernel/topology.c~drivers-base-node-consolidate-node-device-subsystem-initialization-in-node_dev_init
+++ a/arch/sh/kernel/topology.c
@@ -46,11 +46,6 @@ static int __init topology_init(void)
 {
 	int i, ret;
 
-#ifdef CONFIG_NUMA
-	for_each_online_node(i)
-		register_one_node(i);
-#endif
-
 	for_each_present_cpu(i) {
 		struct cpu *c = &per_cpu(cpu_devices, i);
 
--- a/arch/sparc/kernel/sysfs.c~drivers-base-node-consolidate-node-device-subsystem-initialization-in-node_dev_init
+++ a/arch/sparc/kernel/sysfs.c
@@ -244,22 +244,10 @@ static void __init check_mmu_stats(void)
 		mmu_stats_supported = 1;
 }
 
-static void register_nodes(void)
-{
-#ifdef CONFIG_NUMA
-	int i;
-
-	for (i = 0; i < MAX_NUMNODES; i++)
-		register_one_node(i);
-#endif
-}
-
 static int __init topology_init(void)
 {
 	int cpu, ret;
 
-	register_nodes();
-
 	check_mmu_stats();
 
 	for_each_possible_cpu(cpu) {
--- a/arch/x86/kernel/topology.c~drivers-base-node-consolidate-node-device-subsystem-initialization-in-node_dev_init
+++ a/arch/x86/kernel/topology.c
@@ -154,11 +154,6 @@ static int __init topology_init(void)
 {
 	int i;
 
-#ifdef CONFIG_NUMA
-	for_each_online_node(i)
-		register_one_node(i);
-#endif
-
 	for_each_present_cpu(i)
 		arch_register_cpu(i);
 
--- a/drivers/base/init.c~drivers-base-node-consolidate-node-device-subsystem-initialization-in-node_dev_init
+++ a/drivers/base/init.c
@@ -35,5 +35,6 @@ void __init driver_init(void)
 	auxiliary_bus_init();
 	cpu_dev_init();
 	memory_dev_init();
+	node_dev_init();
 	container_dev_init();
 }
--- a/drivers/base/node.c~drivers-base-node-consolidate-node-device-subsystem-initialization-in-node_dev_init
+++ a/drivers/base/node.c
@@ -1065,26 +1065,30 @@ static const struct attribute_group *cpu
 };
 
 #define NODE_CALLBACK_PRI	2	/* lower than SLAB */
-static int __init register_node_type(void)
+void __init node_dev_init(void)
 {
-	int ret;
+	static struct notifier_block node_memory_callback_nb = {
+		.notifier_call = node_memory_callback,
+		.priority = NODE_CALLBACK_PRI,
+	};
+	int ret, i;
 
  	BUILD_BUG_ON(ARRAY_SIZE(node_state_attr) != NR_NODE_STATES);
  	BUILD_BUG_ON(ARRAY_SIZE(node_state_attrs)-1 != NR_NODE_STATES);
 
 	ret = subsys_system_register(&node_subsys, cpu_root_attr_groups);
-	if (!ret) {
-		static struct notifier_block node_memory_callback_nb = {
-			.notifier_call = node_memory_callback,
-			.priority = NODE_CALLBACK_PRI,
-		};
-		register_hotmemory_notifier(&node_memory_callback_nb);
-	}
+	if (ret)
+		panic("%s() failed to register subsystem: %d\n", __func__, ret);
+
+	register_hotmemory_notifier(&node_memory_callback_nb);
 
 	/*
-	 * Note:  we're not going to unregister the node class if we fail
-	 * to register the node state class attribute files.
+	 * Create all node devices, which will properly link the node
+	 * to applicable memory block devices and already created cpu devices.
 	 */
-	return ret;
+	for_each_online_node(i) {
+		ret = register_one_node(i);
+		if (ret)
+			panic("%s() failed to add node: %d\n", __func__, ret);
+	}
 }
-postcore_initcall(register_node_type);
--- a/include/linux/node.h~drivers-base-node-consolidate-node-device-subsystem-initialization-in-node_dev_init
+++ a/include/linux/node.h
@@ -112,6 +112,7 @@ static inline void link_mem_sections(int
 
 extern void unregister_node(struct node *node);
 #ifdef CONFIG_NUMA
+extern void node_dev_init(void);
 /* Core of the node registration - only memory hotplug should use this */
 extern int __register_one_node(int nid);
 
@@ -149,6 +150,9 @@ extern void register_hugetlbfs_with_node
 					 node_registration_func_t unregister);
 #endif
 #else
+static inline void node_dev_init(void)
+{
+}
 static inline int __register_one_node(int nid)
 {
 	return 0;
_
