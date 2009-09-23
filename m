From: akpm@linux-foundation.org
Subject: [merged] walk-system-ram-range.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:57:03 -0700
Message-ID: <200909231957.n8NJv3LO006154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753929AbZIWUEx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:04:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, benh@kernel.crashing.org, ralf@linux-mips.org, rientjes@google.com, rolandd@cisco.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     walk system ram range
has been removed from the -mm tree.  Its filename was
     walk-system-ram-range.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: walk system ram range
=46rom: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Originally, walk_memory_resource() was introduced to traverse all memor=
y
of "System RAM" for detecting memory hotplug/unplug range.  For doing s=
o,
flags of IORESOUCE_MEM|IORESOURCE_BUSY was used and this was enough for
memory hotplug.

But for using other purpose, /proc/kcore, this may includes some firmwa=
re
area marked as IORESOURCE_BUSY | IORESOUCE_MEM.  This patch makes the
check strict to find out busy "System RAM".

Note: PPC64 keeps their own walk_memory_resouce(), which walk through
ppc64's lmb informaton.  Because old kclist_add() is called per lmb, th=
is
patch makes no difference in behavior, finally.

And this patch removes CONFIG_MEMORY_HOTPLUG check from this function.=20
Because pfn_valid() just show "there is memmap or not* and cannot be us=
ed
for "there is physical memory or not", this function is useful in gener=
ic
to scan physical memory range.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Am=E9rico Wang <xiyou.wangcong@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c                  |    6 +++---
 drivers/infiniband/hw/ehca/ehca_mrmw.c |    2 +-
 drivers/net/ehea/ehea_qmr.c            |    2 +-
 include/linux/ioport.h                 |    4 ++++
 include/linux/memory_hotplug.h         |    8 --------
 kernel/resource.c                      |   23 ++++++++++++++++-------
 mm/memory_hotplug.c                    |    6 +++---
 7 files changed, 28 insertions(+), 23 deletions(-)

diff -puN arch/powerpc/mm/mem.c~walk-system-ram-range arch/powerpc/mm/m=
em.c
--- a/arch/powerpc/mm/mem.c~walk-system-ram-range
+++ a/arch/powerpc/mm/mem.c
@@ -143,8 +143,8 @@ int arch_add_memory(int nid, u64 start,=20
  * memory regions, find holes and callback for contiguous regions.
  */
 int
-walk_memory_resource(unsigned long start_pfn, unsigned long nr_pages, =
void *arg,
-			int (*func)(unsigned long, unsigned long, void *))
+walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
+		void *arg, int (*func)(unsigned long, unsigned long, void *))
 {
 	struct lmb_property res;
 	unsigned long pfn, len;
@@ -166,7 +166,7 @@ walk_memory_resource(unsigned long start
 	}
 	return ret;
 }
-EXPORT_SYMBOL_GPL(walk_memory_resource);
+EXPORT_SYMBOL_GPL(walk_system_ram_range);
=20
 /*
  * Initialize the bootmem system and give it all the memory we
diff -puN drivers/infiniband/hw/ehca/ehca_mrmw.c~walk-system-ram-range =
drivers/infiniband/hw/ehca/ehca_mrmw.c
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c~walk-system-ram-range
+++ a/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -2463,7 +2463,7 @@ int ehca_create_busmap(void)
 	int ret;
=20
 	ehca_mr_len =3D 0;
-	ret =3D walk_memory_resource(0, 1ULL << MAX_PHYSMEM_BITS, NULL,
+	ret =3D walk_system_ram_range(0, 1ULL << MAX_PHYSMEM_BITS, NULL,
 				   ehca_create_busmap_callback);
 	return ret;
 }
diff -puN drivers/net/ehea/ehea_qmr.c~walk-system-ram-range drivers/net=
/ehea/ehea_qmr.c
--- a/drivers/net/ehea/ehea_qmr.c~walk-system-ram-range
+++ a/drivers/net/ehea/ehea_qmr.c
@@ -751,7 +751,7 @@ int ehea_create_busmap(void)
=20
 	mutex_lock(&ehea_busmap_mutex);
 	ehea_mr_len =3D 0;
-	ret =3D walk_memory_resource(0, 1ULL << MAX_PHYSMEM_BITS, NULL,
+	ret =3D walk_system_ram_range(0, 1ULL << MAX_PHYSMEM_BITS, NULL,
 				   ehea_create_busmap_callback);
 	mutex_unlock(&ehea_busmap_mutex);
 	return ret;
diff -puN include/linux/ioport.h~walk-system-ram-range include/linux/io=
port.h
--- a/include/linux/ioport.h~walk-system-ram-range
+++ a/include/linux/ioport.h
@@ -184,5 +184,9 @@ extern void __devm_release_region(struct
 extern int iomem_map_sanity_check(resource_size_t addr, unsigned long =
size);
 extern int iomem_is_exclusive(u64 addr);
=20
+extern int
+walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
+		void *arg, int (*func)(unsigned long, unsigned long, void *));
+
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff -puN include/linux/memory_hotplug.h~walk-system-ram-range include/=
linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~walk-system-ram-range
+++ a/include/linux/memory_hotplug.h
@@ -191,14 +191,6 @@ static inline void register_page_bootmem
=20
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
=20
-/*
- * Walk through all memory which is registered as resource.
- * arg is (start_pfn, nr_pages, private_arg_pointer)
- */
-extern int walk_memory_resource(unsigned long start_pfn,
-			unsigned long nr_pages, void *arg,
-			int (*func)(unsigned long, unsigned long, void *));
-
 #ifdef CONFIG_MEMORY_HOTREMOVE
=20
 extern int is_mem_section_removable(unsigned long pfn, unsigned long n=
r_pages);
diff -puN kernel/resource.c~walk-system-ram-range kernel/resource.c
--- a/kernel/resource.c~walk-system-ram-range
+++ a/kernel/resource.c
@@ -223,13 +223,13 @@ int release_resource(struct resource *ol
=20
 EXPORT_SYMBOL(release_resource);
=20
-#if defined(CONFIG_MEMORY_HOTPLUG) && !defined(CONFIG_ARCH_HAS_WALK_ME=
MORY)
+#if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
 /*
  * Finds the lowest memory reosurce exists within [res->start.res->end=
)
- * the caller must specify res->start, res->end, res->flags.
+ * the caller must specify res->start, res->end, res->flags and "name"=
=2E
  * If found, returns 0, res is overwritten, if not found, returns -1.
  */
-static int find_next_system_ram(struct resource *res)
+static int find_next_system_ram(struct resource *res, char *name)
 {
 	resource_size_t start, end;
 	struct resource *p;
@@ -245,6 +245,8 @@ static int find_next_system_ram(struct r
 		/* system ram is just marked as IORESOURCE_MEM */
 		if (p->flags !=3D res->flags)
 			continue;
+		if (name && strcmp(p->name, name))
+			continue;
 		if (p->start > end) {
 			p =3D NULL;
 			break;
@@ -262,19 +264,26 @@ static int find_next_system_ram(struct r
 		res->end =3D p->end;
 	return 0;
 }
-int
-walk_memory_resource(unsigned long start_pfn, unsigned long nr_pages, =
void *arg,
-			int (*func)(unsigned long, unsigned long, void *))
+
+/*
+ * This function calls callback against all memory range of "System RA=
M"
+ * which are marked as IORESOURCE_MEM and IORESOUCE_BUSY.
+ * Now, this function is only for "System RAM".
+ */
+int walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pa=
ges,
+		void *arg, int (*func)(unsigned long, unsigned long, void *))
 {
 	struct resource res;
 	unsigned long pfn, len;
 	u64 orig_end;
 	int ret =3D -1;
+
 	res.start =3D (u64) start_pfn << PAGE_SHIFT;
 	res.end =3D ((u64)(start_pfn + nr_pages) << PAGE_SHIFT) - 1;
 	res.flags =3D IORESOURCE_MEM | IORESOURCE_BUSY;
 	orig_end =3D res.end;
-	while ((res.start < res.end) && (find_next_system_ram(&res) >=3D 0)) =
{
+	while ((res.start < res.end) &&
+		(find_next_system_ram(&res, "System RAM") >=3D 0)) {
 		pfn =3D (unsigned long)(res.start >> PAGE_SHIFT);
 		len =3D (unsigned long)((res.end + 1 - res.start) >> PAGE_SHIFT);
 		ret =3D (*func)(pfn, len, arg);
diff -puN mm/memory_hotplug.c~walk-system-ram-range mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~walk-system-ram-range
+++ a/mm/memory_hotplug.c
@@ -413,7 +413,7 @@ int online_pages(unsigned long pfn, unsi
 	if (!populated_zone(zone))
 		need_zonelists_rebuild =3D 1;
=20
-	ret =3D walk_memory_resource(pfn, nr_pages, &onlined_pages,
+	ret =3D walk_system_ram_range(pfn, nr_pages, &onlined_pages,
 		online_pages_range);
 	if (ret) {
 		printk(KERN_DEBUG "online_pages %lx at %lx failed\n",
@@ -705,7 +705,7 @@ offline_isolated_pages_cb(unsigned long=20
 static void
 offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 {
-	walk_memory_resource(start_pfn, end_pfn - start_pfn, NULL,
+	walk_system_ram_range(start_pfn, end_pfn - start_pfn, NULL,
 				offline_isolated_pages_cb);
 }
=20
@@ -731,7 +731,7 @@ check_pages_isolated(unsigned long start
 	long offlined =3D 0;
 	int ret;
=20
-	ret =3D walk_memory_resource(start_pfn, end_pfn - start_pfn, &offline=
d,
+	ret =3D walk_system_ram_range(start_pfn, end_pfn - start_pfn, &offlin=
ed,
 			check_pages_isolated_cb);
 	if (ret < 0)
 		offlined =3D (long)ret;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu=
=2Ecom are

origin.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-st=
ate.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.=
patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems=
=2Epatch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css=
-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css=
-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usag=
e.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
