Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC422DC359
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 02:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482672; cv=none; b=d4jjgUKgTWPtF3mpnVxXQAIWdno6NKSdQTqAJ9sM7H4iH1fhX5yJQqyUByzH3eLxEwk2SL7iybx09ogYUqrOU6Fw/yvaLqPlN/GybLa/lBpiBZk1yMmBkXOR6n3oWlrjIkVN8xRffISRtm/17adWvOoY9KyCqOVWchwpKGhoNLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482672; c=relaxed/simple;
	bh=tAqLRk9Ur7XKmepebkA++KUgvbV71gYMLt/1aPQXoa4=;
	h=Date:To:From:Subject:Message-Id; b=ClEq4xoj9d/RvFYmdNfGyKz636pA5q3P2u8ZENk+cx2c1EPvITsokGAn0oHq8P8uAEUbuiTbBnpSzlHov7Cb1vu22CsmGzFNsSzcpD/BjFg+doNt4MogsepnvLuT8t6IUcXMUYjL1ZtkfoJ8OrhQCXByRD4TIHTgfucOxG4O8dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SK4TsK+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SK4TsK+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2540EC2BCAF;
	Tue, 27 Jan 2026 02:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769482672;
	bh=tAqLRk9Ur7XKmepebkA++KUgvbV71gYMLt/1aPQXoa4=;
	h=Date:To:From:Subject:From;
	b=SK4TsK+SSCdilJBrRU7u6var7MjlrTujdddO+64Ge/wQm3jsNVWnfnDu34Uid9GXv
	 AQjBxddCI2TEzej5VYNVwoOT5rTsR58zfRhl6pmUkRlQ+Bv6k/8H8iytOFAmOH38LL
	 hln1uuiZo3U0a036lJhS/C7gSoZvmsKsRS1ZxUuI=
Date: Mon, 26 Jan 2026 18:57:51 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernrl.org,rppt@kernel.org,rostedt@goodmis.org,richard.weiyang@gmail.com,paulmck@kernel.org,david@kernel.org,bigeasy@linutronix.de,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mm_init-dont-cond_resched-in-deferred_init_memmap_chunk-if-called-from-deferred_grow_zone.patch removed from -mm tree
Message-Id: <20260127025752.2540EC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: don't cond_resched() in deferred_init_memmap_chunk() if called from deferred_grow_zone()
has been removed from the -mm tree.  Its filename was
     mm-mm_init-dont-cond_resched-in-deferred_init_memmap_chunk-if-called-from-deferred_grow_zone.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/mm_init: don't cond_resched() in deferred_init_memmap_chunk() if called from deferred_grow_zone()
Date: Thu, 22 Jan 2026 13:43:43 -0500

Commit 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk() in
deferred_grow_zone()") made deferred_grow_zone() call
deferred_init_memmap_chunk() within a pgdat_resize_lock() critical section
with irqs disabled.  It did check for irqs_disabled() in
deferred_init_memmap_chunk() to avoid calling cond_resched().  For a
PREEMPT_RT kernel build, however, spin_lock_irqsave() does not disable
interrupt but rcu_read_lock() is called.  This leads to the following bug
report.

  BUG: sleeping function called from invalid context at mm/mm_init.c:2091
  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
  preempt_count: 0, expected: 0
  RCU nest depth: 1, expected: 0
  3 locks held by swapper/0/1:
   #0: ffff80008471b7a0 (sched_domains_mutex){+.+.}-{4:4}, at: sched_domains_mutex_lock+0x28/0x40
   #1: ffff003bdfffef48 (&pgdat->node_size_lock){+.+.}-{3:3}, at: deferred_grow_zone+0x140/0x278
   #2: ffff800084acf600 (rcu_read_lock){....}-{1:3}, at: rt_spin_lock+0x1b4/0x408
  CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.19.0-rc6-test #1 PREEMPT_{RT,(full)
}
  Tainted: [W]=WARN
  Call trace:
   show_stack+0x20/0x38 (C)
   dump_stack_lvl+0xdc/0xf8
   dump_stack+0x1c/0x28
   __might_resched+0x384/0x530
   deferred_init_memmap_chunk+0x560/0x688
   deferred_grow_zone+0x190/0x278
   _deferred_grow_zone+0x18/0x30
   get_page_from_freelist+0x780/0xf78
   __alloc_frozen_pages_noprof+0x1dc/0x348
   alloc_slab_page+0x30/0x110
   allocate_slab+0x98/0x2a0
   new_slab+0x4c/0x80
   ___slab_alloc+0x5a4/0x770
   __slab_alloc.constprop.0+0x88/0x1e0
   __kmalloc_node_noprof+0x2c0/0x598
   __sdt_alloc+0x3b8/0x728
   build_sched_domains+0xe0/0x1260
   sched_init_domains+0x14c/0x1c8
   sched_init_smp+0x9c/0x1d0
   kernel_init_freeable+0x218/0x358
   kernel_init+0x28/0x208
   ret_from_fork+0x10/0x20

Fix it adding a new argument to deferred_init_memmap_chunk() to explicitly
tell it if cond_resched() is allowed or not instead of relying on some
current state information which may vary depending on the exact kernel
configuration options that are enabled.

Link: https://lkml.kernel.org/r/20260122184343.546627-1-longman@redhat.com
Fixes: 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()")
Signed-off-by: Waiman Long <longman@redhat.com>
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: <stable@vger.kernrl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-dont-cond_resched-in-deferred_init_memmap_chunk-if-called-from-deferred_grow_zone
+++ a/mm/mm_init.c
@@ -2056,7 +2056,7 @@ static unsigned long __init deferred_ini
  */
 static unsigned long __init
 deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
-			   struct zone *zone)
+			   struct zone *zone, bool can_resched)
 {
 	int nid = zone_to_nid(zone);
 	unsigned long nr_pages = 0;
@@ -2082,10 +2082,10 @@ deferred_init_memmap_chunk(unsigned long
 
 			spfn = chunk_end;
 
-			if (irqs_disabled())
-				touch_nmi_watchdog();
-			else
+			if (can_resched)
 				cond_resched();
+			else
+				touch_nmi_watchdog();
 		}
 	}
 
@@ -2098,7 +2098,7 @@ deferred_init_memmap_job(unsigned long s
 {
 	struct zone *zone = arg;
 
-	deferred_init_memmap_chunk(start_pfn, end_pfn, zone);
+	deferred_init_memmap_chunk(start_pfn, end_pfn, zone, true);
 }
 
 static unsigned int __init
@@ -2213,7 +2213,7 @@ bool __init deferred_grow_zone(struct zo
 	for (spfn = first_deferred_pfn, epfn = SECTION_ALIGN_UP(spfn + 1);
 	     nr_pages < nr_pages_needed && spfn < zone_end_pfn(zone);
 	     spfn = epfn, epfn += PAGES_PER_SECTION) {
-		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone);
+		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone, false);
 	}
 
 	/*
_

Patches currently in -mm which might be from longman@redhat.com are


