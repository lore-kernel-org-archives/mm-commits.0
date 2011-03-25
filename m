From: akpm@linux-foundation.org
Subject: [merged] lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:27:10 -0700
Message-ID: <201103250727.p2P7R4n2026218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933890Ab1CYH1R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:27:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, James.Bottomley@hansenpartnership.com, akpm@linux-foundation.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     lib, arch: add filter argument to show_mem and fix private implementations
has been removed from the -mm tree.  Its filename was
     lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib, arch: add filter argument to show_mem and fix private implementations


ddd588b5dd55 ("oom: suppress nodes that are not allowed from meminfo on
oom kill") moved lib/show_mem.o out of lib/lib.a, which resulted in build
warnings on all architectures that implement their own versions of
show_mem():

	lib/lib.a(show_mem.o): In function `show_mem':
	show_mem.c:(.text+0x1f4): multiple definition of `show_mem'
	arch/sparc/mm/built-in.o:(.text+0xd70): first defined here

The fix is to remove __show_mem() and add its argument to show_mem() in
all implementations to prevent this breakage.

Architectures that implement their own show_mem() actually don't do
anything with the argument yet, but they could be made to filter nodes
that aren't allowed in the current context in the future just like the
generic implementation.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: James Bottomley <James.Bottomley@hansenpartnership.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c        |    2 +-
 arch/ia64/mm/contig.c     |    2 +-
 arch/ia64/mm/discontig.c  |    2 +-
 arch/parisc/mm/init.c     |    2 +-
 arch/powerpc/xmon/xmon.c  |    2 +-
 arch/sparc/mm/init_32.c   |    2 +-
 arch/tile/mm/pgtable.c    |    2 +-
 arch/unicore32/mm/init.c  |    2 +-
 drivers/tty/sysrq.c       |    2 +-
 drivers/tty/vt/keyboard.c |    2 +-
 include/linux/mm.h        |    5 ++---
 lib/show_mem.c            |    7 +------
 mm/oom_kill.c             |    2 +-
 mm/page_alloc.c           |    2 +-
 14 files changed, 15 insertions(+), 21 deletions(-)

diff -puN arch/arm/mm/init.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations
+++ a/arch/arm/mm/init.c
@@ -78,7 +78,7 @@ __tagtable(ATAG_INITRD2, parse_tag_initr
  */
 struct meminfo meminfo;
 
-void show_mem(void)
+void show_mem(unsigned int filter)
 {
 	int free = 0, total = 0, reserved = 0;
 	int shared = 0, cached = 0, slab = 0, i;
diff -puN arch/ia64/mm/contig.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations
+++ a/arch/ia64/mm/contig.c
@@ -36,7 +36,7 @@ static unsigned long max_gap;
  * Shows a simple page count of reserved and used pages in the system.
  * For discontig machines, it does this on a per-pgdat basis.
  */
-void show_mem(void)
+void show_mem(unsigned int filter)
 {
 	int i, total_reserved = 0;
 	int total_shared = 0, total_cached = 0;
diff -puN arch/ia64/mm/discontig.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations
+++ a/arch/ia64/mm/discontig.c
@@ -614,7 +614,7 @@ void __cpuinit *per_cpu_init(void)
  * Shows a simple page count of reserved and used pages in the system.
  * For discontig machines, it does this on a per-pgdat basis.
  */
-void show_mem(void)
+void show_mem(unsigned int filter)
 {
 	int i, total_reserved = 0;
 	int total_shared = 0, total_cached = 0;
diff -puN arch/parisc/mm/init.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations
+++ a/arch/parisc/mm/init.c
@@ -544,7 +544,7 @@ void __init mem_init(void)
 unsigned long *empty_zero_page __read_mostly;
 EXPORT_SYMBOL(empty_zero_page);
 
-void show_mem(void)
+void show_mem(unsigned int filter)
 {
 	int i,free = 0,total = 0,reserved = 0;
 	int shared = 0, cached = 0;
diff -puN arch/powerpc/xmon/xmon.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations arch/powerpc/xmon/xmon.c
--- a/arch/powerpc/xmon/xmon.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations
+++ a/arch/powerpc/xmon/xmon.c
@@ -821,7 +821,7 @@ cmds(struct pt_regs *excp)
 				memzcan();
 				break;
 			case 'i':
-				show_mem();
+				show_mem(0);
 				break;
 			default:
 				termch = cmd;
diff -puN arch/sparc/mm/init_32.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations arch/sparc/mm/init_32.c
--- a/arch/sparc/mm/init_32.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations
+++ a/arch/sparc/mm/init_32.c
@@ -75,7 +75,7 @@ void __init kmap_init(void)
 	kmap_prot = __pgprot(SRMMU_ET_PTE | SRMMU_PRIV | SRMMU_CACHE);
 }
 
-void show_mem(void)
+void show_mem(unsigned int filter)
 {
 	printk("Mem-info:\n");
 	show_free_areas();
diff -puN arch/tile/mm/pgtable.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations arch/tile/mm/pgtable.c
--- a/arch/tile/mm/pgtable.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations
+++ a/arch/tile/mm/pgtable.c
@@ -41,7 +41,7 @@
  * The normal show_free_areas() is too verbose on Tile, with dozens
  * of processors and often four NUMA zones each with high and lowmem.
  */
-void show_mem(void)
+void show_mem(unsigned int filter)
 {
 	struct zone *zone;
 
diff -puN arch/unicore32/mm/init.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations arch/unicore32/mm/init.c
--- a/arch/unicore32/mm/init.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations
+++ a/arch/unicore32/mm/init.c
@@ -55,7 +55,7 @@ early_param("initrd", early_initrd);
  */
 struct meminfo meminfo;
 
-void show_mem(void)
+void show_mem(unsigned int filter)
 {
 	int free = 0, total = 0, reserved = 0;
 	int shared = 0, cached = 0, slab = 0, i;
diff -puN drivers/tty/sysrq.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations
+++ a/drivers/tty/sysrq.c
@@ -306,7 +306,7 @@ static struct sysrq_key_op sysrq_ftrace_
 
 static void sysrq_handle_showmem(int key)
 {
-	show_mem();
+	show_mem(0);
 }
 static struct sysrq_key_op sysrq_showmem_op = {
 	.handler	= sysrq_handle_showmem,
diff -puN drivers/tty/vt/keyboard.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations drivers/tty/vt/keyboard.c
--- a/drivers/tty/vt/keyboard.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations
+++ a/drivers/tty/vt/keyboard.c
@@ -604,7 +604,7 @@ static void fn_scroll_back(struct vc_dat
 
 static void fn_show_mem(struct vc_data *vc)
 {
-	show_mem();
+	show_mem(0);
 }
 
 static void fn_show_state(struct vc_data *vc)
diff -puN include/linux/mm.h~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations include/linux/mm.h
--- a/include/linux/mm.h~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations
+++ a/include/linux/mm.h
@@ -861,7 +861,7 @@ extern void pagefault_out_of_memory(void
 #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
 
 /*
- * Flags passed to __show_mem() and __show_free_areas() to suppress output in
+ * Flags passed to show_mem() and __show_free_areas() to suppress output in
  * various contexts.
  */
 #define SHOW_MEM_FILTER_NODES	(0x0001u)	/* filter disallowed nodes */
@@ -1358,8 +1358,7 @@ extern void setup_per_zone_wmarks(void);
 extern void calculate_zone_inactive_ratio(struct zone *zone);
 extern void mem_init(void);
 extern void __init mmap_init(void);
-extern void show_mem(void);
-extern void __show_mem(unsigned int flags);
+extern void show_mem(unsigned int flags);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 extern int after_bootmem;
diff -puN lib/show_mem.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations lib/show_mem.c
--- a/lib/show_mem.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations
+++ a/lib/show_mem.c
@@ -9,7 +9,7 @@
 #include <linux/nmi.h>
 #include <linux/quicklist.h>
 
-void __show_mem(unsigned int filter)
+void show_mem(unsigned int filter)
 {
 	pg_data_t *pgdat;
 	unsigned long total = 0, reserved = 0, shared = 0,
@@ -61,8 +61,3 @@ void __show_mem(unsigned int filter)
 		quicklist_total_size());
 #endif
 }
-
-void show_mem(void)
-{
-	__show_mem(0);
-}
diff -puN mm/oom_kill.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations mm/oom_kill.c
--- a/mm/oom_kill.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations
+++ a/mm/oom_kill.c
@@ -406,7 +406,7 @@ static void dump_header(struct task_stru
 	task_unlock(current);
 	dump_stack();
 	mem_cgroup_print_oom_info(mem, p);
-	__show_mem(SHOW_MEM_FILTER_NODES);
+	show_mem(SHOW_MEM_FILTER_NODES);
 	if (sysctl_oom_dump_tasks)
 		dump_tasks(mem, nodemask);
 }
diff -puN mm/page_alloc.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations mm/page_alloc.c
--- a/mm/page_alloc.c~lib-arch-add-filter-argument-to-show_mem-and-fix-private-implementations
+++ a/mm/page_alloc.c
@@ -2195,7 +2195,7 @@ nopage:
 			current->comm, order, gfp_mask);
 		dump_stack();
 		if (!should_suppress_show_mem())
-			__show_mem(filter);
+			show_mem(filter);
 	}
 	return page;
 got_pg:
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch

