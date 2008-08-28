From: akpm@linux-foundation.org
Subject: + less-softirq-vectors.patch added to -mm tree
Date: Thu, 28 Aug 2008 16:57:09 -0700
Message-ID: <200808282357.m7SNv97E021030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbYH1X5b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 19:57:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, mingo@elte.hu


The patch titled
     Less softirq vectors
has been added to the -mm tree.  Its filename is
     less-softirq-vectors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Less softirq vectors
From: Alexey Dobriyan <adobriyan@gmail.com>

We don't need whole 32 of them, only NR_SOFTIRQS.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |    2 ++
 kernel/softirq.c          |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/interrupt.h~less-softirq-vectors include/linux/interrupt.h
--- a/include/linux/interrupt.h~less-softirq-vectors
+++ a/include/linux/interrupt.h
@@ -259,6 +259,8 @@ enum
 	HRTIMER_SOFTIRQ,
 #endif
 	RCU_SOFTIRQ, 	/* Preferable RCU should always be the last softirq */
+
+	NR_SOFTIRQS
 };
 
 /* softirq mask and active fields moved to irq_cpustat_t in
diff -puN kernel/softirq.c~less-softirq-vectors kernel/softirq.c
--- a/kernel/softirq.c~less-softirq-vectors
+++ a/kernel/softirq.c
@@ -46,7 +46,7 @@ irq_cpustat_t irq_stat[NR_CPUS] ____cach
 EXPORT_SYMBOL(irq_stat);
 #endif
 
-static struct softirq_action softirq_vec[32] __cacheline_aligned_in_smp;
+static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
 static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
less-softirq-vectors.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

