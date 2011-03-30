From: akpm@linux-foundation.org
Subject: + mm-add-vm-counters-for-transparent-hugepages-fix.patch added to -mm tree
Date: Wed, 30 Mar 2011 14:38:55 -0700
Message-ID: <201103302138.p2ULct40011906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964945Ab1C3Vji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 17:39:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, aarcange@redhat.com, ak@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm-add-vm-counters-for-transparent-hugepages-fix
has been added to the -mm tree.  Its filename is
     mm-add-vm-counters-for-transparent-hugepages-fix.patch

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
Subject: mm-add-vm-counters-for-transparent-hugepages-fix
From: Johannes Weiner <hannes@cmpxchg.org>

On Fri, Mar 04, 2011 at 04:08:30PM -0800, akpm@linux-foundation.org wrote:
> diff -puN mm/vmstat.c~mm-add-vm-counters-for-transparent-hugepages mm/vmstat.c
> --- a/mm/vmstat.c~mm-add-vm-counters-for-transparent-hugepages
> +++ a/mm/vmstat.c
> @@ -946,6 +946,14 @@ static const char * const vmstat_text[]
>  	"unevictable_pgs_stranded",
>  	"unevictable_pgs_mlockfreed",
>  #endif
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	"thp_fault_alloc",
> +	"thp_fault_fallback",
> +	"thp_collapse_alloc",
> +	"thp_collapse_alloc_failed",
> +	"thp_split",
> +#endif
>  };

This first #endif in this hunk does not belong to the unevictable
counters, as one could be easily trapped into assuming, it's the
higher level 'vm event counters enabled'.  The thp event name strings
should be part of that block as well.

Since there are no zone stat items after the event counters, the only
misbehaviour for now would be having those strings defined on a THP &&
!VM_EVENT_COUNTERS config.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmstat.c~mm-add-vm-counters-for-transparent-hugepages-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-add-vm-counters-for-transparent-hugepages-fix
+++ a/mm/vmstat.c
@@ -951,7 +951,6 @@ static const char * const vmstat_text[] 
 	"unevictable_pgs_cleared",
 	"unevictable_pgs_stranded",
 	"unevictable_pgs_mlockfreed",
-#endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	"thp_fault_alloc",
@@ -960,6 +959,8 @@ static const char * const vmstat_text[] 
 	"thp_collapse_alloc_failed",
 	"thp_split",
 #endif
+
+#endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
 
 static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-fix-mem_cgroup_rotate_reclaimable_page.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix-fix.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-add-vm-counters-for-transparent-hugepages-fix.patch
mm-batch-activate_page-to-reduce-lock-contention.patch

