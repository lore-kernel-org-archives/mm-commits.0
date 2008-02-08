From: akpm@linux-foundation.org
Subject: - memory-controller-improve-user-interface.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:03:15 -0800
Message-ID: <200802080802.m1882umK014077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758504AbYBHI21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:28:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     Memory controller improve user interface 
has been removed from the -mm tree.  Its filename was
     memory-controller-improve-user-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Memory controller improve user interface 
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Change the interface to use bytes instead of pages.  Page sizes can vary
across platforms and configurations.  A new strategy routine has been added
to the resource counters infrastructure to format the data as desired.

Suggested by David Rientjes, Andrew Morton and Herbert Poetzl

Tested on a UML setup with the config for memory control enabled.

[kamezawa.hiroyu@jp.fujitsu.com: possible race fix in res_counter]
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: David Rientjes <rientjes@google.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memory.txt |   29 ++++++++++++++++----
 include/linux/res_counter.h          |   12 ++++----
 kernel/res_counter.c                 |   36 +++++++++++++++++--------
 mm/memcontrol.c                      |   35 +++++++++++++++++-------
 4 files changed, 81 insertions(+), 31 deletions(-)

diff -puN Documentation/controllers/memory.txt~memory-controller-improve-user-interface Documentation/controllers/memory.txt
--- a/Documentation/controllers/memory.txt~memory-controller-improve-user-interface
+++ a/Documentation/controllers/memory.txt
@@ -165,11 +165,30 @@ c. Enable CONFIG_CGROUP_MEM_CONT
 
 Since now we're in the 0 cgroup,
 We can alter the memory limit:
-# echo -n 6000 > /cgroups/0/memory.limit
+# echo -n 4M > /cgroups/0/memory.limit_in_bytes
+
+NOTE: We can use a suffix (k, K, m, M, g or G) to indicate values in kilo,
+mega or gigabytes.
+
+# cat /cgroups/0/memory.limit_in_bytes
+4194304 Bytes
+
+NOTE: The interface has now changed to display the usage in bytes
+instead of pages
 
 We can check the usage:
-# cat /cgroups/0/memory.usage
-25
+# cat /cgroups/0/memory.usage_in_bytes
+1216512 Bytes
+
+A successful write to this file does not guarantee a successful set of
+this limit to the value written into the file.  This can be due to a
+number of factors, such as rounding up to page boundaries or the total
+availability of memory on the system.  The user is required to re-read
+this file after a write to guarantee the value committed by the kernel.
+
+# echo -n 1 > memory.limit_in_bytes
+# cat memory.limit_in_bytes
+4096 Bytes
 
 The memory.failcnt field gives the number of times that the cgroup limit was
 exceeded.
@@ -206,8 +225,8 @@ cgroup might have some charge associated
 tasks have migrated away from it. If some pages are still left, after following
 the steps listed in sections 4.1 and 4.2, check the Swap Cache usage in
 /proc/meminfo to see if the Swap Cache usage is showing up in the
-cgroups memory.usage counter. A simple test of swapoff -a and swapon -a
-should free any pending Swap Cache usage.
+cgroups memory.usage_in_bytes counter. A simple test of swapoff -a and
+swapon -a should free any pending Swap Cache usage.
 
 4.4 Choosing what to account  -- Page Cache (unmapped) vs RSS (mapped)?
 
diff -puN include/linux/res_counter.h~memory-controller-improve-user-interface include/linux/res_counter.h
--- a/include/linux/res_counter.h~memory-controller-improve-user-interface
+++ a/include/linux/res_counter.h
@@ -23,15 +23,15 @@ struct res_counter {
 	/*
 	 * the current resource consumption level
 	 */
-	unsigned long usage;
+	unsigned long long usage;
 	/*
 	 * the limit that usage cannot exceed
 	 */
-	unsigned long limit;
+	unsigned long long limit;
 	/*
 	 * the number of unsuccessful attempts to consume the resource
 	 */
-	unsigned long failcnt;
+	unsigned long long failcnt;
 	/*
 	 * the lock to protect all of the above.
 	 * the routines below consider this to be IRQ-safe
@@ -52,9 +52,11 @@ struct res_counter {
  */
 
 ssize_t res_counter_read(struct res_counter *counter, int member,
-		const char __user *buf, size_t nbytes, loff_t *pos);
+		const char __user *buf, size_t nbytes, loff_t *pos,
+		int (*read_strategy)(unsigned long long val, char *s));
 ssize_t res_counter_write(struct res_counter *counter, int member,
-		const char __user *buf, size_t nbytes, loff_t *pos);
+		const char __user *buf, size_t nbytes, loff_t *pos,
+		int (*write_strategy)(char *buf, unsigned long long *val));
 
 /*
  * the field descriptors. one for each member of res_counter
diff -puN kernel/res_counter.c~memory-controller-improve-user-interface kernel/res_counter.c
--- a/kernel/res_counter.c~memory-controller-improve-user-interface
+++ a/kernel/res_counter.c
@@ -16,7 +16,7 @@
 void res_counter_init(struct res_counter *counter)
 {
 	spin_lock_init(&counter->lock);
-	counter->limit = (unsigned long)LONG_MAX;
+	counter->limit = (unsigned long long)LLONG_MAX;
 }
 
 int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
@@ -59,8 +59,8 @@ void res_counter_uncharge(struct res_cou
 }
 
 
-static inline unsigned long *res_counter_member(struct res_counter *counter,
-						int member)
+static inline unsigned long long *
+res_counter_member(struct res_counter *counter, int member)
 {
 	switch (member) {
 	case RES_USAGE:
@@ -76,24 +76,30 @@ static inline unsigned long *res_counter
 }
 
 ssize_t res_counter_read(struct res_counter *counter, int member,
-		const char __user *userbuf, size_t nbytes, loff_t *pos)
+		const char __user *userbuf, size_t nbytes, loff_t *pos,
+		int (*read_strategy)(unsigned long long val, char *st_buf))
 {
-	unsigned long *val;
+	unsigned long long *val;
 	char buf[64], *s;
 
 	s = buf;
 	val = res_counter_member(counter, member);
-	s += sprintf(s, "%lu\n", *val);
+	if (read_strategy)
+		s += read_strategy(*val, s);
+	else
+		s += sprintf(s, "%llu\n", *val);
 	return simple_read_from_buffer((void __user *)userbuf, nbytes,
 			pos, buf, s - buf);
 }
 
 ssize_t res_counter_write(struct res_counter *counter, int member,
-		const char __user *userbuf, size_t nbytes, loff_t *pos)
+		const char __user *userbuf, size_t nbytes, loff_t *pos,
+		int (*write_strategy)(char *st_buf, unsigned long long *val))
 {
 	int ret;
 	char *buf, *end;
-	unsigned long tmp, *val;
+	unsigned long flags;
+	unsigned long long tmp, *val;
 
 	buf = kmalloc(nbytes + 1, GFP_KERNEL);
 	ret = -ENOMEM;
@@ -106,12 +112,20 @@ ssize_t res_counter_write(struct res_cou
 		goto out_free;
 
 	ret = -EINVAL;
-	tmp = simple_strtoul(buf, &end, 10);
-	if (*end != '\0')
-		goto out_free;
 
+	if (write_strategy) {
+		if (write_strategy(buf, &tmp)) {
+			goto out_free;
+		}
+	} else {
+		tmp = simple_strtoull(buf, &end, 10);
+		if (*end != '\0')
+			goto out_free;
+	}
+	spin_lock_irqsave(&counter->lock, flags);
 	val = res_counter_member(counter, member);
 	*val = tmp;
+	spin_unlock_irqrestore(&counter->lock, flags);
 	ret = nbytes;
 out_free:
 	kfree(buf);
diff -puN mm/memcontrol.c~memory-controller-improve-user-interface mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-improve-user-interface
+++ a/mm/memcontrol.c
@@ -302,7 +302,7 @@ retry:
 	 * If we created the page_cgroup, we should free it on exceeding
 	 * the cgroup limit.
 	 */
-	while (res_counter_charge(&mem->res, 1)) {
+	while (res_counter_charge(&mem->res, PAGE_SIZE)) {
 		if (try_to_free_mem_cgroup_pages(mem))
 			continue;
 
@@ -341,7 +341,7 @@ retry:
 		kfree(pc);
 		pc = race_pc;
 		atomic_inc(&pc->ref_cnt);
-		res_counter_uncharge(&mem->res, 1);
+		res_counter_uncharge(&mem->res, PAGE_SIZE);
 		css_put(&mem->css);
 		goto done;
 	}
@@ -384,7 +384,7 @@ void mem_cgroup_uncharge(struct page_cgr
 		css_put(&mem->css);
 		page_assign_page_cgroup(page, NULL);
 		unlock_page_cgroup(page);
-		res_counter_uncharge(&mem->res, 1);
+		res_counter_uncharge(&mem->res, PAGE_SIZE);
 
  		spin_lock_irqsave(&mem->lru_lock, flags);
  		list_del_init(&pc->lru);
@@ -393,12 +393,26 @@ void mem_cgroup_uncharge(struct page_cgr
 	}
 }
 
-static ssize_t mem_cgroup_read(struct cgroup *cont, struct cftype *cft,
-			struct file *file, char __user *userbuf, size_t nbytes,
-			loff_t *ppos)
+int mem_cgroup_write_strategy(char *buf, unsigned long long *tmp)
+{
+	*tmp = memparse(buf, &buf);
+	if (*buf != '\0')
+		return -EINVAL;
+
+	/*
+	 * Round up the value to the closest page size
+	 */
+	*tmp = ((*tmp + PAGE_SIZE - 1) >> PAGE_SHIFT) << PAGE_SHIFT;
+	return 0;
+}
+
+static ssize_t mem_cgroup_read(struct cgroup *cont,
+			struct cftype *cft, struct file *file,
+			char __user *userbuf, size_t nbytes, loff_t *ppos)
 {
 	return res_counter_read(&mem_cgroup_from_cont(cont)->res,
-				cft->private, userbuf, nbytes, ppos);
+				cft->private, userbuf, nbytes, ppos,
+				NULL);
 }
 
 static ssize_t mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
@@ -406,17 +420,18 @@ static ssize_t mem_cgroup_write(struct c
 				size_t nbytes, loff_t *ppos)
 {
 	return res_counter_write(&mem_cgroup_from_cont(cont)->res,
-				cft->private, userbuf, nbytes, ppos);
+				cft->private, userbuf, nbytes, ppos,
+				mem_cgroup_write_strategy);
 }
 
 static struct cftype mem_cgroup_files[] = {
 	{
-		.name = "usage",
+		.name = "usage_in_bytes",
 		.private = RES_USAGE,
 		.read = mem_cgroup_read,
 	},
 	{
-		.name = "limit",
+		.name = "limit_in_bytes",
 		.private = RES_LIMIT,
 		.write = mem_cgroup_write,
 		.read = mem_cgroup_read,
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
getdelays-fix-gcc-warnings.patch
