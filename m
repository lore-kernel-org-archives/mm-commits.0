From: akpm@linux-foundation.org
Subject: + memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch added to -mm tree
Date: Wed, 31 Oct 2007 14:59:25 -0700
Message-ID: <200710312159.l9VLxP1l030929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760371AbXJaWBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 18:01:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au, rientjes@google.com, svaidy@linux.vnet.ibm.com, xemul@openvz.org


The patch titled
     memory cgroup enhancements: force_empty interface for dropping all account in empty cgroup
has been added to the -mm tree.  Its filename is
     memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memory cgroup enhancements: force_empty interface for dropping all account in empty cgroup
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch adds an interface "memory.force_empty".  Any write to this file
will drop all charges in this cgroup if there is no task under.

%echo 1 > /....../memory.force_empty

will drop all charges of memory cgroup if cgroup's tasks is empty.

This is useful to invoke rmdir() against memory cgroup successfully.

Tested and worked well on x86_64/fake-NUMA system.

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

 mm/memcontrol.c |  110 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 103 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup
+++ a/mm/memcontrol.c
@@ -480,6 +480,7 @@ void mem_cgroup_uncharge(struct page_cgr
 		page = pc->page;
 		/*
 		 * get page->cgroup and clear it under lock.
+		 * force_empty can drop page->cgroup without checking refcnt.
 		 */
 		if (clear_page_cgroup(page, pc) == pc) {
 			mem = pc->mem_cgroup;
@@ -489,13 +490,6 @@ void mem_cgroup_uncharge(struct page_cgr
 			list_del_init(&pc->lru);
 			spin_unlock_irqrestore(&mem->lru_lock, flags);
 			kfree(pc);
-		} else {
-			/*
-			 * Note:This will be removed when force-empty patch is
-			 * applied. just show warning here.
-			 */
-			printk(KERN_ERR "Race in mem_cgroup_uncharge() ?");
-			dump_stack();
 		}
 	}
 }
@@ -543,6 +537,76 @@ retry:
 	return;
 }
 
+/*
+ * This routine traverse page_cgroup in given list and drop them all.
+ * This routine ignores page_cgroup->ref_cnt.
+ * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
+ */
+#define FORCE_UNCHARGE_BATCH	(128)
+static void
+mem_cgroup_force_empty_list(struct mem_cgroup *mem, struct list_head *list)
+{
+	struct page_cgroup *pc;
+	struct page *page;
+	int count;
+	unsigned long flags;
+
+retry:
+	count = FORCE_UNCHARGE_BATCH;
+	spin_lock_irqsave(&mem->lru_lock, flags);
+
+	while (--count && !list_empty(list)) {
+		pc = list_entry(list->prev, struct page_cgroup, lru);
+		page = pc->page;
+		/* Avoid race with charge */
+		atomic_set(&pc->ref_cnt, 0);
+		if (clear_page_cgroup(page, pc) == pc) {
+			css_put(&mem->css);
+			res_counter_uncharge(&mem->res, PAGE_SIZE);
+			list_del_init(&pc->lru);
+			kfree(pc);
+		} else 	/* being uncharged ? ...do relax */
+			break;
+	}
+	spin_unlock_irqrestore(&mem->lru_lock, flags);
+	if (!list_empty(list)) {
+		cond_resched();
+		goto retry;
+	}
+	return;
+}
+
+/*
+ * make mem_cgroup's charge to be 0 if there is no task.
+ * This enables deleting this mem_cgroup.
+ */
+
+int mem_cgroup_force_empty(struct mem_cgroup *mem)
+{
+	int ret = -EBUSY;
+	css_get(&mem->css);
+	/*
+	 * page reclaim code (kswapd etc..) will move pages between
+`	 * active_list <-> inactive_list while we don't take a lock.
+	 * So, we have to do loop here until all lists are empty.
+	 */
+	while (!(list_empty(&mem->active_list) &&
+		 list_empty(&mem->inactive_list))) {
+		if (atomic_read(&mem->css.cgroup->count) > 0)
+			goto out;
+		/* drop all page_cgroup in active_list */
+		mem_cgroup_force_empty_list(mem, &mem->active_list);
+		/* drop all page_cgroup in inactive_list */
+		mem_cgroup_force_empty_list(mem, &mem->inactive_list);
+	}
+	ret = 0;
+out:
+	css_put(&mem->css);
+	return ret;
+}
+
+
+
 int mem_cgroup_write_strategy(char *buf, unsigned long long *tmp)
 {
 	*tmp = memparse(buf, &buf);
@@ -628,6 +692,33 @@ static ssize_t mem_control_type_read(str
 			ppos, buf, s - buf);
 }
 
+
+static ssize_t mem_force_empty_write(struct cgroup *cont,
+				struct cftype *cft, struct file *file,
+				const char __user *userbuf,
+				size_t nbytes, loff_t *ppos)
+{
+	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
+	int ret;
+	ret = mem_cgroup_force_empty(mem);
+	if (!ret)
+		ret = nbytes;
+	return ret;
+}
+
+/*
+ * Note: This should be removed if cgroup supports write-only file.
+ */
+
+static ssize_t mem_force_empty_read(struct cgroup *cont,
+				struct cftype *cft,
+				struct file *file, char __user *userbuf,
+				size_t nbytes, loff_t *ppos)
+{
+	return -EINVAL;
+}
+
+
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -650,6 +741,11 @@ static struct cftype mem_cgroup_files[] 
 		.write = mem_control_type_write,
 		.read = mem_control_type_read,
 	},
+	{
+		.name = "force_empty",
+		.write = mem_force_empty_write,
+		.read = mem_force_empty_read,
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
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force-empty-at-rmdir.patch
