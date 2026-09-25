Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F72D4137A1;
	Fri, 25 Sep 2026 05:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313934; cv=none; b=hSo2g55cr6CqXWQW7ZOVipybyS2KQyktM+Lqebmifnvb1Xer62zskfmE1mmzZaMXsT1j7Ns/JElRaeX6hbnb6dVOOQEucQyimDtDLIrr+AQhWXpAsuAMesJ06dofDBkc6j4uNqW8Z8/cqKBuCBtVPjQBsGX74kxmjT3imb43vFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313934; c=relaxed/simple;
	bh=8yIYAloJhsj6APeeyij6SLEY+Bleic8cLRqnrJJAFoE=;
	h=Date:To:From:Subject:Message-Id; b=VBYdlo3KT2VEK9ftFr779+nq6q2DZwPpiHlIO1DT6bmlmmtNw25ZoUaH4pz+7hTY4xjJOW7k9C0hXIwVjrIz7HYEQb+9tJUAVjCvR5dNrdiLphCZnWNaj4X/pLPjGvSU3acFAZTTED6vdOUHmQGsdHe7lsEUg+UPbRK3v3xRhRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WBDzMMmg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WBDzMMmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7961F000FF;
	Fri, 25 Sep 2026 05:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790313932;
	bh=bsP5ecIt1PtAv8g9LwbVVlaL4CBxqhj5muOKFhuu83Q=;
	h=Date:To:From:Subject;
	b=WBDzMMmgYfGKBsIxjSnsiKDVbjaGmqpArJaAYDf0YgRQ6ON1jEnsbtuHeSC6R5UtH
	 Kwu/ixKqtzGx6pgLc3evVvBUBb2TCIBEQh06mPEERqNZC/OozKk1wZGq7KVedj0gX2
	 SQ9Hue20q0cRrvalSH0vTqS7puSdJDMyxdZZrST8=
Date: Thu, 24 Sep 2026 22:25:32 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,rostedt@goodmis.org,mingo@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jgg@ziepe.ca,david@kernel.org,dave.hansen@linux.intel.com,baolu.lu@linux.intel.com,akpm@linux-foundation.org,mikhail.v.gavrilov@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-schedule-deferred-kernel-page-table-freeing-while-booting.patch added to mm-hotfixes-unstable branch
Message-Id: <20260925052532.8A7961F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: don't schedule deferred kernel page table freeing while booting
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-dont-schedule-deferred-kernel-page-table-freeing-while-booting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dont-schedule-deferred-kernel-page-table-freeing-while-booting.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: mm: don't schedule deferred kernel page table freeing while booting
Date: Fri, 25 Sep 2026 10:06:47 +0500

Booting with a boot-time function tracer and a filter, for example

  ftrace=function ftrace_filter=pud_free_pmd_page

panics on 7.3-rc4 as soon as the tracer starts:

  [   23.531178] Starting tracer 'function'
  [   23.675800] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000038: 0000 [#1] SMP KASAN NOPTI
  [   23.819917] KASAN: null-ptr-deref in range [0x00000000000001c0-0x00000000000001c7]
  [   23.964025] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.3.0-rc4-fe2ec83746e5-with-fixes-v2+ #195 PREEMPT(undef)
  [   24.252248] RIP: 0010:__queue_work+0xab/0xf00
  [   25.981629] Call Trace:
  [   26.125727]  <TASK>
  [   26.413912]  ? pagetable_free_kernel+0x20/0x120
  [   26.990283]  queue_work_on+0x97/0xf0
  [   27.134382]  __cpa_collapse_large_pages+0x501/0x6f0
  [   27.566662]  cpa_flush+0x394/0x620
  [   27.998953]  change_page_attr_set_clr+0x321/0x4a0
  [   29.151729]  set_memory_rox+0xa2/0xf0
  [   29.584018]  create_trampoline+0x431/0x6f0
  ...
  [   44.343347] Kernel panic - not syncing: Attempted to kill the idle task!

The boot-time tracer is started from early_trace_init(), which runs
before workqueue_init_early().  Making its trampoline read-only splits a
large page, and CPA collapses it again right away.  The split table has
been a kernel page table since commit 9e4a3ec3411b
("x86/mm/pat: Allocate split page tables as kernel page tables"), so the
collapse frees it through pagetable_free_kernel(), which queues work on
system_percpu_wq - still NULL at that point.  That commit is correct in
itself; it only lets CPA reach pagetable_free_kernel() before the
workqueue that function relies on exists.

Keep putting the table on the list, but don't schedule the work while
the system is still booting.  A core_initcall schedules it once to free
whatever was queued by then.

Link: https://lore.kernel.org/20260925050647.86913-1-mikhail.v.gavrilov@gmail.com
Link: https://lore.kernel.org/20260924064321.23787-1-mikhail.v.gavrilov@gmail.com
Fixes: 9e4a3ec3411b ("x86/mm/pat: Allocate split page tables as kernel page tables")
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
---

 mm/pgtable-generic.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/mm/pgtable-generic.c~mm-dont-schedule-deferred-kernel-page-table-freeing-while-booting
+++ a/mm/pgtable-generic.c
@@ -438,12 +438,30 @@ static void kernel_pgtable_work_func(str
 		__pagetable_free(pt);
 }
 
+static void schedule_kernel_pgtable_free(void)
+{
+	schedule_work(&kernel_pgtable_work.work);
+}
+
 void pagetable_free_kernel(struct ptdesc *pt)
 {
 	spin_lock(&kernel_pgtable_work.lock);
 	list_add(&pt->pt_list, &kernel_pgtable_work.list);
 	spin_unlock(&kernel_pgtable_work.lock);
 
-	schedule_work(&kernel_pgtable_work.work);
+	/*
+	 * The workqueue may not exist yet while the system is booting.
+	 * kernel_pgtable_drain_early() schedules the work once it does.
+	 */
+	if (system_state != SYSTEM_BOOTING)
+		schedule_kernel_pgtable_free();
+}
+
+static int __init kernel_pgtable_drain_early(void)
+{
+	/* Free the kernel page tables queued while booting. */
+	schedule_kernel_pgtable_free();
+	return 0;
 }
+core_initcall(kernel_pgtable_drain_early);
 #endif
_

Patches currently in -mm which might be from mikhail.v.gavrilov@gmail.com are

mm-dont-schedule-deferred-kernel-page-table-freeing-while-booting.patch

