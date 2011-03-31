From: akpm@linux-foundation.org
Subject: [folded] ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix-fix.patch removed from -mm tree
Date: Thu, 31 Mar 2011 11:16:49 -0700
Message-ID: <201103311815.p2VIFieU019919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758902Ab1CaSQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Mar 2011 14:16:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, aarcange@redhat.com, chrisw@sous-sol.org, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, nai.xia@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm/vmstat.c: update vmstat_text for nr_ksm_pages_sharing
has been removed from the -mm tree.  Its filename was
     ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix-fix.patch

This patch was dropped because it was folded into ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch

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

memcg-fix-mem_cgroup_rotate_reclaimable_page.patch
mm-add-vm-counters-for-transparent-hugepages.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch
mm-batch-activate_page-to-reduce-lock-contention.patch

