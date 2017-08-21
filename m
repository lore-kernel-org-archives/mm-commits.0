From: akpm@linux-foundation.org
Subject: + pm-hibernate-feed-the-wathdog-when-creating-snapshot.patch
 added to -mm tree
Date: Mon, 21 Aug 2017 13:26:59 -0700
Message-ID: <599b4213.yiFbed/mru7WBllE%akpm__34414.6035066389$1503347224$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43288 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751571AbdHUU1A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2017 16:27:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yu.c.chen@intel.com, dan.j.williams@intel.com, jan.filipcewicz@intel.com, lenb@kernel.org, mgorman@techsingularity.net, mhocko@suse.com, rjw@rjwysocki.net, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: PM/hibernate: touch NMI watchdog when creating snapshot
has been added to the -mm tree.  Its filename is
     pm-hibernate-feed-the-wathdog-when-creating-snapshot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pm-hibernate-feed-the-wathdog-when-creating-snapshot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pm-hibernate-feed-the-wathdog-when-creating-snapshot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Yu <yu.c.chen@intel.com>
Subject: PM/hibernate: touch NMI watchdog when creating snapshot

There is a problem that when counting the pages for creating the
hibernation snapshot will take significant amount of time, especially on
system with large memory.  Since the counting job is performed with irq
disabled, this might lead to NMI lockup.  The following warning were found
on a system with 1.5TB DRAM:

[ 1124.758184] Freezing user space processes ... (elapsed 0.002 seconds) done.
[ 1124.768721] OOM killer disabled.
[ 1124.847009] PM: Preallocating image memory...
[ 1139.392042] NMI watchdog: Watchdog detected hard LOCKUP on cpu 27
[ 1139.392076] CPU: 27 PID: 3128 Comm: systemd-sleep Not tainted 4.13.0-0.rc2.git0.1.fc27.x86_64 #1
[ 1139.392077] task: ffff9f01971ac000 task.stack: ffffb1a3f325c000
[ 1139.392083] RIP: 0010:memory_bm_find_bit+0xf4/0x100
[ 1139.392084] RSP: 0018:ffffb1a3f325fc20 EFLAGS: 00000006
[ 1139.392084] RAX: 0000000000000000 RBX: 0000000013b83000 RCX: ffff9fbe89caf000
[ 1139.392085] RDX: ffffb1a3f325fc30 RSI: 0000000000003200 RDI: ffff9fbeaffffe80
[ 1139.392085] RBP: ffffb1a3f325fc40 R08: 0000000013b80000 R09: ffff9fbe89c54878
[ 1139.392085] R10: ffffb1a3f325fc2c R11: 0000000013b83200 R12: 0000000000000400
[ 1139.392086] R13: fffffd552e0c0000 R14: ffff9fc1bffd31e0 R15: 0000000000000202
[ 1139.392086] FS:  00007f3189704180(0000) GS:ffff9fbec8ec0000(0000) knlGS:0000000000000000
[ 1139.392087] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1139.392087] CR2: 00000085da0f7398 CR3: 000001771cf9a000 CR4: 00000000007406e0
[ 1139.392088] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1139.392088] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1139.392088] PKRU: 55555554
[ 1139.392089] Call Trace:
[ 1139.392092]  ? memory_bm_set_bit+0x29/0x60
[ 1139.392094]  swsusp_set_page_free+0x2b/0x30
[ 1139.392098]  mark_free_pages+0x147/0x1c0
[ 1139.392099]  count_data_pages+0x41/0xa0
[ 1139.392101]  hibernate_preallocate_memory+0x80/0x450
[ 1139.392102]  hibernation_snapshot+0x58/0x410
[ 1139.392103]  hibernate+0x17c/0x310
[ 1139.392104]  state_store+0xdf/0xf0
[ 1139.392107]  kobj_attr_store+0xf/0x20
[ 1139.392111]  sysfs_kf_write+0x37/0x40
[ 1139.392113]  kernfs_fop_write+0x11c/0x1a0
[ 1139.392117]  __vfs_write+0x37/0x170
[ 1139.392121]  ? handle_mm_fault+0xd8/0x230
[ 1139.392122]  vfs_write+0xb1/0x1a0
[ 1139.392123]  SyS_write+0x55/0xc0
[ 1139.392126]  entry_SYSCALL_64_fastpath+0x1a/0xa5
...
[ 1144.690405] done (allocated 6590003 pages)
[ 1144.694971] PM: Allocated 26360012 kbytes in 19.89 seconds (1325.28 MB/s)

It has taken nearly 20 seconds(2.10GHz CPU) thus the NMI lockup was
triggered.  In case the timeout of the NMI watch dog has been set to 1
second, a safe interval should be 6590003/20 = 320k pages in theory. 
However there might also be some platforms running at a lower frequency,
so feed the watchdog every 100k pages.

Link: http://lkml.kernel.org/r/1503328098-5120-1-git-send-email-yu.c.chen@intel.com
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Reported-by: Jan Filipcewicz <jan.filipcewicz@intel.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~pm-hibernate-feed-the-wathdog-when-creating-snapshot mm/page_alloc.c
--- a/mm/page_alloc.c~pm-hibernate-feed-the-wathdog-when-creating-snapshot
+++ a/mm/page_alloc.c
@@ -66,6 +66,7 @@
 #include <linux/kthread.h>
 #include <linux/memcontrol.h>
 #include <linux/ftrace.h>
+#include <linux/nmi.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -2535,9 +2536,12 @@ void drain_all_pages(struct zone *zone)
 
 #ifdef CONFIG_HIBERNATION
 
+/* Touch watchdog for every WD_INTERVAL_PAGE pages. */
+#define WD_INTERVAL_PAGE	(100*1024)
+
 void mark_free_pages(struct zone *zone)
 {
-	unsigned long pfn, max_zone_pfn;
+	unsigned long pfn, max_zone_pfn, page_num = 0;
 	unsigned long flags;
 	unsigned int order, t;
 	struct page *page;
@@ -2552,6 +2556,9 @@ void mark_free_pages(struct zone *zone)
 		if (pfn_valid(pfn)) {
 			page = pfn_to_page(pfn);
 
+			if (!((page_num++) % WD_INTERVAL_PAGE))
+				touch_nmi_watchdog();
+
 			if (page_zone(page) != zone)
 				continue;
 
@@ -2565,8 +2572,11 @@ void mark_free_pages(struct zone *zone)
 			unsigned long i;
 
 			pfn = page_to_pfn(page);
-			for (i = 0; i < (1UL << order); i++)
+			for (i = 0; i < (1UL << order); i++) {
+				if (!((page_num++) % WD_INTERVAL_PAGE))
+					touch_nmi_watchdog();
 				swsusp_set_page_free(pfn_to_page(pfn + i));
+			}
 		}
 	}
 	spin_unlock_irqrestore(&zone->lock, flags);
_

Patches currently in -mm which might be from yu.c.chen@intel.com are

pm-hibernate-feed-the-wathdog-when-creating-snapshot.patch

