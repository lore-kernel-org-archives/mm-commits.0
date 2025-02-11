Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75013214
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 03:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739246014; cv=none; b=cZCirunRPHjzgirZ8GQT4tqmOD8U1Hn/NWPDOMqTRpMylBkIFFijOpP/bi6WIXNx+xyVHPtyppv+dFcC1y+bEmpmnK9yC+4IlB3pRjjO7ZarJGR8sB0XiAwcnOAmBADXwaCUvUSt/RH3WJ+iQ9SfpgfSdlZ3rJuz9go8kD+pDsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739246014; c=relaxed/simple;
	bh=+86Uq/Fm3djaDORuSjcrmJdY3rf4rhd2Ml0q/nRu22c=;
	h=Date:To:From:Subject:Message-Id; b=cSlWUF8aw60oOI2OzvAgR4b25CYsacAj7DzFnDxA3h3i2G4et8xZM4AohCwLjvQ7RzexLYTopbS5UIlLALm2d95L4gtxyuw/n3UVtAjZZbBh7RopbE7dJzk/KxTjY7QNkkOlQ1HWVTGojdC/yjK3mSxWM6oaqCAuDnb1YtRSpOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1X7+48wt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1X7+48wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322C9C4CEDD;
	Tue, 11 Feb 2025 03:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739246013;
	bh=+86Uq/Fm3djaDORuSjcrmJdY3rf4rhd2Ml0q/nRu22c=;
	h=Date:To:From:Subject:From;
	b=1X7+48wtuZN093PAtUDs9DREixQ6A3c2Mf7On1Bnbdor0I0Pfin3v1iACrrzYW9Ai
	 q3VqvB1VZoPsjHscTEwTLtITc/BxAaIAsMnux8Qog8JV5B7KfGwL+rn7jskHKjLx1d
	 g7Zjv3axuFr+VzdlogL/3CAiEhFVphFX7r/e3kaI=
Date: Mon, 10 Feb 2025 19:53:32 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,souravpanda@google.com,rientjes@google.com,pasha.tatashin@soleen.com,nathan@kernel.org,kaiyang2@cs.cmu.edu,joel.granados@kernel.org,intelfx@intelfx.name,hannes@cmpxchg.org,david@redhat.com,david.laight@aculab.com,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-fix-clang-w=1-compiler-warnings.patch removed from -mm tree
Message-Id: <20250211035333.322C9C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix clang W=1 compiler warnings
has been removed from the -mm tree.  Its filename was
     mm-fix-clang-w=1-compiler-warnings.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Bart Van Assche <bvanassche@acm.org>
Subject: mm: fix clang W=1 compiler warnings
Date: Fri, 31 Jan 2025 11:12:23 -0800

Commit 30c2de0a267c ("mm/vmstat: fix a W=1 clang compiler warning")
suppresses some but not all compiler warnings that are reported by clang
when building mm/ with W=1.  Hence revert commit 30c2de0a267c and instead
make NR_LRU_BASE and NR_ZONE_LRU_BASE integer constants instead of
enumeration constants.  Additionally, convert the item##_NORMAL constants
from type enum vm_event_item into int before subtracting ZONE_NORMAL.  The
latter constant has type enum zone_type.

Link: https://lkml.kernel.org/r/20250131191231.1370466-1-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Ivan Shapovalov <intelfx@intelfx.name>
Cc: David Laight <david.laight@aculab.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   26 +++++++++++++++++++++-----
 include/linux/vmstat.h |    9 +++++++--
 2 files changed, 28 insertions(+), 7 deletions(-)

--- a/include/linux/mmzone.h~mm-fix-clang-w=1-compiler-warnings
+++ a/include/linux/mmzone.h
@@ -135,11 +135,20 @@ enum numa_stat_item {
 #define NR_VM_NUMA_EVENT_ITEMS 0
 #endif
 
+/*
+ * NR_ZONE_LRU_BASE and NR_VM_ZONE_STAT_ITEMS are often added to enumeration
+ * constants of another type than enum_zone_stat_item. Define these constants
+ * as an integer instead of enum node_stat_item to prevent that the compiler
+ * warns about enumeration type mismatches when these constants are used.
+ */
+#define NR_ZONE_LRU_BASE	(__NR_ZONE_LRU_BASE + 0)
+#define NR_VM_ZONE_STAT_ITEMS	(__NR_VM_ZONE_STAT_ITEMS + 0)
+
 enum zone_stat_item {
 	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
-	NR_ZONE_LRU_BASE, /* Used only for compaction and reclaim retry */
-	NR_ZONE_INACTIVE_ANON = NR_ZONE_LRU_BASE,
+	__NR_ZONE_LRU_BASE, /* Used only for compaction and reclaim retry */
+	NR_ZONE_INACTIVE_ANON = __NR_ZONE_LRU_BASE,
 	NR_ZONE_ACTIVE_ANON,
 	NR_ZONE_INACTIVE_FILE,
 	NR_ZONE_ACTIVE_FILE,
@@ -155,11 +164,18 @@ enum zone_stat_item {
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	NR_UNACCEPTED,
 #endif
-	NR_VM_ZONE_STAT_ITEMS };
+	__NR_VM_ZONE_STAT_ITEMS };
+
+/*
+ * enum lru_list constants are often added to NR_LRU_BASE. Define NR_LRU_BASE
+ * as an integer instead of enum node_stat_item to prevent that the compiler
+ * warns about enumeration type mismatches.
+ */
+#define NR_LRU_BASE (__NR_LRU_BASE + 0)
 
 enum node_stat_item {
-	NR_LRU_BASE,
-	NR_INACTIVE_ANON = NR_LRU_BASE, /* must match order of LRU_[IN]ACTIVE */
+	__NR_LRU_BASE,
+	NR_INACTIVE_ANON = __NR_LRU_BASE, /*must match order of LRU_[IN]ACTIVE*/
 	NR_ACTIVE_ANON,		/*  "     "     "   "       "         */
 	NR_INACTIVE_FILE,	/*  "     "     "   "       "         */
 	NR_ACTIVE_FILE,		/*  "     "     "   "       "         */
--- a/include/linux/vmstat.h~mm-fix-clang-w=1-compiler-warnings
+++ a/include/linux/vmstat.h
@@ -135,8 +135,13 @@ static inline void vm_events_fold_cpu(in
 #define count_vm_vma_lock_event(x) do {} while (0)
 #endif
 
+/*
+ * item##_NORMAL has type enum vm_event_item while ZONE_NORMAL and zid have
+ * type enum zone_type. Suppress compiler warnings about mixing different
+ * enumeration types by converting item##_NORMAL into an int with '+ 0'.
+ */
 #define __count_zid_vm_events(item, zid, delta) \
-	__count_vm_events(item##_NORMAL - ZONE_NORMAL + zid, delta)
+	__count_vm_events((item##_NORMAL + 0) - ZONE_NORMAL + zid, delta)
 
 /*
  * Zone and node-based page accounting with per cpu differentials.
@@ -515,7 +520,7 @@ static inline const char *node_stat_name
 
 static inline const char *lru_list_name(enum lru_list lru)
 {
-	return node_stat_name(NR_LRU_BASE + (enum node_stat_item)lru) + 3; // skip "nr_"
+	return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
 }
 
 #if defined(CONFIG_VM_EVENT_COUNTERS) || defined(CONFIG_MEMCG)
_

Patches currently in -mm which might be from bvanassche@acm.org are

procfs-fix-a-locking-bug-in-a-vmcore_add_device_dump-error-path.patch

