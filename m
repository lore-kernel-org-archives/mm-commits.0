From: akpm@linux-foundation.org
Subject: + perf-allocate-mmap-buffer-using-vmalloc_user.patch added to -mm tree
Date: Thu, 10 Sep 2009 14:31:55 -0700
Message-ID: <200909102131.n8ALVu9X031511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320AbZIJVcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Sep 2009 17:32:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, a.p.zijlstra@chello.nl, jens.axboe@oracle.com, mingo@elte.hu, nickpiggin@yahoo.com.au


The patch titled
     perf: allocate mmap buffer using vmalloc_user()
has been added to the -mm tree.  Its filename is
     perf-allocate-mmap-buffer-using-vmalloc_user.patch

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
Subject: perf: allocate mmap buffer using vmalloc_user()
From: David Miller <davem@davemloft.net>

This is necessary to make the mmap ring buffer work properly on platforms
where D-cache aliasing is an issue.

vmalloc_user() ensures that the kernel side mapping is SHMLBA aligned, and
on platforms with D-cache aliasing matters the presence of VM_SHARED will
similarly SHMLBA align the user side mapping.

Thus the kernel and the user will be writing to the same D-cache aliases
and we'll avoid inconsistencies and corruption.

The only trick with this change is that vfree() cannot be invoked from
interrupt context, and thus it's not allowed from RCU callbacks.

We deal with this by using schedule_work().

Since the ring buffer is now completely linear even on the kernel side,
several simplifications are probably now possible in the code where we add
entries to the ring.

With help from Peter Zijlstra.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/perf_counter.h |    1 
 kernel/perf_counter.c        |   72 +++++++++++++++++----------------
 2 files changed, 40 insertions(+), 33 deletions(-)

diff -puN include/linux/perf_counter.h~perf-allocate-mmap-buffer-using-vmalloc_user include/linux/perf_counter.h
--- a/include/linux/perf_counter.h~perf-allocate-mmap-buffer-using-vmalloc_user
+++ a/include/linux/perf_counter.h
@@ -507,6 +507,7 @@ struct file;
 
 struct perf_mmap_data {
 	struct rcu_head			rcu_head;
+	struct work_struct		work;
 	int				nr_pages;	/* nr of data pages  */
 	int				writable;	/* are we writable   */
 	int				nr_locked;	/* nr pages mlocked  */
diff -puN kernel/perf_counter.c~perf-allocate-mmap-buffer-using-vmalloc_user kernel/perf_counter.c
--- a/kernel/perf_counter.c~perf-allocate-mmap-buffer-using-vmalloc_user
+++ a/kernel/perf_counter.c
@@ -23,6 +23,7 @@
 #include <linux/hardirq.h>
 #include <linux/rculist.h>
 #include <linux/uaccess.h>
+#include <linux/vmalloc.h>
 #include <linux/syscalls.h>
 #include <linux/anon_inodes.h>
 #include <linux/kernel_stat.h>
@@ -2118,7 +2119,7 @@ static int perf_mmap_fault(struct vm_are
 		goto unlock;
 
 	if (vmf->pgoff == 0) {
-		vmf->page = virt_to_page(data->user_page);
+		vmf->page = vmalloc_to_page(data->user_page);
 	} else {
 		int nr = vmf->pgoff - 1;
 
@@ -2128,7 +2129,7 @@ static int perf_mmap_fault(struct vm_are
 		if (vmf->flags & FAULT_FLAG_WRITE)
 			goto unlock;
 
-		vmf->page = virt_to_page(data->data_pages[nr]);
+		vmf->page = vmalloc_to_page(data->data_pages[nr]);
 	}
 
 	get_page(vmf->page);
@@ -2142,10 +2143,34 @@ unlock:
 	return ret;
 }
 
+static void perf_mmap_unmark_page(void *addr)
+{
+	struct page *page = vmalloc_to_page(addr);
+
+	page->mapping = NULL;
+}
+
+static void perf_mmap_data_free_work(struct work_struct *work)
+{
+	struct perf_mmap_data *data;
+	void *base;
+	int i;
+
+	data = container_of(work, struct perf_mmap_data, work);
+
+	base = data->user_page;
+	for (i = 0; i < data->nr_pages + 1; i++)
+		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
+
+	vfree(base);
+	kfree(data);
+}
+
 static int perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages)
 {
 	struct perf_mmap_data *data;
 	unsigned long size;
+	void *all_buf;
 	int i;
 
 	WARN_ON(atomic_read(&counter->mmap_count));
@@ -2157,15 +2182,16 @@ static int perf_mmap_data_alloc(struct p
 	if (!data)
 		goto fail;
 
-	data->user_page = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!data->user_page)
-		goto fail_user_page;
-
-	for (i = 0; i < nr_pages; i++) {
-		data->data_pages[i] = (void *)get_zeroed_page(GFP_KERNEL);
-		if (!data->data_pages[i])
-			goto fail_data_pages;
-	}
+	INIT_WORK(&data->work, perf_mmap_data_free_work);
+
+	all_buf = vmalloc_user((nr_pages + 1) * PAGE_SIZE);
+	if (!all_buf)
+		goto fail_all_buf;
+
+	data->user_page = all_buf;
+
+	for (i = 0; i < nr_pages; i++)
+		data->data_pages[i] = all_buf + ((i + 1) * PAGE_SIZE);
 
 	data->nr_pages = nr_pages;
 	atomic_set(&data->lock, -1);
@@ -2174,39 +2200,19 @@ static int perf_mmap_data_alloc(struct p
 
 	return 0;
 
-fail_data_pages:
-	for (i--; i >= 0; i--)
-		free_page((unsigned long)data->data_pages[i]);
-
-	free_page((unsigned long)data->user_page);
-
-fail_user_page:
+fail_all_buf:
 	kfree(data);
 
 fail:
 	return -ENOMEM;
 }
 
-static void perf_mmap_free_page(unsigned long addr)
-{
-	struct page *page = virt_to_page((void *)addr);
-
-	page->mapping = NULL;
-	__free_page(page);
-}
-
 static void __perf_mmap_data_free(struct rcu_head *rcu_head)
 {
 	struct perf_mmap_data *data;
-	int i;
 
 	data = container_of(rcu_head, struct perf_mmap_data, rcu_head);
-
-	perf_mmap_free_page((unsigned long)data->user_page);
-	for (i = 0; i < data->nr_pages; i++)
-		perf_mmap_free_page((unsigned long)data->data_pages[i]);
-
-	kfree(data);
+	schedule_work(&data->work);
 }
 
 static void perf_mmap_data_free(struct perf_counter *counter)
_

Patches currently in -mm which might be from davem@davemloft.net are

linux-next.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
ide-use-printk_once.patch
sunrpc-use-formatting-of-module-name-in-sunrpc.patch
sparc32-convert-to-asm-generic-hardirqh.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
mm-make-vmalloc_user-align-base-kernel-virtual-address-to-shmlba.patch
perf-allocate-mmap-buffer-using-vmalloc_user.patch
move-magic-numbers-into-magich.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch
maintainers-add-ipvs-include-files.patch
scripts-get_maintainerpl-add-pattern-depth.patch
kprobes-use-do_irq-in-lkdtm.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
sound-core-pcm_timerc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch

