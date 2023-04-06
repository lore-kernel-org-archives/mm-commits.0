Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96E8C77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbjDFDEf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbjDFDEG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1845D9761
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1F8F640CA
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CA8C433EF;
        Thu,  6 Apr 2023 03:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750235;
        bh=YfgeNJAzb+PM6GxSTmpPrUOMKdxJEriq7pxPbasr7ps=;
        h=Date:To:From:Subject:From;
        b=vyYpB6a3FCNLr9dEHa0RWO+Rt8JTPUabkTAEENOgC28e5eKJgj4V3fObOv8vI92CX
         d9hQSj+Viq5nq1VVr2W7JJv3gKKaTedlYq6DM9xYZxA6evK48GSLbJmsROduGy3N67
         qt+owFKZKMlBRlYER4f44YdO1fkeJb89xDx/wnDM=
Date:   Wed, 05 Apr 2023 20:03:54 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-per-vma-lock-statistics.patch removed from -mm tree
Message-Id: <20230406030355.02CA8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: introduce per-VMA lock statistics
has been removed from the -mm tree.  Its filename was
     mm-introduce-per-vma-lock-statistics.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: introduce per-VMA lock statistics
Date: Mon, 27 Feb 2023 09:36:27 -0800

Add a new CONFIG_PER_VMA_LOCK_STATS config option to dump extra statistics
about handling page fault under VMA lock.

Link: https://lkml.kernel.org/r/20230227173632.3292573-29-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    6 ++++++
 include/linux/vmstat.h        |    6 ++++++
 mm/Kconfig.debug              |    6 ++++++
 mm/memory.c                   |    2 ++
 mm/vmstat.c                   |    6 ++++++
 5 files changed, 26 insertions(+)

--- a/include/linux/vm_event_item.h~mm-introduce-per-vma-lock-statistics
+++ a/include/linux/vm_event_item.h
@@ -150,6 +150,12 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		DIRECT_MAP_LEVEL2_SPLIT,
 		DIRECT_MAP_LEVEL3_SPLIT,
 #endif
+#ifdef CONFIG_PER_VMA_LOCK_STATS
+		VMA_LOCK_SUCCESS,
+		VMA_LOCK_ABORT,
+		VMA_LOCK_RETRY,
+		VMA_LOCK_MISS,
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
--- a/include/linux/vmstat.h~mm-introduce-per-vma-lock-statistics
+++ a/include/linux/vmstat.h
@@ -125,6 +125,12 @@ static inline void vm_events_fold_cpu(in
 #define count_vm_tlb_events(x, y) do { (void)(y); } while (0)
 #endif
 
+#ifdef CONFIG_PER_VMA_LOCK_STATS
+#define count_vm_vma_lock_event(x) count_vm_event(x)
+#else
+#define count_vm_vma_lock_event(x) do {} while (0)
+#endif
+
 #define __count_zid_vm_events(item, zid, delta) \
 	__count_vm_events(item##_NORMAL - ZONE_NORMAL + zid, delta)
 
--- a/mm/Kconfig.debug~mm-introduce-per-vma-lock-statistics
+++ a/mm/Kconfig.debug
@@ -279,3 +279,9 @@ config DEBUG_KMEMLEAK_AUTO_SCAN
 
 	  If unsure, say Y.
 
+config PER_VMA_LOCK_STATS
+	bool "Statistics for per-vma locks"
+	depends on PER_VMA_LOCK
+	default y
+	help
+	  Statistics for per-vma locks.
--- a/mm/memory.c~mm-introduce-per-vma-lock-statistics
+++ a/mm/memory.c
@@ -5284,6 +5284,7 @@ retry:
 	/* Check if the VMA got isolated after we found it */
 	if (vma->detached) {
 		vma_end_read(vma);
+		count_vm_vma_lock_event(VMA_LOCK_MISS);
 		/* The area was replaced with another one */
 		goto retry;
 	}
@@ -5292,6 +5293,7 @@ retry:
 	return vma;
 inval:
 	rcu_read_unlock();
+	count_vm_vma_lock_event(VMA_LOCK_ABORT);
 	return NULL;
 }
 #endif /* CONFIG_PER_VMA_LOCK */
--- a/mm/vmstat.c~mm-introduce-per-vma-lock-statistics
+++ a/mm/vmstat.c
@@ -1399,6 +1399,12 @@ const char * const vmstat_text[] = {
 	"direct_map_level2_splits",
 	"direct_map_level3_splits",
 #endif
+#ifdef CONFIG_PER_VMA_LOCK_STATS
+	"vma_lock_success",
+	"vma_lock_abort",
+	"vma_lock_retry",
+	"vma_lock_miss",
+#endif
 #endif /* CONFIG_VM_EVENT_COUNTERS || CONFIG_MEMCG */
 };
 #endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA || CONFIG_MEMCG */
_

Patches currently in -mm which might be from surenb@google.com are


