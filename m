From: akpm@linux-foundation.org
Subject: - memory-cgroup-enhancements-add-memorystat-file.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:04:28 -0800
Message-ID: <200802080804.m188493L014244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753682AbYBHI3z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:29:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     memory cgroup enhancements: add memory.stat file
has been removed from the -mm tree.  Its filename was
     memory-cgroup-enhancements-add-memorystat-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory cgroup enhancements: add memory.stat file
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Show accounted information of memory cgroup by memory.stat file

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: fix printk warning]
Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: David Rientjes <rientjes@google.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff -puN mm/memcontrol.c~memory-cgroup-enhancements-add-memorystat-file mm/memcontrol.c
--- a/mm/memcontrol.c~memory-cgroup-enhancements-add-memorystat-file
+++ a/mm/memcontrol.c
@@ -29,6 +29,7 @@
 #include <linux/swap.h>
 #include <linux/spinlock.h>
 #include <linux/fs.h>
+#include <linux/seq_file.h>
 
 #include <asm/uaccess.h>
 
@@ -794,6 +795,49 @@ static ssize_t mem_force_empty_read(stru
 }
 
 
+static const struct mem_cgroup_stat_desc {
+	const char *msg;
+	u64 unit;
+} mem_cgroup_stat_desc[] = {
+	[MEM_CGROUP_STAT_CACHE] = { "cache", PAGE_SIZE, },
+	[MEM_CGROUP_STAT_RSS] = { "rss", PAGE_SIZE, },
+};
+
+static int mem_control_stat_show(struct seq_file *m, void *arg)
+{
+	struct cgroup *cont = m->private;
+	struct mem_cgroup *mem_cont = mem_cgroup_from_cont(cont);
+	struct mem_cgroup_stat *stat = &mem_cont->stat;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(stat->cpustat[0].count); i++) {
+		s64 val;
+
+		val = mem_cgroup_read_stat(stat, i);
+		val *= mem_cgroup_stat_desc[i].unit;
+		seq_printf(m, "%s %lld\n", mem_cgroup_stat_desc[i].msg,
+				(long long)val);
+	}
+	return 0;
+}
+
+static const struct file_operations mem_control_stat_file_operations = {
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int mem_control_stat_open(struct inode *unused, struct file *file)
+{
+	/* XXX __d_cont */
+	struct cgroup *cont = file->f_dentry->d_parent->d_fsdata;
+
+	file->f_op = &mem_control_stat_file_operations;
+	return single_open(file, mem_control_stat_show, cont);
+}
+
+
+
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -821,6 +865,10 @@ static struct cftype mem_cgroup_files[] 
 		.write = mem_force_empty_write,
 		.read = mem_force_empty_read,
 	},
+	{
+		.name = "stat",
+		.open = mem_control_stat_open,
+	},
 };
 
 static struct mem_cgroup init_mem_cgroup;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
