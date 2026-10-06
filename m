Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA3B390229;
	Tue,  6 Oct 2026 23:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330293; cv=none; b=gMLHZzu+P2UHIkj1NzRuIarQDaY5Vh5TyiFXKfXNuBMwYygtVeZD3WX/6MH/adYT8f/dFaUWFoEkBtTkG0mJo5785k2rvXAM09LcKnEj1DaAmFX38s0XOyTxrbK5z10STmDJa7Ly9pD/ZtjFhktX3d2X3PR4SXozF0uGbkwKMG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330293; c=relaxed/simple;
	bh=lA5dc71kgN9osN83Izs74lDtLqDEeBqDqX4lvAv9E7E=;
	h=Date:To:From:Subject:Message-Id; b=j7wpVpDvmvzKmEJcmezzMBudHV05QBSJdKSzHVnMTGAhUDuVjdhuIcx1hwHWk+ggVp5Ipxtp+5Tn9ntmOvOnRQGCs4gDSYrdsCdoDMZdDQjhmUd4+M9EG0F+mE3dfv8/c7kN1f24L1Z2pGDLQIH9hK4K2UKdAvyBjxM+Nvxr7OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OQkDeghp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OQkDeghp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC001F0089D;
	Tue,  6 Oct 2026 23:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791330291;
	bh=/RMSxRO8H4GSIYiLp3iREUpLzqZA2YFmgRsyX2N2NYQ=;
	h=Date:To:From:Subject;
	b=OQkDeghp1OB4IP/jI+9rU2UyAJMQCdCzgU9kblt3qrtKM2Rd8XuUf06KiFQhevWDn
	 xN01blKdeNncMUKmGZcvlGbSWczsG2j+HhkmmNAVIu6ERYw7tdF/dXxNiqDioRcTPL
	 sjPxNodNvbw8hj9uAwM7SsMAu/CNHBYf0JnagK9M=
Date: Tue, 06 Oct 2026 16:44:51 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,rostedt@goodmis.org,mingo@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jgg@ziepe.ca,david@kernel.org,dave.hansen@linux.intel.com,baolu.lu@linux.intel.com,azpijr@gmail.com,akpm@linux-foundation.org,mikhail.v.gavrilov@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-dont-schedule-deferred-kernel-page-table-freeing-while-booting.patch removed from -mm tree
Message-Id: <20261006234451.AAC001F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: don't schedule deferred kernel page table freeing while booting
has been removed from the -mm tree.  Its filename was
     mm-dont-schedule-deferred-kernel-page-table-freeing-while-booting.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
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


