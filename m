From: akpm@linux-foundation.org
Subject: + memcg-fix-page_cgroup-allocation.patch added to -mm tree
Date: Tue, 21 Oct 2008 18:38:17 -0700
Message-ID: <200810220138.m9M1cHt3004324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330AbYJVBiY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 21:38:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com


The patch titled
     memcg: fix page_cgroup allocation
has been added to the -mm tree.  Its filename is
     memcg-fix-page_cgroup-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix page_cgroup allocation
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

page_cgroup_init() is called from mem_cgroup_init(). But at this
point, we cannot call alloc_bootmem().
(and this caused panic at boot.)

This patch moves page_cgroup_init() to init/main.c.

Time table is following:
==
  parse_args(). # we can trust mem_cgroup_subsys.disabled bit after this.
  ....
  cgroup_init_early()  # "early" init of cgroup.
  ....
  setup_arch()         # memmap is allocated.
  ...
  page_cgroup_init();
  mem_init();   # we cannot call alloc_bootmem after this.
  ....
  cgroup_init() # mem_cgroup is initialized.
==

Before page_cgroup_init(), mem_map must be initialized. So,
I added page_cgroup_init() to init/main.c directly.

(*) maybe this is not very clean but
    - cgroup_init_early() is too early
    - in cgroup_init(), we have to use vmalloc instead of alloc_bootmem().
    use of vmalloc area in x86-32 is important and we should avoid very large
    vmalloc() in x86-32. So, we want to use alloc_bootmem() and added page_cgroup_init()
    directly to init/main.c

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c      |    2 ++
 mm/memcontrol.c  |    1 -
 mm/page_cgroup.c |   34 +++++++++++++++++++++++++++-------
 3 files changed, 29 insertions(+), 8 deletions(-)

diff -puN init/main.c~memcg-fix-page_cgroup-allocation init/main.c
--- a/init/main.c~memcg-fix-page_cgroup-allocation
+++ a/init/main.c
@@ -52,6 +52,7 @@
 #include <linux/key.h>
 #include <linux/unwind.h>
 #include <linux/buffer_head.h>
+#include <linux/page_cgroup.h>
 #include <linux/debug_locks.h>
 #include <linux/debugobjects.h>
 #include <linux/lockdep.h>
@@ -646,6 +647,7 @@ asmlinkage void __init start_kernel(void
 	vmalloc_init();
 	vfs_caches_init_early();
 	cpuset_init_early();
+	page_cgroup_init();
 	mem_init();
 	enable_debug_pagealloc();
 	cpu_hotplug_init();
diff -puN mm/memcontrol.c~memcg-fix-page_cgroup-allocation mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-page_cgroup-allocation
+++ a/mm/memcontrol.c
@@ -1088,7 +1088,6 @@ mem_cgroup_create(struct cgroup_subsys *
 	int node;
 
 	if (unlikely((cont->parent) == NULL)) {
-		page_cgroup_init();
 		mem = &init_mem_cgroup;
 	} else {
 		mem = mem_cgroup_alloc();
diff -puN mm/page_cgroup.c~memcg-fix-page_cgroup-allocation mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-fix-page_cgroup-allocation
+++ a/mm/page_cgroup.c
@@ -4,8 +4,12 @@
 #include <linux/bit_spinlock.h>
 #include <linux/page_cgroup.h>
 #include <linux/hash.h>
+#include <linux/slab.h>
 #include <linux/memory.h>
 #include <linux/vmalloc.h>
+#include <linux/cgroup.h>
+
+extern struct cgroup_subsys mem_cgroup_subsys;
 
 static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
@@ -67,6 +71,9 @@ void __init page_cgroup_init(void)
 
 	int nid, fail;
 
+	if (mem_cgroup_subsys.disabled)
+		return;
+
 	for_each_online_node(nid)  {
 		fail = alloc_node_page_cgroup(nid);
 		if (fail)
@@ -107,9 +114,14 @@ int __meminit init_section_page_cgroup(u
 	nid = page_to_nid(pfn_to_page(pfn));
 
 	table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-	base = kmalloc_node(table_size, GFP_KERNEL, nid);
-	if (!base)
-		base = vmalloc_node(table_size, nid);
+	if (slab_is_available()) {
+		base = kmalloc_node(table_size, GFP_KERNEL, nid);
+		if (!base)
+			base = vmalloc_node(table_size, nid);
+	} else {
+		base = __alloc_bootmem_node_nopanic(NODE_DATA(nid), table_size,
+				PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+	}
 
 	if (!base) {
 		printk(KERN_ERR "page cgroup allocation failure\n");
@@ -136,11 +148,16 @@ void __free_page_cgroup(unsigned long pf
 	if (!ms || !ms->page_cgroup)
 		return;
 	base = ms->page_cgroup + pfn;
-	ms->page_cgroup = NULL;
-	if (is_vmalloc_addr(base))
+	if (is_vmalloc_addr(base)) {
 		vfree(base);
-	else
-		kfree(base);
+		ms->page_cgroup = NULL;
+	} else {
+		struct page *page = virt_to_page(base);
+		if (!PageReserved(page)) { /* Is bootmem ? */
+			kfree(base);
+			ms->page_cgroup = NULL;
+		}
+	}
 }
 
 int online_page_cgroup(unsigned long start_pfn,
@@ -214,6 +231,9 @@ void __init page_cgroup_init(void)
 	unsigned long pfn;
 	int fail = 0;
 
+	if (mem_cgroup_subsys.disabled)
+		return;
+
 	for (pfn = 0; !fail && pfn < max_pfn; pfn += PAGES_PER_SECTION) {
 		if (!pfn_present(pfn))
 			continue;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-page_cgroup-needs-linux-vmalloch-for-vmalloc_node-vfree.patch
memcg-fix-page_cgroup-allocation.patch
memcg-fix-page_cgroup-allocation-fix.patch

