From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-swap-add-swap-readahead-hit-statistics-fix.patch removed from -mm tree
Date: Wed, 06 Sep 2017 16:08:26 -0700
Message-ID: <59b07fea.RhkPqXfKfhfl/kxr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47526 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbdIFXI1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:08:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave.hansen@intel.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hughd@google.com, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@intel.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-add-swap-readahead-hit-statistics-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-add-swap-readahead-hit-statistics-fix.patch

This patch was dropped because it was folded into mm-swap-add-swap-readahead-hit-statistics.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-add-swap-readahead-hit-statistics-fix

don't display swap stats if CONFOG_SWAP=n

Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    2 ++
 mm/vmstat.c                   |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/vm_event_item.h~mm-swap-add-swap-readahead-hit-statistics-fix include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-swap-add-swap-readahead-hit-statistics-fix
+++ a/include/linux/vm_event_item.h
@@ -106,8 +106,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		VMACACHE_FIND_HITS,
 		VMACACHE_FULL_FLUSHES,
 #endif
+#ifdef CONFIG_SWAP
 		SWAP_RA,
 		SWAP_RA_HIT,
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN mm/vmstat.c~mm-swap-add-swap-readahead-hit-statistics-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-swap-add-swap-readahead-hit-statistics-fix
+++ a/mm/vmstat.c
@@ -1098,9 +1098,10 @@ const char * const vmstat_text[] = {
 	"vmacache_find_hits",
 	"vmacache_full_flushes",
 #endif
