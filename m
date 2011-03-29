From: akpm@linux-foundation.org
Subject: + ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix-fix.patch added to -mm tree
Date: Tue, 29 Mar 2011 13:45:00 -0700
Message-ID: <201103292045.p2TKj1jk004386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285Ab1C2Ups (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Mar 2011 16:45:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, aarcange@redhat.com, chrisw@sous-sol.org, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, nai.xia@gmail.com, riel@redhat.com


The patch titled
     mm/vmstat.c: update vmstat_text for nr_ksm_pages_sharing
has been added to the -mm tree.  Its filename is
     ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix-fix.patch

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
Subject: mm/vmstat.c: update vmstat_text for nr_ksm_pages_sharing
From: Johannes Weiner <hannes@cmpxchg.org>

This adds a zone stat item without a corresponding entry in
vm_stat_text.  As a result, all vm event entries in /proc/vmstat show
the value of the respective previous counter.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Nai Xia <nai.xia@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/vmstat.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix-fix mm/vmstat.c
--- a/mm/vmstat.c~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix-fix
+++ a/mm/vmstat.c
@@ -886,6 +886,9 @@ static const char * const vmstat_text[] 
 	"numa_other",
 #endif
 	"nr_anon_transparent_hugepages",
+#ifdef CONFIG_KSM
+	"nr_ksm_pages_sharing",
+#endif
 	"nr_dirty_threshold",
 	"nr_dirty_background_threshold",
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-fix-mem_cgroup_rotate_reclaimable_page.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix-fix.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

