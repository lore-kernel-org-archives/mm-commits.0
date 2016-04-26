From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch added to -mm tree
Date: Tue, 26 Apr 2016 12:48:59 -0700
Message-ID: <571fc62b.8M6VWEBsMgzYEzsh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbcDZTtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2016 15:49:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch

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
Subject: mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix

Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/buffer.c~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix fs/buffer.c
diff -puN include/linux/mmzone.h~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix include/linux/mmzone.h
diff -puN mm/internal.h~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix mm/internal.h
diff -puN mm/mempolicy.c~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix mm/mempolicy.c
diff -puN mm/page_alloc.c~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix
+++ a/mm/page_alloc.c
@@ -3416,7 +3416,7 @@ retry_cpuset:
 	/* The preferred zone is used for statistics later */
 	ac.preferred_zoneref = first_zones_zonelist(ac.zonelist,
 					ac.high_zoneidx, ac.nodemask);
-	if (!ac.preferred_zone)
+	if (!ac.preferred_zoneref)
 		goto no_zone;
 	ac.classzone_idx = zonelist_zone_idx(ac.preferred_zoneref);
 
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
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
mm-kasan-initial-memory-quarantine-implementation-v8-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
fs-execc-fix-minor-memory-leak.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

