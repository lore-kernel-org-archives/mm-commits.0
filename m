From: akpm@linux-foundation.org
Subject: - vmallocinfo-add-numa-information.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:22:48 -0700
Message-ID: <200807242322.m6ONMm7m010597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480AbYGXXXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, cl@linux-foundation.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     vmallocinfo: add NUMA information
has been removed from the -mm tree.  Its filename was
     vmallocinfo-add-numa-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmallocinfo: add NUMA information
From: Eric Dumazet <dada1@cosmosbay.com>

Christoph recently added /proc/vmallocinfo file to get information about
vmalloc allocations.

This patch adds NUMA specific information, giving number of pages
allocated on each memory node.

This should help to check that vmalloc() is able to respect NUMA policies.

Example of output on a four nodes machine (one cpu per node)

1) network hash tables are evenly spreaded on four nodes (OK) (Same
   point for inodes and dentries hash tables)

2) iptables tables (x_tables) are correctly allocated on each cpu node
   (OK).

3) sys_swapon() allocates its memory from one node only.

4) each loaded module is using memory on one node.

Sysadmins could tune their setup to change points 3) and 4) if necessary.

grep "pages="  /proc/vmallocinfo
0xffffc20000000000-0xffffc20000201000 2101248 alloc_large_system_hash+0x204/0x2c0 pages=512 vmalloc N0=128 N1=128 N2=128 N3=128
0xffffc20000201000-0xffffc20000302000 1052672 alloc_large_system_hash+0x204/0x2c0 pages=256 vmalloc N0=64 N1=64 N2=64 N3=64
0xffffc2000031a000-0xffffc2000031d000   12288 alloc_large_system_hash+0x204/0x2c0 pages=2 vmalloc N1=1 N2=1
0xffffc2000031f000-0xffffc2000032b000   49152 cramfs_uncompress_init+0x2e/0x80 pages=11 vmalloc N0=3 N1=3 N2=2 N3=3
0xffffc2000033e000-0xffffc20000341000   12288 sys_swapon+0x640/0xac0 pages=2 vmalloc N0=2
0xffffc20000341000-0xffffc20000344000   12288 xt_alloc_table_info+0xfe/0x130 [x_tables] pages=2 vmalloc N0=2
0xffffc20000344000-0xffffc20000347000   12288 xt_alloc_table_info+0xfe/0x130 [x_tables] pages=2 vmalloc N1=2
0xffffc20000347000-0xffffc2000034a000   12288 xt_alloc_table_info+0xfe/0x130 [x_tables] pages=2 vmalloc N2=2
0xffffc2000034a000-0xffffc2000034d000   12288 xt_alloc_table_info+0xfe/0x130 [x_tables] pages=2 vmalloc N3=2
0xffffc20004381000-0xffffc20004402000  528384 alloc_large_system_hash+0x204/0x2c0 pages=128 vmalloc N0=32 N1=32 N2=32 N3=32
0xffffc20004402000-0xffffc20004803000 4198400 alloc_large_system_hash+0x204/0x2c0 pages=1024 vmalloc vpages N0=256 N1=256 N2=256 N3=256
0xffffc20004803000-0xffffc20004904000 1052672 alloc_large_system_hash+0x204/0x2c0 pages=256 vmalloc N0=64 N1=64 N2=64 N3=64
0xffffc20004904000-0xffffc20004bec000 3047424 sys_swapon+0x640/0xac0 pages=743 vmalloc vpages N0=743
0xffffffffa0000000-0xffffffffa000f000   61440 sys_init_module+0xc27/0x1d00 pages=14 vmalloc N1=14
0xffffffffa000f000-0xffffffffa0014000   20480 sys_init_module+0xc27/0x1d00 pages=4 vmalloc N0=4
0xffffffffa0014000-0xffffffffa0017000   12288 sys_init_module+0xc27/0x1d00 pages=2 vmalloc N0=2
0xffffffffa0017000-0xffffffffa0022000   45056 sys_init_module+0xc27/0x1d00 pages=10 vmalloc N1=10
0xffffffffa0022000-0xffffffffa0028000   24576 sys_init_module+0xc27/0x1d00 pages=5 vmalloc N3=5
0xffffffffa0028000-0xffffffffa0050000  163840 sys_init_module+0xc27/0x1d00 pages=39 vmalloc N1=39
0xffffffffa0050000-0xffffffffa0052000    8192 sys_init_module+0xc27/0x1d00 pages=1 vmalloc N1=1
0xffffffffa0052000-0xffffffffa0056000   16384 sys_init_module+0xc27/0x1d00 pages=3 vmalloc N1=3
0xffffffffa0056000-0xffffffffa0081000  176128 sys_init_module+0xc27/0x1d00 pages=42 vmalloc N3=42
0xffffffffa0081000-0xffffffffa00ae000  184320 sys_init_module+0xc27/0x1d00 pages=44 vmalloc N3=44
0xffffffffa00ae000-0xffffffffa00b1000   12288 sys_init_module+0xc27/0x1d00 pages=2 vmalloc N3=2
0xffffffffa00b1000-0xffffffffa00b9000   32768 sys_init_module+0xc27/0x1d00 pages=7 vmalloc N0=7
0xffffffffa00b9000-0xffffffffa00c4000   45056 sys_init_module+0xc27/0x1d00 pages=10 vmalloc N3=10
0xffffffffa00c6000-0xffffffffa00e0000  106496 sys_init_module+0xc27/0x1d00 pages=25 vmalloc N2=25
0xffffffffa00e0000-0xffffffffa00f1000   69632 sys_init_module+0xc27/0x1d00 pages=16 vmalloc N2=16
0xffffffffa00f1000-0xffffffffa00f4000   12288 sys_init_module+0xc27/0x1d00 pages=2 vmalloc N3=2
0xffffffffa00f4000-0xffffffffa00f7000   12288 sys_init_module+0xc27/0x1d00 pages=2 vmalloc N3=2

[akpm@linux-foundation.org: fix comment]
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   44 +++++++++++++++++++++++++++
 fs/proc/proc_misc.c                |   15 +++++++--
 mm/vmalloc.c                       |   20 ++++++++++++
 3 files changed, 77 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/proc.txt~vmallocinfo-add-numa-information Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~vmallocinfo-add-numa-information
+++ a/Documentation/filesystems/proc.txt
@@ -296,6 +296,7 @@ Table 1-4: Kernel info in /proc
  uptime      System uptime                                     
  version     Kernel version                                    
  video	     bttv info of video resources			(2.4)
+ vmallocinfo Show vmalloced areas
 ..............................................................................
 
 You can,  for  example,  check  which interrupts are currently in use and what
@@ -557,6 +558,49 @@ VmallocTotal: total size of vmalloc memo
  VmallocUsed: amount of vmalloc area which is used
 VmallocChunk: largest contigious block of vmalloc area which is free
 
+..............................................................................
+
+vmallocinfo:
+
+Provides information about vmalloced/vmaped areas. One line per area,
+containing the virtual address range of the area, size in bytes,
+caller information of the creator, and optional information depending
+on the kind of area :
+
+ pages=nr    number of pages
+ phys=addr   if a physical address was specified
+ ioremap     I/O mapping (ioremap() and friends)
+ vmalloc     vmalloc() area
+ vmap        vmap()ed pages
+ user        VM_USERMAP area
+ vpages      buffer for pages pointers was vmalloced (huge area)
+ N<node>=nr  (Only on NUMA kernels)
+             Number of pages allocated on memory node <node>
+
+> cat /proc/vmallocinfo
+0xffffc20000000000-0xffffc20000201000 2101248 alloc_large_system_hash+0x204 ...
+  /0x2c0 pages=512 vmalloc N0=128 N1=128 N2=128 N3=128
+0xffffc20000201000-0xffffc20000302000 1052672 alloc_large_system_hash+0x204 ...
+  /0x2c0 pages=256 vmalloc N0=64 N1=64 N2=64 N3=64
+0xffffc20000302000-0xffffc20000304000    8192 acpi_tb_verify_table+0x21/0x4f...
+  phys=7fee8000 ioremap
+0xffffc20000304000-0xffffc20000307000   12288 acpi_tb_verify_table+0x21/0x4f...
+  phys=7fee7000 ioremap
+0xffffc2000031d000-0xffffc2000031f000    8192 init_vdso_vars+0x112/0x210
+0xffffc2000031f000-0xffffc2000032b000   49152 cramfs_uncompress_init+0x2e ...
+  /0x80 pages=11 vmalloc N0=3 N1=3 N2=2 N3=3
+0xffffc2000033a000-0xffffc2000033d000   12288 sys_swapon+0x640/0xac0      ...
+  pages=2 vmalloc N1=2
+0xffffc20000347000-0xffffc2000034c000   20480 xt_alloc_table_info+0xfe ...
+  /0x130 [x_tables] pages=4 vmalloc N0=4
+0xffffffffa0000000-0xffffffffa000f000   61440 sys_init_module+0xc27/0x1d00 ...
+   pages=14 vmalloc N2=14
+0xffffffffa000f000-0xffffffffa0014000   20480 sys_init_module+0xc27/0x1d00 ...
+   pages=4 vmalloc N1=4
+0xffffffffa0014000-0xffffffffa0017000   12288 sys_init_module+0xc27/0x1d00 ...
+   pages=2 vmalloc N1=2
+0xffffffffa0017000-0xffffffffa0022000   45056 sys_init_module+0xc27/0x1d00 ...
+   pages=10 vmalloc N0=10
 
 1.3 IDE devices in /proc/ide
 ----------------------------
diff -puN fs/proc/proc_misc.c~vmallocinfo-add-numa-information fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~vmallocinfo-add-numa-information
+++ a/fs/proc/proc_misc.c
@@ -464,14 +464,25 @@ static const struct file_operations proc
 #ifdef CONFIG_MMU
 static int vmalloc_open(struct inode *inode, struct file *file)
 {
-	return seq_open(file, &vmalloc_op);
+	unsigned int *ptr = NULL;
+	int ret;
+
+	if (NUMA_BUILD)
+		ptr = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
+	ret = seq_open(file, &vmalloc_op);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		m->private = ptr;
+	} else
+		kfree(ptr);
+	return ret;
 }
 
 static const struct file_operations proc_vmalloc_operations = {
 	.open		= vmalloc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= seq_release_private,
 };
 #endif
 
diff -puN mm/vmalloc.c~vmallocinfo-add-numa-information mm/vmalloc.c
--- a/mm/vmalloc.c~vmallocinfo-add-numa-information
+++ a/mm/vmalloc.c
@@ -931,6 +931,25 @@ static void s_stop(struct seq_file *m, v
 	read_unlock(&vmlist_lock);
 }
 
+static void show_numa_info(struct seq_file *m, struct vm_struct *v)
+{
+	if (NUMA_BUILD) {
+		unsigned int nr, *counters = m->private;
+
+		if (!counters)
+			return;
+
+		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
+
+		for (nr = 0; nr < v->nr_pages; nr++)
+			counters[page_to_nid(v->pages[nr])]++;
+
+		for_each_node_state(nr, N_HIGH_MEMORY)
+			if (counters[nr])
+				seq_printf(m, " N%u=%u", nr, counters[nr]);
+	}
+}
+
 static int s_show(struct seq_file *m, void *p)
 {
 	struct vm_struct *v = p;
@@ -967,6 +986,7 @@ static int s_show(struct seq_file *m, vo
 	if (v->flags & VM_VPAGES)
 		seq_printf(m, " vpages");
 
+	show_numa_info(m, v);
 	seq_putc(m, '\n');
 	return 0;
 }
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch

