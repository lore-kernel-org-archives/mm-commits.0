From: akpm@linux-foundation.org
Subject: + memcg-move-charges-of-anonymous-swap-fix-2.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:24:47 -0800
Message-ID: <201001142324.o0ENOmSR005960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754594Ab0ANXZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 18:25:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com


The patch titled
     memcg-move-charges-of-anonymous-swap-fix-2
has been added to the -mm tree.  Its filename is
     memcg-move-charges-of-anonymous-swap-fix-2.patch

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
Subject: memcg-move-charges-of-anonymous-swap-fix-2
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Now, ia64 can't compile page_cgroup.c.
because it include asm/cmpxhg.h but almost arch don't have arch specific
cmpxhg.h. they use asm-generic/cmpxhg.h.

Then, following errror occur.

  CC      mm/page_cgroup.o
  mm/page_cgroup.c:12:25: error: asm/cmpxchg.h: No such file or
  directory
  make[1]: *** [mm/page_cgroup.o] Error 1
  make: *** [mm] Error 2

Fortunately, memcg code don't use low layer cmpxchg directly. thus
this patch remove this include line simply.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/page_cgroup.c~memcg-move-charges-of-anonymous-swap-fix-2 mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-move-charges-of-anonymous-swap-fix-2
+++ a/mm/page_cgroup.c
@@ -9,7 +9,6 @@
 #include <linux/vmalloc.h>
 #include <linux/cgroup.h>
 #include <linux/swapops.h>
-#include <asm/cmpxchg.h>
 
 static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
page-allocator-fix-update-nr_free_pages-only-as-necessary.patch
mm-page_alloc-fix-the-range-check-for-backward-merging.patch
vmscan-kswapd-dont-retry-balance_pgdat-if-all-zones-are-unreclaimable.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
vmscan-get_scan_ratio-cleanup.patch
vmstat-add-anon_scan_ratio-field-to-zoneinfo.patch
memcg-add-anon_scan_ratio-to-memorystat-file.patch
mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

