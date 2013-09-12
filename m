From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-multiple-large-threshold-notifications.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:53 -0700
Message-ID: <523219f1.XuuOdiF/V3oMFcQH%akpm__17139.5604069859$1379015171$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab3ILTpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mhocko@suse.cz, kirill.shutemov@linux.intel.com, hannes@cmpxchg.org, gthelen@google.com

Subject: [merged] memcg-fix-multiple-large-threshold-notifications.patch removed from -mm tree
To: gthelen@google.com,hannes@cmpxchg.org,kirill.shutemov@linux.intel.com,mhocko@suse.cz,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:53 -0700


The patch titled
     Subject: memcg: fix multiple large threshold notifications
has been removed from the -mm tree.  Its filename was
     memcg-fix-multiple-large-threshold-notifications.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: memcg: fix multiple large threshold notifications

A memory cgroup with (1) multiple threshold notifications and (2) at least
one threshold >=2G was not reliable.  Specifically the notifications would
either not fire or would not fire in the proper order.

The __mem_cgroup_threshold() signaling logic depends on keeping 64 bit
thresholds in sorted order.  mem_cgroup_usage_register_event() sorts them
with compare_thresholds(), which returns the difference of two 64 bit
thresholds as an int.  If the difference is positive but has bit[31] set,
then sort() treats the difference as negative and breaks sort order.

This fix compares the two arbitrary 64 bit thresholds returning the
classic -1, 0, 1 result.

The test below sets two notifications (at 0x1000 and 0x81001000):
  cd /sys/fs/cgroup/memory
  mkdir x
  for x in 4096 2164264960; do
    cgroup_event_listener x/memory.usage_in_bytes $x | sed "s/^/$x listener:/" &
  done
  echo $$ > x/cgroup.procs
  anon_leaker 500M

v3.11-rc7 fails to signal the 4096 event listener:
  Leaking...
  Done leaking pages.

Patched v3.11-rc7 properly notifies:
  Leaking...
  4096 listener:2013:8:31:14:13:36
  Done leaking pages.

The fixed bug is old.  It appears to date back to the introduction of
memcg threshold notifications in v2.6.34-rc1-116-g2e72b6347c94 "memcg:
implement memory thresholds"

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-multiple-large-threshold-notifications mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-multiple-large-threshold-notifications
+++ a/mm/memcontrol.c
@@ -5591,7 +5591,13 @@ static int compare_thresholds(const void
 	const struct mem_cgroup_threshold *_a = a;
 	const struct mem_cgroup_threshold *_b = b;
 
-	return _a->threshold - _b->threshold;
+	if (_a->threshold > _b->threshold)
+		return 1;
+
+	if (_a->threshold < _b->threshold)
+		return -1;
+
+	return 0;
 }
 
 static int mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
memcg-remove-memcg_nr_file_mapped.patch
memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch
memcg-add-per-cgroup-writeback-pages-accounting.patch
memcg-document-cgroup-dirty-writeback-memory-statistics.patch

