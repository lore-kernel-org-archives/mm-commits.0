Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578D4446DB
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 21:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721854952; cv=none; b=DiMfNrNGJ93fimGa1Zw0T/mKELPYO9+eXIQrBrfEFQtHznWIDe8GRJvtq2KbLfh40jb9CFZAidjlDuGc90oJeVYK/lItonA5IB7jdoxb0o3Fsx5d4DfbsjVttK9wnJP71Jf1qvTPCu3TNLAvxgDAoXsO+Wqoe+B6UKuz0uByGRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721854952; c=relaxed/simple;
	bh=F9jDIho0TqVaPpIC+Wlv9XI71V/+O/THF083/gr/TYc=;
	h=Date:To:From:Subject:Message-Id; b=C6d9V08Ao6JwB9Hi/pYttX/Y5aLbTBxHbV7xS2SoPM1YYX0o2mbn5oDZ4xmHSgip29DrOrkclxKqLOlKcnoTvwPr3TR00tYctQE18Poe7Tr14tKiMb21U5f67fXjwSQJqZcChWfa0fsotNV1TMR025yJ2mL6wUzvuirTWLZJYS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tsawp3Ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tsawp3Ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDC2C32786;
	Wed, 24 Jul 2024 21:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721854950;
	bh=F9jDIho0TqVaPpIC+Wlv9XI71V/+O/THF083/gr/TYc=;
	h=Date:To:From:Subject:From;
	b=Tsawp3Ws2KoLX+FoVA7hamKMHcKclP3S2YEKObwDrXPELmEQMiXbSHEANZAsrzVSs
	 p4lYNU8Hqn5HBDcEqAoCH7E63nrVIBnfgYi3Tb2GAc76fb3tkXlPsfA+12GSqd1zIC
	 4k/FCyN+MmlCeuSl1W0UsitNODD6TI9Q3AITila0=
Date: Wed, 24 Jul 2024 14:02:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,peterz@infradead.org,nphamcs@gmail.com,lizhijian@fujitsu.com,kent.overstreet@linux.dev,cerasuolodomenico@gmail.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmstat-kernel-stack-usage-histogram.patch added to mm-unstable branch
Message-Id: <20240724210230.ACDC2C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmstat: kernel stack usage histogram
has been added to the -mm mm-unstable branch.  Its filename is
     vmstat-kernel-stack-usage-histogram.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmstat-kernel-stack-usage-histogram.patch

This patch will later appear in the mm-unstable branch at
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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: vmstat: kernel stack usage histogram
Date: Wed, 24 Jul 2024 20:33:21 +0000

As part of the dynamic kernel stack project, we need to know the amount of
data that can be saved by reducing the default kernel stack size [1].

Provide a kernel stack usage histogram to aid in optimizing kernel stack
sizes and minimizing memory waste in large-scale environments.  The
histogram divides stack usage into power-of-two buckets and reports the
results in /proc/vmstat.  This information is especially valuable in
environments with millions of machines, where even small optimizations can
have a significant impact.

The histogram data is presented in /proc/vmstat with entries like
"kstack_1k", "kstack_2k", and so on, indicating the number of threads that
exited with stack usage falling within each respective bucket.

Example outputs:
Intel:
$ grep kstack /proc/vmstat
kstack_1k 3
kstack_2k 188
kstack_4k 11391
kstack_8k 243
kstack_16k 0

ARM with 64K page_size:
$ grep kstack /proc/vmstat
kstack_1k 1
kstack_2k 340
kstack_4k 25212
kstack_8k 1659
kstack_16k 0
kstack_32k 0
kstack_64k 0

Note: once the dynamic kernel stack is implemented it will depend on the
implementation the usability of this feature: On hardware that supports
faults on kernel stacks, we will have other metrics that show the total
number of pages allocated for stacks.  On hardware where faults are not
supported, we will most likely have some optimization where only some
threads are extended, and for those, these metrics will still be very
useful.

[1] https://lwn.net/Articles/974367

Link: https://lkml.kernel.org/r/20240724203322.2765486-3-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Kent Overstreet <kent.overstreet@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |   24 ++++++++++++++++++++
 kernel/exit.c                 |   38 ++++++++++++++++++++++++++++++++
 mm/vmstat.c                   |   24 ++++++++++++++++++++
 3 files changed, 86 insertions(+)

--- a/include/linux/vm_event_item.h~vmstat-kernel-stack-usage-histogram
+++ a/include/linux/vm_event_item.h
@@ -155,6 +155,30 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		VMA_LOCK_RETRY,
 		VMA_LOCK_MISS,
 #endif
+#ifdef CONFIG_DEBUG_STACK_USAGE
+		KSTACK_1K,
+#if THREAD_SIZE > 1024
+		KSTACK_2K,
+#endif
+#if THREAD_SIZE > 2048
+		KSTACK_4K,
+#endif
+#if THREAD_SIZE > 4096
+		KSTACK_8K,
+#endif
+#if THREAD_SIZE > 8192
+		KSTACK_16K,
+#endif
+#if THREAD_SIZE > 16384
+		KSTACK_32K,
+#endif
+#if THREAD_SIZE > 32768
+		KSTACK_64K,
+#endif
+#if THREAD_SIZE > 65536
+		KSTACK_REST,
+#endif
+#endif /* CONFIG_DEBUG_STACK_USAGE */
 		NR_VM_EVENT_ITEMS
 };
 
--- a/kernel/exit.c~vmstat-kernel-stack-usage-histogram
+++ a/kernel/exit.c
@@ -778,6 +778,43 @@ static void exit_notify(struct task_stru
 }
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
+/* Count the maximum pages reached in kernel stacks */
+static inline void kstack_histogram(unsigned long used_stack)
+{
+#ifdef CONFIG_VM_EVENT_COUNTERS
+	if (used_stack <= 1024)
+		count_vm_event(KSTACK_1K);
+#if THREAD_SIZE > 1024
+	else if (used_stack <= 2048)
+		count_vm_event(KSTACK_2K);
+#endif
+#if THREAD_SIZE > 2048
+	else if (used_stack <= 4096)
+		count_vm_event(KSTACK_4K);
+#endif
+#if THREAD_SIZE > 4096
+	else if (used_stack <= 8192)
+		count_vm_event(KSTACK_8K);
+#endif
+#if THREAD_SIZE > 8192
+	else if (used_stack <= 16384)
+		count_vm_event(KSTACK_16K);
+#endif
+#if THREAD_SIZE > 16384
+	else if (used_stack <= 32768)
+		count_vm_event(KSTACK_32K);
+#endif
+#if THREAD_SIZE > 32768
+	else if (used_stack <= 65536)
+		count_vm_event(KSTACK_64K);
+#endif
+#if THREAD_SIZE > 65536
+	else
+		count_vm_event(KSTACK_REST);
+#endif
+#endif /* CONFIG_VM_EVENT_COUNTERS */
+}
+
 static void check_stack_usage(void)
 {
 	static DEFINE_SPINLOCK(low_water_lock);
@@ -785,6 +822,7 @@ static void check_stack_usage(void)
 	unsigned long free;
 
 	free = stack_not_used(current);
+	kstack_histogram(THREAD_SIZE - free);
 
 	if (free >= lowest_to_date)
 		return;
--- a/mm/vmstat.c~vmstat-kernel-stack-usage-histogram
+++ a/mm/vmstat.c
@@ -1418,6 +1418,30 @@ const char * const vmstat_text[] = {
 	"vma_lock_retry",
 	"vma_lock_miss",
 #endif
+#ifdef CONFIG_DEBUG_STACK_USAGE
+	"kstack_1k",
+#if THREAD_SIZE > 1024
+	"kstack_2k",
+#endif
+#if THREAD_SIZE > 2048
+	"kstack_4k",
+#endif
+#if THREAD_SIZE > 4096
+	"kstack_8k",
+#endif
+#if THREAD_SIZE > 8192
+	"kstack_16k",
+#endif
+#if THREAD_SIZE > 16384
+	"kstack_32k",
+#endif
+#if THREAD_SIZE > 32768
+	"kstack_64k",
+#endif
+#if THREAD_SIZE > 65536
+	"kstack_rest",
+#endif
+#endif
 #endif /* CONFIG_VM_EVENT_COUNTERS || CONFIG_MEMCG */
 };
 #endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA || CONFIG_MEMCG */
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

vmstat-kernel-stack-usage-histogram.patch
task_stack-uninline-stack_not_used.patch

