Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68411221273;
	Thu, 10 Jul 2025 04:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120564; cv=none; b=bJ/qhOZroU9ve6hZKMhX0kzlf/Dha7GjRNj8nR13BiHJFwLCEhIgga2y5tAGFGD05Xt7foTFWv/JG0l8O9HWFmIhA6Wn+8O1CKWa0g9FFob7lk5Rd/UfX5DXV9U7oWFA17Q2Zm92ojVX3cUz+ZlXZ1WOGZ3mpfFkAhBCc7p3JkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120564; c=relaxed/simple;
	bh=X7odLtwWvTE5dVI69aloxdhWBOIUz837pkbmb+BKzTY=;
	h=Date:To:From:Subject:Message-Id; b=memZ0FKKkigiqr2sTpkktHYK15pqnSY7JOgdgbtyN8moetEDvnVIDdIHVN6y6nDOUXr8EAmGRXchIc4O0oz7uA01Pgp1m9qJFG0HsDPCy4XFHoGLqecaMvHPaQwzm3XGrILTHFjaWIr0JIe4hvlks+RjBhu67Ml6+i+IzC47Dfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CkC+4vBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CkC+4vBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F161C4CEE3;
	Thu, 10 Jul 2025 04:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120564;
	bh=X7odLtwWvTE5dVI69aloxdhWBOIUz837pkbmb+BKzTY=;
	h=Date:To:From:Subject:From;
	b=CkC+4vBxMZ9IgaPO5fydQAQI86AYcGIqfQxhOWJgXhnPfnkBl/gD0TrRFX9I00Qb+
	 fU81JcjOudgdmywugFeQraSkK1nOxI1QU79L1AWlEb/ZoAGZUNKgjAkqQbi2pNAqTv
	 lgfLXIbEzG2yFqzP3QM5k0keNs4MQH8KHHxyfY+k=
Date: Wed, 09 Jul 2025 21:09:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,aboorvad@linux.ibm.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-the-inaccurate-memory-statistics-issue-for-users.patch removed from -mm tree
Message-Id: <20250710040924.3F161C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix the inaccurate memory statistics issue for users
has been removed from the -mm tree.  Its filename was
     mm-fix-the-inaccurate-memory-statistics-issue-for-users.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: fix the inaccurate memory statistics issue for users
Date: Thu, 5 Jun 2025 20:58:29 +0800

On some large machines with a high number of CPUs running a 64K pagesize
kernel, we found that the 'RES' field is always 0 displayed by the top
command for some processes, which will cause a lot of confusion for users.

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
 875525 root      20   0   12480      0      0 R   0.3   0.0   0:00.08 top
      1 root      20   0  172800      0      0 S   0.0   0.0   0:04.52 systemd

The main reason is that the batch size of the percpu counter is quite
large on these machines, caching a significant percpu value, since
converting mm's rss stats into percpu_counter by commit f1a7941243c1 ("mm:
convert mm's rss stats into percpu_counter").  Intuitively, the batch
number should be optimized, but on some paths, performance may take
precedence over statistical accuracy.  Therefore, introducing a new
interface to add the percpu statistical count and display it to users,
which can remove the confusion.  In addition, this change is not expected
to be on a performance-critical path, so the modification should be
acceptable.

In addition, the 'mm->rss_stat' is updated by using add_mm_counter() and
dec/inc_mm_counter(), which are all wrappers around
percpu_counter_add_batch().  In percpu_counter_add_batch(), there is
percpu batch caching to avoid 'fbc->lock' contention.  This patch changes
task_mem() and task_statm() to get the accurate mm counters under the
'fbc->lock', but this should not exacerbate kernel 'mm->rss_stat' lock
contention due to the percpu batch caching of the mm counters.  The
following test also confirm the theoretical analysis.

I run the stress-ng that stresses anon page faults in 32 threads on my 32
cores machine, while simultaneously running a script that starts 32
threads to busy-loop pread each stress-ng thread's /proc/pid/status
interface.  From the following data, I did not observe any obvious impact
of this patch on the stress-ng tests.

w/o patch:
stress-ng: info:  [6848]          4,399,219,085,152 CPU Cycles          67.327 B/sec
stress-ng: info:  [6848]          1,616,524,844,832 Instructions          24.740 B/sec (0.367 instr. per cycle)
stress-ng: info:  [6848]          39,529,792 Page Faults Total           0.605 M/sec
stress-ng: info:  [6848]          39,529,792 Page Faults Minor           0.605 M/sec

w/patch:
stress-ng: info:  [2485]          4,462,440,381,856 CPU Cycles          68.382 B/sec
stress-ng: info:  [2485]          1,615,101,503,296 Instructions          24.750 B/sec (0.362 instr. per cycle)
stress-ng: info:  [2485]          39,439,232 Page Faults Total           0.604 M/sec
stress-ng: info:  [2485]          39,439,232 Page Faults Minor           0.604 M/sec

On comparing a very simple app which just allocates & touches some
memory against v6.1 (which doesn't have f1a7941243c1) and latest Linus
tree (4c06e63b9203) I can see that on latest Linus tree the values for
VmRSS, RssAnon and RssFile from /proc/self/status are all zeroes while
they do report values on v6.1 and a Linus tree with this patch.

Link: https://lkml.kernel.org/r/f4586b17f66f97c174f7fd1f8647374fdb53de1c.1749119050.git.baolin.wang@linux.alibaba.com
Fixes: f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Tested-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Tested-by Donet Tom <donettom@linux.ibm.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   14 +++++++-------
 include/linux/mm.h |    5 +++++
 2 files changed, 12 insertions(+), 7 deletions(-)

--- a/fs/proc/task_mmu.c~mm-fix-the-inaccurate-memory-statistics-issue-for-users
+++ a/fs/proc/task_mmu.c
@@ -36,9 +36,9 @@ void task_mem(struct seq_file *m, struct
 	unsigned long text, lib, swap, anon, file, shmem;
 	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
 
-	anon = get_mm_counter(mm, MM_ANONPAGES);
-	file = get_mm_counter(mm, MM_FILEPAGES);
-	shmem = get_mm_counter(mm, MM_SHMEMPAGES);
+	anon = get_mm_counter_sum(mm, MM_ANONPAGES);
+	file = get_mm_counter_sum(mm, MM_FILEPAGES);
+	shmem = get_mm_counter_sum(mm, MM_SHMEMPAGES);
 
 	/*
 	 * Note: to minimize their overhead, mm maintains hiwater_vm and
@@ -59,7 +59,7 @@ void task_mem(struct seq_file *m, struct
 	text = min(text, mm->exec_vm << PAGE_SHIFT);
 	lib = (mm->exec_vm << PAGE_SHIFT) - text;
 
-	swap = get_mm_counter(mm, MM_SWAPENTS);
+	swap = get_mm_counter_sum(mm, MM_SWAPENTS);
 	SEQ_PUT_DEC("VmPeak:\t", hiwater_vm);
 	SEQ_PUT_DEC(" kB\nVmSize:\t", total_vm);
 	SEQ_PUT_DEC(" kB\nVmLck:\t", mm->locked_vm);
@@ -92,12 +92,12 @@ unsigned long task_statm(struct mm_struc
 			 unsigned long *shared, unsigned long *text,
 			 unsigned long *data, unsigned long *resident)
 {
-	*shared = get_mm_counter(mm, MM_FILEPAGES) +
-			get_mm_counter(mm, MM_SHMEMPAGES);
+	*shared = get_mm_counter_sum(mm, MM_FILEPAGES) +
+			get_mm_counter_sum(mm, MM_SHMEMPAGES);
 	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
 								>> PAGE_SHIFT;
 	*data = mm->data_vm + mm->stack_vm;
-	*resident = *shared + get_mm_counter(mm, MM_ANONPAGES);
+	*resident = *shared + get_mm_counter_sum(mm, MM_ANONPAGES);
 	return mm->total_vm;
 }
 
--- a/include/linux/mm.h~mm-fix-the-inaccurate-memory-statistics-issue-for-users
+++ a/include/linux/mm.h
@@ -2568,6 +2568,11 @@ static inline unsigned long get_mm_count
 	return percpu_counter_read_positive(&mm->rss_stat[member]);
 }
 
+static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
+{
+	return percpu_counter_sum_positive(&mm->rss_stat[member]);
+}
+
 void mm_trace_rss_stat(struct mm_struct *mm, int member);
 
 static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

selftests-khugepaged-fix-the-shmem-collapse-failure.patch
selftests-mm-add-shmem-collapse-as-a-default-test-item.patch
mm-huge_memory-fix-the-check-for-allowed-huge-orders-in-shmem.patch
khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch
khugepaged-kick-khugepaged-for-enabling-none-pmd-sized-mthps.patch
mm-fault-in-complete-folios-instead-of-individual-pages-for-tmpfs.patch

