Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1923A6E61B
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423425; cv=none; b=GQcE+60tq1sXH09HbB0DQNKUoXh0yZHTzJMzHf9lJtdF7yj6hFo5m1A0aTt644YM1N0K1ZvuxPR4T2LMAkQT46XJUx+3wCncP4H3JWr51qyrJ/yM9BKK9kNvIz/Bu+iNWgG4UqBGw5mEWW7wzpkW6lXz9JiQPlK1yBGAL2OiAP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423425; c=relaxed/simple;
	bh=cKxp4jDjXJweJzVR8TZNcifKz3IG9Lljev0iePxpBlw=;
	h=Date:To:From:Subject:Message-Id; b=CmJpgIyxhGEGAfkcyiFYb0Lx3jLrFCx6PQrlLUIzVYSbMl6sO8hk4OSmo/Awe/X1aDZJ6xKWdUt+7MzkdQrfviBTzgDN9k1/nAjSq7Ppb6XaJrIkbuCEuB2NUhOIR0gP8W0NB9XJz4pwRkyot+eFkdH0v2uO3ph5WYuISzDUJ5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ItAIjCJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ItAIjCJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA75FC4CEC2;
	Wed,  4 Sep 2024 04:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423425;
	bh=cKxp4jDjXJweJzVR8TZNcifKz3IG9Lljev0iePxpBlw=;
	h=Date:To:From:Subject:From;
	b=ItAIjCJX1rVN7zkWIZtXmwH2S7Lws85/bFQ3wYP5T3s87c+1CcMOOOYzDy9i6jTHJ
	 yx7UBfdbHRf8dw3ueONG0kjyftfruVWtcQpruYTWZZRWV56pQj8sjXOQQNcliqIyMx
	 UH5CwnArXijsaO9Boz4QulfvwuI4JVd0G2QM+00E=
Date: Tue, 03 Sep 2024 21:17:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-drop-config_have_arch_nodedata_extension.patch removed from -mm tree
Message-Id: <20240904041704.DA75FC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: drop CONFIG_HAVE_ARCH_NODEDATA_EXTENSION
has been removed from the -mm tree.  Its filename was
     mm-drop-config_have_arch_nodedata_extension.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm: drop CONFIG_HAVE_ARCH_NODEDATA_EXTENSION
Date: Wed, 7 Aug 2024 09:40:52 +0300

There are no users of HAVE_ARCH_NODEDATA_EXTENSION left, so
arch_alloc_nodedata() and arch_refresh_nodedata() are not needed anymore.

Replace the call to arch_alloc_nodedata() in free_area_init() with a new
helper alloc_offline_node_data(), remove arch_refresh_nodedata() and
cleanup include/linux/memory_hotplug.h from the associated ifdefery.

Link: https://lkml.kernel.org/r/20240807064110.1003856-9-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Zi Yan <ziy@nvidia.com> # for x86_64 and arm64
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
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

 include/linux/memory_hotplug.h |   48 -------------------------------
 include/linux/numa.h           |    4 ++
 mm/mm_init.c                   |   10 +-----
 mm/numa.c                      |   12 +++++++
 4 files changed, 18 insertions(+), 56 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-drop-config_have_arch_nodedata_extension
+++ a/include/linux/memory_hotplug.h
@@ -16,54 +16,6 @@ struct resource;
 struct vmem_altmap;
 struct dev_pagemap;
 
-#ifdef CONFIG_HAVE_ARCH_NODEDATA_EXTENSION
-/*
- * For supporting node-hotadd, we have to allocate a new pgdat.
- *
- * If an arch has generic style NODE_DATA(),
- * node_data[nid] = kzalloc() works well. But it depends on the architecture.
- *
- * In general, generic_alloc_nodedata() is used.
- *
- */
-extern pg_data_t *arch_alloc_nodedata(int nid);
-extern void arch_refresh_nodedata(int nid, pg_data_t *pgdat);
-
-#else /* CONFIG_HAVE_ARCH_NODEDATA_EXTENSION */
-
-#define arch_alloc_nodedata(nid)	generic_alloc_nodedata(nid)
-
-#ifdef CONFIG_NUMA
-/*
- * XXX: node aware allocation can't work well to get new node's memory at this time.
- *	Because, pgdat for the new node is not allocated/initialized yet itself.
- *	To use new node's memory, more consideration will be necessary.
- */
-#define generic_alloc_nodedata(nid)				\
-({								\
-	memblock_alloc(sizeof(*pgdat), SMP_CACHE_BYTES);	\
-})
-
-extern pg_data_t *node_data[];
-static inline void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
-{
-	node_data[nid] = pgdat;
-}
-
-#else /* !CONFIG_NUMA */
-
-/* never called */
-static inline pg_data_t *generic_alloc_nodedata(int nid)
-{
-	BUG();
-	return NULL;
-}
-static inline void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
-{
-}
-#endif /* CONFIG_NUMA */
-#endif /* CONFIG_HAVE_ARCH_NODEDATA_EXTENSION */
-
 #ifdef CONFIG_MEMORY_HOTPLUG
 struct page *pfn_to_online_page(unsigned long pfn);
 
--- a/include/linux/numa.h~mm-drop-config_have_arch_nodedata_extension
+++ a/include/linux/numa.h
@@ -33,6 +33,8 @@ static inline bool numa_valid_node(int n
 extern struct pglist_data *node_data[];
 #define NODE_DATA(nid)	(node_data[nid])
 
+void __init alloc_offline_node_data(int nid);
+
 /* Generic implementation available */
 int numa_nearest_node(int node, unsigned int state);
 
@@ -60,6 +62,8 @@ static inline int phys_to_target_node(u6
 {
 	return 0;
 }
+
+static inline void alloc_offline_node_data(int nid) {}
 #endif
 
 #define numa_map_to_online_node(node) numa_nearest_node(node, N_ONLINE)
--- a/mm/mm_init.c~mm-drop-config_have_arch_nodedata_extension
+++ a/mm/mm_init.c
@@ -1835,14 +1835,8 @@ void __init free_area_init(unsigned long
 	for_each_node(nid) {
 		pg_data_t *pgdat;
 
-		if (!node_online(nid)) {
-			/* Allocator not initialized yet */
-			pgdat = arch_alloc_nodedata(nid);
-			if (!pgdat)
-				panic("Cannot allocate %zuB for node %d.\n",
-				       sizeof(*pgdat), nid);
-			arch_refresh_nodedata(nid, pgdat);
-		}
+		if (!node_online(nid))
+			alloc_offline_node_data(nid);
 
 		pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);
--- a/mm/numa.c~mm-drop-config_have_arch_nodedata_extension
+++ a/mm/numa.c
@@ -6,6 +6,18 @@
 struct pglist_data *node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(node_data);
 
+void __init alloc_offline_node_data(int nid)
+{
+	pg_data_t *pgdat;
+
+	pgdat = memblock_alloc(sizeof(*pgdat), SMP_CACHE_BYTES);
+	if (!pgdat)
+		panic("Cannot allocate %zuB for node %d.\n",
+		      sizeof(*pgdat), nid);
+
+	node_data[nid] = pgdat;
+}
+
 /* Stub functions: */
 
 #ifndef memory_add_physaddr_to_nid
_

Patches currently in -mm which might be from rppt@kernel.org are


