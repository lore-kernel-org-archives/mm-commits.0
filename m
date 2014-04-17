From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch added to -mm tree
Date: Thu, 17 Apr 2014 11:54:02 -0700
Message-ID: <5350234a.6kC4xAtTo4k9sbPM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaDQSyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 14:54:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rientjes@google.com, mhocko@suse.cz, hannes@cmpxchg.org

Subject: + mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch added to -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,rientjes@google.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 11:54:02 -0700


The patch titled
     Subject: mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix

Update Documentation/cgroups/memory.txt

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN Documentation/cgroups/memory.txt~mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix
+++ a/Documentation/cgroups/memory.txt
@@ -535,17 +535,15 @@ Note:
 
 5.3 swappiness
 
-Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
+Similar to /proc/sys/vm/swappiness, but only affecting reclaim that is
+triggered by this cgroup's hard limit.  The tunable in the root cgroup
+corresponds to the global swappiness setting.
+
 Please note that unlike the global swappiness, memcg knob set to 0
 really prevents from any swapping even if there is a swap storage
 available. This might lead to memcg OOM killer if there are no file
 pages to reclaim.
 
-Following cgroups' swappiness can't be changed.
-- root cgroup (uses /proc/sys/vm/swappiness).
-- a cgroup which uses hierarchy and it has other cgroup(s) below it.
-- a cgroup which uses hierarchy and not the root of hierarchy.
-
 5.4 failcnt
 
 A memory cgroup provides memory.failcnt and memory.memsw.failcnt files.
@@ -754,7 +752,6 @@ You can disable the OOM-killer by writin
 
 	#echo 1 > memory.oom_control
 
-This operation is only allowed to the top cgroup of a sub-hierarchy.
 If OOM-killer is disabled, tasks under cgroup will hang/sleep
 in memory cgroup's OOM-waitqueue when they request accountable memory.
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
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
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

