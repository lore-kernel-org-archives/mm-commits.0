Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE1C1A5B92;
	Fri, 30 May 2025 03:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748577122; cv=none; b=EaXhXjxOCdvP7GcAyEr4EqGLFgePUOFwTX9SMSY3BK9E4oWEqcRjZp2mjr/1tfG7mC8Ew4iadopfMzklUfI8vuWBFeGzXDvj8noMFcYpRJWB9wwjQODps1y5WuaCcedfDOTseiMpyfN7EVvwxeHYU9SUSJCffKSuXw/aGUNGsYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748577122; c=relaxed/simple;
	bh=spM6JsnmoLtFLrhGuQCpit0J4PYsI6I6kjIwP6pMzcg=;
	h=Date:To:From:Subject:Message-Id; b=U17zUWDyRrDpSbD4mxtxVLyx95jvNcy9SkcNtPD/x4wbybyJS6OIxR7vsNeIoZWPHoMKeHtuR8v/hJxG1WuQQxLiMOqzoiwJrkK21M5kCv6yZVv1KKi0VGKSy0nM5508BYXPderKEcoGgEbjMMHIwJ/nActXHw0wAw9hugHAGi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IUtY+nuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IUtY+nuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A24C4CEE9;
	Fri, 30 May 2025 03:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748577121;
	bh=spM6JsnmoLtFLrhGuQCpit0J4PYsI6I6kjIwP6pMzcg=;
	h=Date:To:From:Subject:From;
	b=IUtY+nuTQH6L0rV3FxVdrTQYgqyDAMihi/RgkzbnFyKEzZSGzOKeVblV9/Weeyx4/
	 Ccy3VzEpFO+wzrGOUpEdwLLeUhILSW+127JfPzzsUPW2LIUdDxihnMwBN83V5Jch83
	 5vpoQKRFQvgLAGGmmVOgzaIK43kVNoRhXBH3yPHg=
Date: Thu, 29 May 2025 20:52:00 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,aboorvad@linux.ibm.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-the-inaccurate-memory-statistics-issue-for-users.patch added to mm-hotfixes-unstable branch
Message-Id: <20250530035201.95A24C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix the inaccurate memory statistics issue for users
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-the-inaccurate-memory-statistics-issue-for-users.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-the-inaccurate-memory-statistics-issue-for-users.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: fix the inaccurate memory statistics issue for users
Date: Sat, 24 May 2025 09:59:53 +0800

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

Link: https://lkml.kernel.org/r/4f0fd51eb4f48c1a34226456b7a8b4ebff11bf72.1748051851.git.baolin.wang@linux.alibaba.com
Fixes: f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Tested-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -2708,6 +2708,11 @@ static inline unsigned long get_mm_count
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

mm-fix-the-inaccurate-memory-statistics-issue-for-users.patch

