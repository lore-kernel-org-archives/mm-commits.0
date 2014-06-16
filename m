From: akpm@linux-foundation.org
Subject: [withdrawn] memcg-document-memorylow_limit_in_bytes.patch removed from -mm tree
Date: Mon, 16 Jun 2014 15:35:09 -0700
Message-ID: <539f711d.Iadp1fwB8d+j4zL1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbaFPWfK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 18:35:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz


The patch titled
     Subject: memcg: document memory.low_limit_in_bytes
has been removed from the -mm tree.  Its filename was
     memcg-document-memorylow_limit_in_bytes.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: document memory.low_limit_in_bytes

Describe low_limit_in_bytes and its effect.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN Documentation/cgroups/memory.txt~memcg-document-memorylow_limit_in_bytes Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-document-memorylow_limit_in_bytes
+++ a/Documentation/cgroups/memory.txt
@@ -57,6 +57,7 @@ Brief summary of control files.
  memory.memsw.usage_in_bytes	 # show current res_counter usage for memory+Swap
 				 (See 5.5 for details)
  memory.limit_in_bytes		 # set/show limit of memory usage
+ memory.low_limit_in_bytes	 # set/show low limit for memory reclaim
  memory.memsw.limit_in_bytes	 # set/show limit of memory+Swap usage
  memory.failcnt			 # show the number of memory usage hits limits
  memory.memsw.failcnt		 # show the number of memory+Swap hits limits
@@ -244,7 +245,15 @@ global VM. Cgroups can get reclaimed bas
    to select and kill the bulkiest task in the hiearchy. (See 10. OOM Control
    below.)
 
-Note2: When panic_on_oom is set to "2", the whole system will panic.
+Groups might be also protected from both global and limit reclaim by
+low_limit_in_bytes knob. If the limit is non-zero the reclaim logic
+doesn't include groups (and their subgroups - see 6. Hierarchy support)
+which are bellow the low limit if there is other eligible cgroup in the
+reclaimed hierarchy. If all groups which participate reclaim are under
+their low limits then all of them are reclaimed and the low limit is
+ignored.
+
+Note: When panic_on_oom is set to "2", the whole system will panic.
 
 When oom event notifier is registered, event will be delivered to the root
 of the memory pressure which cannot be handled (See oom_control section)
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch
madvise-cleanup-swapin_walk_pmd_entry.patch
memcg-separate-mem_cgroup_move_charge_pte_range.patch
arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
mincore-apply-page-table-walker-on-do_mincore.patch
vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch

