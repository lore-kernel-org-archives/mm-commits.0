From: akpm@linux-foundation.org
Subject: + memcg-remove-unneeded-preempt_disable-fix.patch added to -mm tree
Date: Tue, 06 Sep 2011 13:06:02 -0700
Message-ID: <201109062006.p86K63v9026945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754903Ab1IFUGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 16:06:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, Valdis.Kletnieks@vt.edu, bsingharora@gmail.com, gthelen@google.com, kamezawa.hioryu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg-remove-unneeded-preempt_disable-fix
has been added to the -mm tree.  Its filename is
     memcg-remove-unneeded-preempt_disable-fix.patch

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
Subject: memcg-remove-unneeded-preempt_disable-fix
From: Johannes Weiner <jweiner@redhat.com>

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hioryu@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memcontrol.c~memcg-remove-unneeded-preempt_disable-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-unneeded-preempt_disable-fix
+++ a/mm/memcontrol.c
@@ -616,6 +616,7 @@ static unsigned long mem_cgroup_read_eve
 	return val;
 }
 
+/* Must be called with preemption disabled */
 static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 					 bool file, int nr_pages)
 {
_

Patches currently in -mm which might be from jweiner@redhat.com are

mm-vmscan-fix-force-scanning-small-targets-without-swap.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
memcg-revert-memcg-add-memoryvmscan_stat.patch
mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch
mm-page-writebackc-document-bdi_min_ratio.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-compaction-compact-unevictable-pages.patch
mm-compaction-accounting-fix.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch
memcg-remove-unneeded-preempt_disable.patch
memcg-remove-unneeded-preempt_disable-fix.patch

