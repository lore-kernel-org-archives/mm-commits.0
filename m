From: akpm@linux-foundation.org
Subject: + checkpatch-add-warning-of-future-__gfp_nofail-use.patch added
 to -mm tree
Date: Wed, 11 Dec 2013 15:58:26 -0800
Message-ID: <52a8fc22.NgGhUoVuYU7KcPNd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3LKX61 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 18:58:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, rientjes@google.com

Subject: + checkpatch-add-warning-of-future-__gfp_nofail-use.patch added to -mm tree
To: rientjes@google.com,joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 15:58:26 -0800


The patch titled
     Subject: checkpatch: add warning of future __GFP_NOFAIL use
has been added to the -mm tree.  Its filename is
     checkpatch-add-warning-of-future-__gfp_nofail-use.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-warning-of-future-__gfp_nofail-use.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-warning-of-future-__gfp_nofail-use.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: checkpatch: add warning of future __GFP_NOFAIL use

gfp.h and page_alloc.c already specify that __GFP_NOFAIL is deprecated and
no new users should be added.

Add a warning to checkpatch to catch this.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-warning-of-future-__gfp_nofail-use scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-warning-of-future-__gfp_nofail-use
+++ a/scripts/checkpatch.pl
@@ -4119,6 +4119,12 @@ sub process {
 			     "$1 uses number as first arg, sizeof is generally wrong\n" . $herecurr);
 		}
 
+# check for GFP_NOWAIT use
+		if ($line =~ /\b__GFP_NOFAIL\b/) {
+			WARN("__GFP_NOFAIL",
+			     "Use of __GFP_NOFAIL is deprecated, no new users should be added\n" . $herecurr);
+		}
+
 # check for multiple semicolons
 		if ($line =~ /;\s*;\s*$/) {
 			if (WARN("ONE_SEMICOLON",
_

Patches currently in -mm which might be from rientjes@google.com are

include-linux-hugetlbh-make-isolate_huge_page-an-inline.patch
mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations.patch
mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin.patch
mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix.patch
mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
introduce-for_each_thread-to-replace-the-buggy-while_each_thread.patch
oom_kill-change-oom_killc-to-use-for_each_thread.patch
oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock.patch
oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
lib-show_memc-show-num_poisoned_pages-when-oom.patch
memcg-oom-lock-mem_cgroup_print_oom_info.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch

