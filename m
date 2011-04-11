From: akpm@linux-foundation.org
Subject: + mm-introduce-wait_on_page_locked_killable.patch added to -mm tree
Date: Mon, 11 Apr 2011 15:05:23 -0700
Message-ID: <201104112205.p3BM5NRr004022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756089Ab1DKWFm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 18:05:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, mingo@elte.hu, tglx@linutronix.de, willy@linux.intel.com


The patch titled
     mm: introduce wait_on_page_locked_killable()
has been added to the -mm tree.  Its filename is
     mm-introduce-wait_on_page_locked_killable.patch

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
Subject: mm: introduce wait_on_page_locked_killable()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 2687a356 ("Add lock_page_killable") introduced killable
lock_page().  Similarly this patch introdues killable
wait_on_page_locked().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    9 +++++++++
 mm/filemap.c            |   11 +++++++++++
 2 files changed, 20 insertions(+)

diff -puN include/linux/pagemap.h~mm-introduce-wait_on_page_locked_killable include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-introduce-wait_on_page_locked_killable
+++ a/include/linux/pagemap.h
@@ -357,6 +357,15 @@ static inline int lock_page_or_retry(str
  */
 extern void wait_on_page_bit(struct page *page, int bit_nr);
 
+extern int wait_on_page_bit_killable(struct page *page, int bit_nr);
+
+static inline int wait_on_page_locked_killable(struct page *page)
+{
+	if (PageLocked(page))
+		return wait_on_page_bit_killable(page, PG_locked);
+	return 0;
+}
+
 /* 
  * Wait for a page to be unlocked.
  *
diff -puN mm/filemap.c~mm-introduce-wait_on_page_locked_killable mm/filemap.c
--- a/mm/filemap.c~mm-introduce-wait_on_page_locked_killable
+++ a/mm/filemap.c
@@ -573,6 +573,17 @@ void wait_on_page_bit(struct page *page,
 }
 EXPORT_SYMBOL(wait_on_page_bit);
 
+int wait_on_page_bit_killable(struct page *page, int bit_nr)
+{
+	DEFINE_WAIT_BIT(wait, &page->flags, bit_nr);
+
+	if (!test_bit(bit_nr, &page->flags))
+		return 0;
+
+	return __wait_on_bit(page_waitqueue(page), &wait,
+			     sleep_on_page_killable, TASK_KILLABLE);
+}
+
 /**
  * add_page_wait_queue - Add an arbitrary waiter to a page's wait queue
  * @page: Page defining the wait queue of interest
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

memcg-fix-mem_cgroup_rotate_reclaimable_page.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-increase-reclaim_distance-to-30.patch
vmscan-all_unreclaimable-use-zone-all_unreclaimable-as-a-name.patch
oom-kill-remove-boost_dying_task_prio.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

