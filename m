From: akpm@linux-foundation.org
Subject: +
 mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch added to -mm tree
Date: Fri, 22 Apr 2016 13:38:21 -0700
Message-ID: <571a8bbd.TeXbCv6omx3rQEYg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbcDVUiW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 16:38:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix
has been added to the -mm tree.  Its filename is
     mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix

fix it for Mel's mm-page_alloc-remove-field-from-alloc_context.patch

Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/compaction.h~mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix include/linux/compaction.h
diff -puN include/linux/mmzone.h~mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix include/linux/mmzone.h
diff -puN mm/compaction.c~mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix mm/compaction.c
--- a/mm/compaction.c~mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix
+++ a/mm/compaction.c
@@ -1450,7 +1450,7 @@ bool compaction_zonelist_suitable(struct
 		available = zone_reclaimable_pages(zone) / order;
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
 		compact_result = __compaction_suitable(zone, order, alloc_flags,
-				ac->classzone_idx, available);
+				ac_classzone_idx(ac), available);
 		if (compact_result != COMPACT_SKIPPED &&
 				compact_result != COMPACT_NOT_SUITABLE_ZONE)
 			return true;
diff -puN mm/page_alloc.c~mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix mm/page_alloc.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
kernel-padata-hide-unused-functions-checkpatch-fixes.patch
mm.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
fs-execc-fix-minor-memory-leak.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

