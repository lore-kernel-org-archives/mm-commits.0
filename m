From: akpm@linux-foundation.org
Subject: - hugetlb-new-sysfs-interface.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:04 -0700
Message-ID: <200807242323.m6ONN4Na010624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753952AbYGXXXQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, dave@linux.vnet.ibm.com, gregkh@suse.de, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: new sysfs interface
has been removed from the -mm tree.  Its filename was
     hugetlb-new-sysfs-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: new sysfs interface
From: Nick Piggin <npiggin@suse.de>

Provide new hugepages user APIs that are more suited to multiple hstates
in sysfs.  There is a new directory, /sys/kernel/hugepages.  Underneath
that directory there will be a directory per-supported hugepage size,
e.g.:

/sys/kernel/hugepages/hugepages-64kB
/sys/kernel/hugepages/hugepages-16384kB
/sys/kernel/hugepages/hugepages-16777216kB

corresponding to 64k, 16m and 16g respectively.  Within each
hugepages-size directory there are a number of files, corresponding to the
tracked counters in the hstate, e.g.:

/sys/kernel/hugepages/hugepages-64/nr_hugepages
/sys/kernel/hugepages/hugepages-64/nr_overcommit_hugepages
/sys/kernel/hugepages/hugepages-64/free_hugepages
/sys/kernel/hugepages/hugepages-64/resv_hugepages
/sys/kernel/hugepages/hugepages-64/surplus_hugepages

Of these files, the first two are read-write and the latter three are
read-only.  The size of the hugepage being manipulated is trivially
deducible from the enclosing directory and is always expressed in kB (to
match meminfo).

[dave@linux.vnet.ibm.com: fix build]
[nacc@us.ibm.com: hugetlb: hang off of /sys/kernel/mm rather than /sys/kernel]
[nacc@us.ibm.com: hugetlb: remove CONFIG_SYSFS dependency]
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-hugepages |   15 
 Documentation/vm/hugetlbpage.txt                    |   23 
 include/linux/hugetlb.h                             |    2 
 mm/hugetlb.c                                        |  288 +++++++---
 4 files changed, 262 insertions(+), 66 deletions(-)

diff -puN /dev/null Documentation/ABI/testing/sysfs-kernel-mm-hugepages
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-hugepages
@@ -0,0 +1,15 @@
+What:		/sys/kernel/mm/hugepages/
+Date:		June 2008
+Contact:	Nishanth Aravamudan <nacc@us.ibm.com>, hugetlb maintainers
+Description:
+		/sys/kernel/mm/hugepages/ contains a number of subdirectories
+		of the form hugepages-<size>kB, where <size> is the page size
+		of the hugepages supported by the kernel/CPU combination.
+
+		Under these directories are a number of files:
+			nr_hugepages
+			nr_overcommit_hugepages
+			free_hugepages
+			surplus_hugepages
+			resv_hugepages
+		See Documentation/vm/hugetlbpage.txt for details.
diff -puN Documentation/vm/hugetlbpage.txt~hugetlb-new-sysfs-interface Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~hugetlb-new-sysfs-interface
+++ a/Documentation/vm/hugetlbpage.txt
@@ -95,6 +95,29 @@ this condition holds, however, no more s
 allowed on the system until one of the two sysctls are increased
 sufficiently, or the surplus huge pages go out of use and are freed.
 
+With support for multiple hugepage pools at run-time available, much of
+the hugepage userspace interface has been duplicated in sysfs. The above
+information applies to the default hugepage size (which will be
+controlled by the proc interfaces for backwards compatibility). The root
+hugepage control directory is
+
+	/sys/kernel/mm/hugepages
+
+For each hugepage size supported by the running kernel, a subdirectory
+will exist, of the form
+
+	hugepages-${size}kB
+
+Inside each of these directories, the same set of files will exist:
+
+	nr_hugepages
+	nr_overcommit_hugepages
+	free_hugepages
+	resv_hugepages
+	surplus_hugepages
+
+which function as described above for the default hugepage-sized case.
+
 If the user applications are going to request hugepages using mmap system
 call, then it is required that system administrator mount a file system of
 type hugetlbfs:
diff -puN include/linux/hugetlb.h~hugetlb-new-sysfs-interface include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-new-sysfs-interface
+++ a/include/linux/hugetlb.h
@@ -164,6 +164,7 @@ unsigned long hugetlb_get_unmapped_area(
 
 #ifdef CONFIG_HUGETLB_PAGE
 
+#define HSTATE_NAME_LEN 32
 /* Defines one hugetlb page size */
 struct hstate {
 	int hugetlb_next_nid;
@@ -179,6 +180,7 @@ struct hstate {
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
+	char name[HSTATE_NAME_LEN];
 };
 
 void __init hugetlb_add_hstate(unsigned order);
diff -puN mm/hugetlb.c~hugetlb-new-sysfs-interface mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-new-sysfs-interface
+++ a/mm/hugetlb.c
@@ -14,6 +14,7 @@
 #include <linux/mempolicy.h>
 #include <linux/cpuset.h>
 #include <linux/mutex.h>
+#include <linux/sysfs.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -942,72 +943,6 @@ static void __init report_hugepages(void
 	}
 }
 
-static int __init hugetlb_init(void)
-{
-	BUILD_BUG_ON(HPAGE_SHIFT == 0);
-
-	if (!size_to_hstate(HPAGE_SIZE)) {
-		hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
-		parsed_hstate->max_huge_pages = default_hstate_max_huge_pages;
-	}
-	default_hstate_idx = size_to_hstate(HPAGE_SIZE) - hstates;
-
-	hugetlb_init_hstates();
-
-	report_hugepages();
-
-	return 0;
-}
-module_init(hugetlb_init);
-
-/* Should be called on processing a hugepagesz=... option */
-void __init hugetlb_add_hstate(unsigned order)
-{
-	struct hstate *h;
-	if (size_to_hstate(PAGE_SIZE << order)) {
-		printk(KERN_WARNING "hugepagesz= specified twice, ignoring\n");
-		return;
-	}
-	BUG_ON(max_hstate >= HUGE_MAX_HSTATE);
-	BUG_ON(order == 0);
-	h = &hstates[max_hstate++];
-	h->order = order;
-	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
-	hugetlb_init_one_hstate(h);
-	parsed_hstate = h;
-}
-
-static int __init hugetlb_setup(char *s)
-{
-	unsigned long *mhp;
-
-	/*
-	 * !max_hstate means we haven't parsed a hugepagesz= parameter yet,
-	 * so this hugepages= parameter goes to the "default hstate".
-	 */
-	if (!max_hstate)
-		mhp = &default_hstate_max_huge_pages;
-	else
-		mhp = &parsed_hstate->max_huge_pages;
-
-	if (sscanf(s, "%lu", mhp) <= 0)
-		*mhp = 0;
-
-	return 1;
-}
-__setup("hugepages=", hugetlb_setup);
-
-static unsigned int cpuset_mems_nr(unsigned int *array)
-{
-	int node;
-	unsigned int nr = 0;
-
-	for_each_node_mask(node, cpuset_current_mems_allowed)
-		nr += array[node];
-
-	return nr;
-}
-
 #ifdef CONFIG_SYSCTL
 #ifdef CONFIG_HIGHMEM
 static void try_to_free_low(struct hstate *h, unsigned long count)
@@ -1105,6 +1040,227 @@ out:
 	return ret;
 }
 
+#define HSTATE_ATTR_RO(_name) \
+	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
+
+#define HSTATE_ATTR(_name) \
+	static struct kobj_attribute _name##_attr = \
+		__ATTR(_name, 0644, _name##_show, _name##_store)
+
+static struct kobject *hugepages_kobj;
+static struct kobject *hstate_kobjs[HUGE_MAX_HSTATE];
+
+static struct hstate *kobj_to_hstate(struct kobject *kobj)
+{
+	int i;
+	for (i = 0; i < HUGE_MAX_HSTATE; i++)
+		if (hstate_kobjs[i] == kobj)
+			return &hstates[i];
+	BUG();
+	return NULL;
+}
+
+static ssize_t nr_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h = kobj_to_hstate(kobj);
+	return sprintf(buf, "%lu\n", h->nr_huge_pages);
+}
+static ssize_t nr_hugepages_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	int err;
+	unsigned long input;
+	struct hstate *h = kobj_to_hstate(kobj);
+
+	err = strict_strtoul(buf, 10, &input);
+	if (err)
+		return 0;
+
+	h->max_huge_pages = set_max_huge_pages(h, input);
+
+	return count;
+}
+HSTATE_ATTR(nr_hugepages);
+
+static ssize_t nr_overcommit_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h = kobj_to_hstate(kobj);
+	return sprintf(buf, "%lu\n", h->nr_overcommit_huge_pages);
+}
+static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	int err;
+	unsigned long input;
+	struct hstate *h = kobj_to_hstate(kobj);
+
+	err = strict_strtoul(buf, 10, &input);
+	if (err)
+		return 0;
+
+	spin_lock(&hugetlb_lock);
+	h->nr_overcommit_huge_pages = input;
+	spin_unlock(&hugetlb_lock);
+
+	return count;
+}
+HSTATE_ATTR(nr_overcommit_hugepages);
+
+static ssize_t free_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h = kobj_to_hstate(kobj);
+	return sprintf(buf, "%lu\n", h->free_huge_pages);
+}
+HSTATE_ATTR_RO(free_hugepages);
+
+static ssize_t resv_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h = kobj_to_hstate(kobj);
+	return sprintf(buf, "%lu\n", h->resv_huge_pages);
+}
+HSTATE_ATTR_RO(resv_hugepages);
+
+static ssize_t surplus_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h = kobj_to_hstate(kobj);
+	return sprintf(buf, "%lu\n", h->surplus_huge_pages);
+}
+HSTATE_ATTR_RO(surplus_hugepages);
+
+static struct attribute *hstate_attrs[] = {
+	&nr_hugepages_attr.attr,
+	&nr_overcommit_hugepages_attr.attr,
+	&free_hugepages_attr.attr,
+	&resv_hugepages_attr.attr,
+	&surplus_hugepages_attr.attr,
+	NULL,
+};
+
+static struct attribute_group hstate_attr_group = {
+	.attrs = hstate_attrs,
+};
+
+static int __init hugetlb_sysfs_add_hstate(struct hstate *h)
+{
+	int retval;
+
+	hstate_kobjs[h - hstates] = kobject_create_and_add(h->name,
+							hugepages_kobj);
+	if (!hstate_kobjs[h - hstates])
+		return -ENOMEM;
+
+	retval = sysfs_create_group(hstate_kobjs[h - hstates],
+							&hstate_attr_group);
+	if (retval)
+		kobject_put(hstate_kobjs[h - hstates]);
+
+	return retval;
+}
+
+static void __init hugetlb_sysfs_init(void)
+{
+	struct hstate *h;
+	int err;
+
+	hugepages_kobj = kobject_create_and_add("hugepages", mm_kobj);
+	if (!hugepages_kobj)
+		return;
+
+	for_each_hstate(h) {
+		err = hugetlb_sysfs_add_hstate(h);
+		if (err)
+			printk(KERN_ERR "Hugetlb: Unable to add hstate %s",
+								h->name);
+	}
+}
+
+static void __exit hugetlb_exit(void)
+{
+	struct hstate *h;
+
+	for_each_hstate(h) {
+		kobject_put(hstate_kobjs[h - hstates]);
+	}
+
+	kobject_put(hugepages_kobj);
+}
+module_exit(hugetlb_exit);
+
+static int __init hugetlb_init(void)
+{
+	BUILD_BUG_ON(HPAGE_SHIFT == 0);
+
+	if (!size_to_hstate(HPAGE_SIZE)) {
+		hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
+		parsed_hstate->max_huge_pages = default_hstate_max_huge_pages;
+	}
+	default_hstate_idx = size_to_hstate(HPAGE_SIZE) - hstates;
+
+	hugetlb_init_hstates();
+
+	report_hugepages();
+
+	hugetlb_sysfs_init();
+
+	return 0;
+}
+module_init(hugetlb_init);
+
+/* Should be called on processing a hugepagesz=... option */
+void __init hugetlb_add_hstate(unsigned order)
+{
+	struct hstate *h;
+	if (size_to_hstate(PAGE_SIZE << order)) {
+		printk(KERN_WARNING "hugepagesz= specified twice, ignoring\n");
+		return;
+	}
+	BUG_ON(max_hstate >= HUGE_MAX_HSTATE);
+	BUG_ON(order == 0);
+	h = &hstates[max_hstate++];
+	h->order = order;
+	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
+	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
+					huge_page_size(h)/1024);
+	hugetlb_init_one_hstate(h);
+	parsed_hstate = h;
+}
+
+static int __init hugetlb_setup(char *s)
+{
+	unsigned long *mhp;
+
+	/*
+	 * !max_hstate means we haven't parsed a hugepagesz= parameter yet,
+	 * so this hugepages= parameter goes to the "default hstate".
+	 */
+	if (!max_hstate)
+		mhp = &default_hstate_max_huge_pages;
+	else
+		mhp = &parsed_hstate->max_huge_pages;
+
+	if (sscanf(s, "%lu", mhp) <= 0)
+		*mhp = 0;
+
+	return 1;
+}
+__setup("hugepages=", hugetlb_setup);
+
+static unsigned int cpuset_mems_nr(unsigned int *array)
+{
+	int node;
+	unsigned int nr = 0;
+
+	for_each_node_mask(node, cpuset_current_mems_allowed)
+		nr += array[node];
+
+	return nr;
+}
+
 int hugetlb_sysctl_handler(struct ctl_table *table, int write,
 			   struct file *file, void __user *buffer,
 			   size_t *length, loff_t *ppos)
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-add_to_page_cache.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

