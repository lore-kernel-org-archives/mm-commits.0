From: akpm@linux-foundation.org
Subject: + memory-cgroup-enhancements-add-memorystat-file.patch added to -mm tree
Date: Wed, 31 Oct 2007 15:14:33 -0700
Message-ID: <200710312214.l9VMEXWC031759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52455 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753576AbXJaWQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 18:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au, rientjes@google.com, svaidy@linux.vnet.ibm.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memory cgroup enhancements: add memory.stat file
has been added to the -mm tree.  Its filename is
     memory-cgroup-enhancements-add-memorystat-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memory cgroup enhancements: add memory.stat file
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Show accounted information of memory cgroup by memory.stat file

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

 mm/memcontrol.c |   47 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff -puN mm/memcontrol.c~memory-cgroup-enhancements-add-memorystat-file mm/memcontrol.c
--- a/mm/memcontrol.c~memory-cgroup-enhancements-add-memorystat-file
+++ a/mm/memcontrol.c
@@ -29,6 +29,7 @@
 #include <linux/swap.h>
 #include <linux/spinlock.h>
 #include <linux/fs.h>
+#include <linux/seq_file.h>
 
 #include <asm/uaccess.h>
 
@@ -808,6 +809,48 @@ static ssize_t mem_force_empty_read(stru
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
+		val = mem_cgroup_read_stat(stat,i);
+		val *= mem_cgroup_stat_desc[i].unit;
+		seq_printf(m, "%s %lld\n", mem_cgroup_stat_desc[i].msg, val);
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
@@ -835,6 +878,10 @@ static struct cftype mem_cgroup_files[] 
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

git-sh.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force-empty-at-rmdir.patch
