From: akpm@linux-foundation.org
Subject: + mm-vmstat-fix-up-zone-state-accounting-fix.patch added to -mm
 tree
Date: Wed, 05 Feb 2014 14:17:34 -0800
Message-ID: <52f2b87e.vtA8BWTgEf37l7xZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbaBEWRe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 17:17:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, akpm@linux-foundation.org

Subject: + mm-vmstat-fix-up-zone-state-accounting-fix.patch added to -mm tree
To: akpm@linux-foundation.org,hannes@cmpxchg.org
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 14:17:34 -0800


The patch titled
     Subject: mm-vmstat-fix-up-zone-state-accounting-fix
has been added to the -mm tree.  Its filename is
     mm-vmstat-fix-up-zone-state-accounting-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-fix-up-zone-state-accounting-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-fix-up-zone-state-accounting-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmstat-fix-up-zone-state-accounting-fix

make it build

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN include/linux/vmstat.h~mm-vmstat-fix-up-zone-state-accounting-fix include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-vmstat-fix-up-zone-state-accounting-fix
+++ a/include/linux/vmstat.h
@@ -214,6 +214,18 @@ static inline void __mod_zone_page_state
 	zone_page_state_add(delta, zone, item);
 }
 
+static inline void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
+{
+	atomic_long_inc(&zone->vm_stat[item]);
+	atomic_long_inc(&vm_stat[item]);
+}
+
+static inline void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
+{
+	atomic_long_dec(&zone->vm_stat[item]);
+	atomic_long_dec(&vm_stat[item]);
+}
+
 static inline void __inc_zone_page_state(struct page *page,
 			enum zone_stat_item item)
 {
@@ -234,18 +246,6 @@ static inline void __dec_zone_page_state
 #define dec_zone_page_state __dec_zone_page_state
 #define mod_zone_page_state __mod_zone_page_state
 
-static inline void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
-{
-	atomic_long_inc(&zone->vm_stat[item]);
-	atomic_long_inc(&vm_stat[item]);
-}
-
-static inline void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
-{
-	atomic_long_dec(&zone->vm_stat[item]);
-	atomic_long_dec(&vm_stat[item]);
-}
-
 #define inc_zone_state __inc_zone_state
 #define dec_zone_state __dec_zone_state
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
xen-properly-account-for-_page_numa-during-xen-pte-translations-fix.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch

