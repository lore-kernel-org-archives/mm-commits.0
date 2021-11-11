Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3E1C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABFB7610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhKKCuK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:50:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234404AbhKKCuJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:50:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDFC761108;
        Thu, 11 Nov 2021 02:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598841;
        bh=MwZReuNtuU+g4uJnMohPGdWY9KlaTJtoKrnIVHmoWQ8=;
        h=Date:From:To:Subject:From;
        b=KMUNVnnWBF82hhUTayQukVhPNoZGlsEEGB/kISQ1wH0utMLF52zkx5ARbB7f6k7DS
         UFDGMP3Hd+LiC4s7lchZrx8hSHY5QDJTyTT0C0WLRRzIKKu9tnFWSZ/Cq6Eqocw37l
         wfnkiIy+WE9ymsBdgF/ZNHCUvVn3qPqMsBpeS+LU=
Date:   Wed, 10 Nov 2021 18:47:20 -0800
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, benh@kernel.crashing.org, bp@alien8.de,
        corbet@lwn.net, dave.hansen@linux.intel.com, david@redhat.com,
        gregkh@linuxfoundation.org, hpa@zytor.com, jasowang@redhat.com,
        luto@kernel.org, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, mst@redhat.com,
        osalvador@suse.de, paulus@samba.org, peterz@infradead.org,
        rafael@kernel.org, rppt@kernel.org, skhan@linuxfoundation.org,
        tglx@linutronix.de
Subject:  [merged]
 mm-memory_hotplug-remove-config_memory_hotplug_sparse.patch removed from
 -mm tree
Message-ID: <20211111024720.wEYx8h4l0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: remove CONFIG_MEMORY_HOTPLUG_SPARSE
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-remove-config_memory_hotplug_sparse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: remove CONFIG_MEMORY_HOTPLUG_SPARSE

CONFIG_MEMORY_HOTPLUG depends on CONFIG_SPARSEMEM, so there is no need for
CONFIG_MEMORY_HOTPLUG_SPARSE anymore; adjust all instances to use
CONFIG_MEMORY_HOTPLUG and remove CONFIG_MEMORY_HOTPLUG_SPARSE.

Link: https://lkml.kernel.org/r/20210929143600.49379-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>	[kselftest]
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Alex Shi <alexs@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/machdep.h            |    2 -
 arch/powerpc/kernel/setup_64.c                |    2 -
 arch/powerpc/platforms/powernv/setup.c        |    4 +-
 arch/powerpc/platforms/pseries/setup.c        |    2 -
 drivers/base/Makefile                         |    2 -
 drivers/base/node.c                           |    9 ++----
 drivers/virtio/Kconfig                        |    2 -
 include/linux/memory.h                        |   24 ++++++----------
 include/linux/node.h                          |    4 +-
 lib/Kconfig.debug                             |    2 -
 mm/Kconfig                                    |    4 --
 mm/memory_hotplug.c                           |    2 -
 tools/testing/selftests/memory-hotplug/config |    1 
 13 files changed, 24 insertions(+), 36 deletions(-)

--- a/arch/powerpc/include/asm/machdep.h~mm-memory_hotplug-remove-config_memory_hotplug_sparse
+++ a/arch/powerpc/include/asm/machdep.h
@@ -32,7 +32,7 @@ struct machdep_calls {
 	void		(*iommu_save)(void);
 	void		(*iommu_restore)(void);
 #endif
-#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
+#ifdef CONFIG_MEMORY_HOTPLUG
 	unsigned long	(*memory_block_size)(void);
 #endif
 #endif /* CONFIG_PPC64 */
--- a/arch/powerpc/kernel/setup_64.c~mm-memory_hotplug-remove-config_memory_hotplug_sparse
+++ a/arch/powerpc/kernel/setup_64.c
@@ -912,7 +912,7 @@ void __init setup_per_cpu_areas(void)
 }
 #endif
 
-#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
+#ifdef CONFIG_MEMORY_HOTPLUG
 unsigned long memory_block_size_bytes(void)
 {
 	if (ppc_md.memory_block_size)
--- a/arch/powerpc/platforms/powernv/setup.c~mm-memory_hotplug-remove-config_memory_hotplug_sparse
+++ a/arch/powerpc/platforms/powernv/setup.c
@@ -440,7 +440,7 @@ static void pnv_kexec_cpu_down(int crash
 }
 #endif /* CONFIG_KEXEC_CORE */
 
-#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
+#ifdef CONFIG_MEMORY_HOTPLUG
 static unsigned long pnv_memory_block_size(void)
 {
 	/*
@@ -553,7 +553,7 @@ define_machine(powernv) {
 #ifdef CONFIG_KEXEC_CORE
 	.kexec_cpu_down		= pnv_kexec_cpu_down,
 #endif
-#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
+#ifdef CONFIG_MEMORY_HOTPLUG
 	.memory_block_size	= pnv_memory_block_size,
 #endif
 };
--- a/arch/powerpc/platforms/pseries/setup.c~mm-memory_hotplug-remove-config_memory_hotplug_sparse
+++ a/arch/powerpc/platforms/pseries/setup.c
@@ -1089,7 +1089,7 @@ define_machine(pseries) {
 	.machine_kexec          = pSeries_machine_kexec,
 	.kexec_cpu_down         = pseries_kexec_cpu_down,
 #endif
-#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
+#ifdef CONFIG_MEMORY_HOTPLUG
 	.memory_block_size	= pseries_memory_block_size,
 #endif
 };
--- a/drivers/base/Makefile~mm-memory_hotplug-remove-config_memory_hotplug_sparse
+++ a/drivers/base/Makefile
@@ -13,7 +13,7 @@ obj-y			+= power/
 obj-$(CONFIG_ISA_BUS_API)	+= isa.o
 obj-y				+= firmware_loader/
 obj-$(CONFIG_NUMA)	+= node.o
-obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
+obj-$(CONFIG_MEMORY_HOTPLUG) += memory.o
 ifeq ($(CONFIG_SYSFS),y)
 obj-$(CONFIG_MODULES)	+= module.o
 endif
--- a/drivers/base/node.c~mm-memory_hotplug-remove-config_memory_hotplug_sparse
+++ a/drivers/base/node.c
@@ -629,7 +629,7 @@ static void node_device_release(struct d
 {
 	struct node *node = to_node(dev);
 
-#if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_HUGETLBFS)
+#if defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_HUGETLBFS)
 	/*
 	 * We schedule the work only when a memory section is
 	 * onlined/offlined on this node. When we come here,
@@ -782,7 +782,7 @@ int unregister_cpu_under_node(unsigned i
 	return 0;
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
+#ifdef CONFIG_MEMORY_HOTPLUG
 static int __ref get_nid_for_pfn(unsigned long pfn)
 {
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
@@ -958,10 +958,9 @@ static int node_memory_callback(struct n
 	return NOTIFY_OK;
 }
 #endif	/* CONFIG_HUGETLBFS */
-#endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
+#endif /* CONFIG_MEMORY_HOTPLUG */
 
-#if !defined(CONFIG_MEMORY_HOTPLUG_SPARSE) || \
-    !defined(CONFIG_HUGETLBFS)
+#if !defined(CONFIG_MEMORY_HOTPLUG) || !defined(CONFIG_HUGETLBFS)
 static inline int node_memory_callback(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
--- a/drivers/virtio/Kconfig~mm-memory_hotplug-remove-config_memory_hotplug_sparse
+++ a/drivers/virtio/Kconfig
@@ -98,7 +98,7 @@ config VIRTIO_MEM
 	default m
 	depends on X86_64
 	depends on VIRTIO
-	depends on MEMORY_HOTPLUG_SPARSE
+	depends on MEMORY_HOTPLUG
 	depends on MEMORY_HOTREMOVE
 	depends on CONTIG_ALLOC
 	help
--- a/include/linux/memory.h~mm-memory_hotplug-remove-config_memory_hotplug_sparse
+++ a/include/linux/memory.h
@@ -110,7 +110,7 @@ struct mem_section;
 #define SLAB_CALLBACK_PRI       1
 #define IPC_CALLBACK_PRI        10
 
-#ifndef CONFIG_MEMORY_HOTPLUG_SPARSE
+#ifndef CONFIG_MEMORY_HOTPLUG
 static inline void memory_dev_init(void)
 {
 	return;
@@ -126,7 +126,14 @@ static inline int memory_notify(unsigned
 {
 	return 0;
 }
-#else
+static inline int hotplug_memory_notifier(notifier_fn_t fn, int pri)
+{
+	return 0;
+}
+/* These aren't inline functions due to a GCC bug. */
+#define register_hotmemory_notifier(nb)    ({ (void)(nb); 0; })
+#define unregister_hotmemory_notifier(nb)  ({ (void)(nb); })
+#else /* CONFIG_MEMORY_HOTPLUG */
 extern int register_memory_notifier(struct notifier_block *nb);
 extern void unregister_memory_notifier(struct notifier_block *nb);
 int create_memory_block_devices(unsigned long start, unsigned long size,
@@ -148,9 +155,6 @@ struct memory_group *memory_group_find_b
 typedef int (*walk_memory_groups_func_t)(struct memory_group *, void *);
 int walk_dynamic_memory_groups(int nid, walk_memory_groups_func_t func,
 			       struct memory_group *excluded, void *arg);
-#endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
-
-#ifdef CONFIG_MEMORY_HOTPLUG
 #define hotplug_memory_notifier(fn, pri) ({		\
 	static __meminitdata struct notifier_block fn##_mem_nb =\
 		{ .notifier_call = fn, .priority = pri };\
@@ -158,15 +162,7 @@ int walk_dynamic_memory_groups(int nid,
 })
 #define register_hotmemory_notifier(nb)		register_memory_notifier(nb)
 #define unregister_hotmemory_notifier(nb) 	unregister_memory_notifier(nb)
-#else
-static inline int hotplug_memory_notifier(notifier_fn_t fn, int pri)
-{
-	return 0;
-}
-/* These aren't inline functions due to a GCC bug. */
-#define register_hotmemory_notifier(nb)    ({ (void)(nb); 0; })
-#define unregister_hotmemory_notifier(nb)  ({ (void)(nb); })
-#endif
+#endif	/* CONFIG_MEMORY_HOTPLUG */
 
 /*
  * Kernel text modification mutex, used for code patching. Users of this lock
--- a/include/linux/node.h~mm-memory_hotplug-remove-config_memory_hotplug_sparse
+++ a/include/linux/node.h
@@ -85,7 +85,7 @@ struct node {
 	struct device	dev;
 	struct list_head access_list;
 
-#if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_HUGETLBFS)
+#if defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_HUGETLBFS)
 	struct work_struct	node_work;
 #endif
 #ifdef CONFIG_HMEM_REPORTING
@@ -98,7 +98,7 @@ struct memory_block;
 extern struct node *node_devices[];
 typedef  void (*node_registration_func_t)(struct node *);
 
-#if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_NUMA)
+#if defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_NUMA)
 void link_mem_sections(int nid, unsigned long start_pfn,
 		       unsigned long end_pfn,
 		       enum meminit_context context);
--- a/lib/Kconfig.debug~mm-memory_hotplug-remove-config_memory_hotplug_sparse
+++ a/lib/Kconfig.debug
@@ -877,7 +877,7 @@ config DEBUG_MEMORY_INIT
 
 config MEMORY_NOTIFIER_ERROR_INJECT
 	tristate "Memory hotplug notifier error injection module"
-	depends on MEMORY_HOTPLUG_SPARSE && NOTIFIER_ERROR_INJECTION
+	depends on MEMORY_HOTPLUG && NOTIFIER_ERROR_INJECTION
 	help
 	  This option provides the ability to inject artificial errors to
 	  memory hotplug notifier chain callbacks.  It is controlled through
--- a/mm/Kconfig~mm-memory_hotplug-remove-config_memory_hotplug_sparse
+++ a/mm/Kconfig
@@ -128,10 +128,6 @@ config MEMORY_HOTPLUG
 	depends on 64BIT || BROKEN
 	select NUMA_KEEP_MEMINFO if NUMA
 
-config MEMORY_HOTPLUG_SPARSE
-	def_bool y
-	depends on SPARSEMEM && MEMORY_HOTPLUG
-
 config MEMORY_HOTPLUG_DEFAULT_ONLINE
 	bool "Online the newly added memory blocks by default"
 	depends on MEMORY_HOTPLUG
--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-config_memory_hotplug_sparse
+++ a/mm/memory_hotplug.c
@@ -220,7 +220,6 @@ static void release_memory_resource(stru
 	kfree(res);
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 static int check_pfn_span(unsigned long pfn, unsigned long nr_pages,
 		const char *reason)
 {
@@ -1163,7 +1162,6 @@ failed_addition:
 	mem_hotplug_done();
 	return ret;
 }
-#endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
 static void reset_node_present_pages(pg_data_t *pgdat)
 {
--- a/tools/testing/selftests/memory-hotplug/config~mm-memory_hotplug-remove-config_memory_hotplug_sparse
+++ a/tools/testing/selftests/memory-hotplug/config
@@ -1,5 +1,4 @@
 CONFIG_MEMORY_HOTPLUG=y
-CONFIG_MEMORY_HOTPLUG_SPARSE=y
 CONFIG_NOTIFIER_ERROR_INJECTION=y
 CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
 CONFIG_MEMORY_HOTREMOVE=y
_

Patches currently in -mm which might be from david@redhat.com are


