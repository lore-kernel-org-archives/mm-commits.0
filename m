Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7C213AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744946; cv=none; b=jvo1lof17zBFXoFCTHmGWkSGdCmIE17Q7WHMrkV/yhPvlgotgn27CLh6LKg0HoTW97U0bomV/XMxJlhewIek6QE7gyKoS2QusGLmnruFYyIg8G/VRRR1U3A2Uufc9ef3PtH6aIsWZrwMctxGqrM+ygDLfLXyFQsHH2/UlVeISAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744946; c=relaxed/simple;
	bh=qfeRdcvqU/3golkTJyKNrD7dbUr2jGhK9v4mUV1k6ms=;
	h=Date:To:From:Subject:Message-Id; b=aIwDVx94Lbt6s2m/5At0QbKdbV3I576Fi2/MwkuinZRitKDF/WDjWmKXrUdKJfIsVHHlEBucLloYrHAsBF32Q3LcIUA14yWJ8BN0QMY1XctZTUwtrGRlpZkr5eViyQGiQ+dUJE1HIyKX+UEbf9aBCZE6Oe+ISZIlKpMAwnfWwIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QLJ5m62P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QLJ5m62P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D50EC4CEF7;
	Sun, 29 Mar 2026 00:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744946;
	bh=qfeRdcvqU/3golkTJyKNrD7dbUr2jGhK9v4mUV1k6ms=;
	h=Date:To:From:Subject:From;
	b=QLJ5m62PjOem+8bMc0yMx0i2OvMmJSSHJ+ShrpWUq5qH9xfoRPDJ9yR49sWCyNSeY
	 +LzslXw1bCZq1tXy1rCQJ1O41YDKq07E+TmjRzvfoy8zu5ytOvgrPQUbQ+1AZ8Ml2q
	 ocmBdpj3JXabM3N0cO+0f9EEPVSZWq2x3fd4SqVs=
Date: Sat, 28 Mar 2026 17:42:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,will@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,rakie.kim@sk.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,matthew.brost@intel.com,maddy@linux.ibm.com,ljs@kernel.org,liam.howlett@oracle.com,kernel@xen0n.name,joshua.hahnjy@gmail.com,jonathan.cameron@huawei.com,hpa@zytor.com,hca@linux.ibm.com,gourry@gourry.net,gor@linux.ibm.com,chenhuacai@kernel.org,catalin.marinas@arm.com,byungchul@sk.com,bp@alien8.de,borntraeger@linux.ibm.com,bigeasy@linutronix.de,apopple@nvidia.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-config_numa_migration-and-simplify-config_migration.patch removed from -mm tree
Message-Id: <20260329004226.2D50EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce CONFIG_NUMA_MIGRATION and simplify CONFIG_MIGRATION
has been removed from the -mm tree.  Its filename was
     mm-introduce-config_numa_migration-and-simplify-config_migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: introduce CONFIG_NUMA_MIGRATION and simplify CONFIG_MIGRATION
Date: Thu, 19 Mar 2026 09:19:41 +0100

CONFIG_MEMORY_HOTREMOVE, CONFIG_COMPACTION and CONFIG_CMA all select
CONFIG_MIGRATION, because they require it to work (users).

Only CONFIG_NUMA_BALANCING and CONFIG_BALLOON_MIGRATION depend on
CONFIG_MIGRATION.  CONFIG_BALLOON_MIGRATION is not an actual user, but an
implementation of migration support, so the dependency is correct
(CONFIG_BALLOON_MIGRATION does not make any sense without
CONFIG_MIGRATION).

However, kconfig-language.rst clearly states "In general use select only
for non-visible symbols".  So far CONFIG_MIGRATION is user-visible ... 
and the dependencies rather confusing.

The whole reason why CONFIG_MIGRATION is user-visible is because of
CONFIG_NUMA: some users might want CONFIG_NUMA but not page migration
support.

Let's clean all that up by introducing a dedicated CONFIG_NUMA_MIGRATION
config option for that purpose only.  Make CONFIG_NUMA_BALANCING that so
far depended on CONFIG_NUMA && CONFIG_MIGRATION to depend on
CONFIG_MIGRATION instead.  CONFIG_NUMA_MIGRATION will depend on
CONFIG_NUMA && CONFIG_MMU.

CONFIG_NUMA_MIGRATION is user-visible and will default to "y".  We use
that default so new configs will automatically enable it, just like it was
the case with CONFIG_MIGRATION.  The downside is that some configs that
used to have CONFIG_MIGRATION=n might get it re-enabled by
CONFIG_NUMA_MIGRATION=y, which shouldn't be a problem.

CONFIG_MIGRATION is now a non-visible config option.  Any code that select
CONFIG_MIGRATION (as before) must depend directly or indirectly on
CONFIG_MMU.

CONFIG_NUMA_MIGRATION is responsible for any NUMA migration code, which is
mempolicy migration code, memory-tiering code, and move_pages() code in
migrate.c.  CONFIG_NUMA_BALANCING uses its functionality.

Note that this implies that with CONFIG_NUMA_MIGRATION=n, move_pages()
will not be available even though CONFIG_MIGRATION=y, which is an expected
change.

In migrate.c, we can remove the CONFIG_NUMA check as both
CONFIG_NUMA_MIGRATION and CONFIG_NUMA_BALANCING depend on it.

With this change, CONFIG_MIGRATION is an internal config, all users of
migration selects CONFIG_MIGRATION, and only CONFIG_BALLOON_MIGRATION
depends on it.

Link: https://lkml.kernel.org/r/20260319-config_migration-v1-2-42270124966f@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory-tiers.h |    2 +-
 init/Kconfig                 |    2 +-
 mm/Kconfig                   |   24 ++++++++++++------------
 mm/memory-tiers.c            |   12 ++++++------
 mm/mempolicy.c               |    2 +-
 mm/migrate.c                 |    5 ++---
 6 files changed, 23 insertions(+), 24 deletions(-)

--- a/include/linux/memory-tiers.h~mm-introduce-config_numa_migration-and-simplify-config_migration
+++ a/include/linux/memory-tiers.h
@@ -52,7 +52,7 @@ int mt_perf_to_adistance(struct access_c
 struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
-#ifdef CONFIG_MIGRATION
+#ifdef CONFIG_NUMA_MIGRATION
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
 bool node_is_toptier(int node);
--- a/init/Kconfig~mm-introduce-config_numa_migration-and-simplify-config_migration
+++ a/init/Kconfig
@@ -997,7 +997,7 @@ config NUMA_BALANCING
 	bool "Memory placement aware NUMA scheduler"
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
 	depends on !ARCH_WANT_NUMA_VARIABLE_LOCALITY
-	depends on SMP && NUMA && MIGRATION && !PREEMPT_RT
+	depends on SMP && NUMA_MIGRATION && !PREEMPT_RT
 	help
 	  This option adds support for automatic NUMA aware memory/task placement.
 	  The mechanism is quite primitive and is based on migrating memory when
--- a/mm/Kconfig~mm-introduce-config_numa_migration-and-simplify-config_migration
+++ a/mm/Kconfig
@@ -627,20 +627,20 @@ config PAGE_REPORTING
 	  those pages to another entity, such as a hypervisor, so that the
 	  memory can be freed within the host for other uses.
 
-#
-# support for page migration
-#
-config MIGRATION
-	bool "Page migration"
+config NUMA_MIGRATION
+	bool "NUMA page migration"
 	default y
-	depends on (NUMA || MEMORY_HOTREMOVE || COMPACTION || CMA) && MMU
+	depends on NUMA && MMU
+	select MIGRATION
 	help
-	  Allows the migration of the physical location of pages of processes
-	  while the virtual addresses are not changed. This is useful in
-	  two situations. The first is on NUMA systems to put pages nearer
-	  to the processors accessing. The second is when allocating huge
-	  pages as migration can relocate pages to satisfy a huge page
-	  allocation instead of reclaiming.
+	  Support the migration of pages to other NUMA nodes, available to
+	  user space through interfaces like migrate_pages(), move_pages(),
+	  and mbind(). Selecting this option also enables support for page
+	  demotion for memory tiering.
+
+config MIGRATION
+	bool
+	depends on MMU
 
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
--- a/mm/memory-tiers.c~mm-introduce-config_numa_migration-and-simplify-config_migration
+++ a/mm/memory-tiers.c
@@ -69,7 +69,7 @@ bool folio_use_access_time(struct folio
 }
 #endif
 
-#ifdef CONFIG_MIGRATION
+#ifdef CONFIG_NUMA_MIGRATION
 static int top_tier_adistance;
 /*
  * node_demotion[] examples:
@@ -129,7 +129,7 @@ static int top_tier_adistance;
  *
  */
 static struct demotion_nodes *node_demotion __read_mostly;
-#endif /* CONFIG_MIGRATION */
+#endif /* CONFIG_NUMA_MIGRATION */
 
 static BLOCKING_NOTIFIER_HEAD(mt_adistance_algorithms);
 
@@ -273,7 +273,7 @@ static struct memory_tier *__node_get_me
 				     lockdep_is_held(&memory_tier_lock));
 }
 
-#ifdef CONFIG_MIGRATION
+#ifdef CONFIG_NUMA_MIGRATION
 bool node_is_toptier(int node)
 {
 	bool toptier;
@@ -519,7 +519,7 @@ static void establish_demotion_targets(v
 
 #else
 static inline void establish_demotion_targets(void) {}
-#endif /* CONFIG_MIGRATION */
+#endif /* CONFIG_NUMA_MIGRATION */
 
 static inline void __init_node_memory_type(int node, struct memory_dev_type *memtype)
 {
@@ -911,7 +911,7 @@ static int __init memory_tier_init(void)
 	if (ret)
 		panic("%s() failed to register memory tier subsystem\n", __func__);
 
-#ifdef CONFIG_MIGRATION
+#ifdef CONFIG_NUMA_MIGRATION
 	node_demotion = kzalloc_objs(struct demotion_nodes, nr_node_ids);
 	WARN_ON(!node_demotion);
 #endif
@@ -938,7 +938,7 @@ subsys_initcall(memory_tier_init);
 
 bool numa_demotion_enabled = false;
 
-#ifdef CONFIG_MIGRATION
+#ifdef CONFIG_NUMA_MIGRATION
 #ifdef CONFIG_SYSFS
 static ssize_t demotion_enabled_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
--- a/mm/mempolicy.c~mm-introduce-config_numa_migration-and-simplify-config_migration
+++ a/mm/mempolicy.c
@@ -1239,7 +1239,7 @@ static long do_get_mempolicy(int *policy
 	return err;
 }
 
-#ifdef CONFIG_MIGRATION
+#ifdef CONFIG_NUMA_MIGRATION
 static bool migrate_folio_add(struct folio *folio, struct list_head *foliolist,
 				unsigned long flags)
 {
--- a/mm/migrate.c~mm-introduce-config_numa_migration-and-simplify-config_migration
+++ a/mm/migrate.c
@@ -2222,8 +2222,7 @@ struct folio *alloc_migration_target(str
 	return __folio_alloc(gfp_mask, order, nid, mtc->nmask);
 }
 
-#ifdef CONFIG_NUMA
-
+#ifdef CONFIG_NUMA_MIGRATION
 static int store_status(int __user *status, int start, int value, int nr)
 {
 	while (nr-- > 0) {
@@ -2622,6 +2621,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
 {
 	return kernel_move_pages(pid, nr_pages, pages, nodes, status, flags);
 }
+#endif /* CONFIG_NUMA_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
 /*
@@ -2764,4 +2764,3 @@ int migrate_misplaced_folio(struct folio
 	return nr_remaining ? -EAGAIN : 0;
 }
 #endif /* CONFIG_NUMA_BALANCING */
-#endif /* CONFIG_NUMA */
_

Patches currently in -mm which might be from david@kernel.org are


