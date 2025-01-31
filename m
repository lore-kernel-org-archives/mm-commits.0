Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D9FF9FE
	for <mm-commits@vger.kernel.org>; Fri, 31 Jan 2025 21:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738359929; cv=none; b=gwEqEf4tqw/9F2TNkCxvbMXQjZLmECGPoUEQLz7Eue9bNFnq7rmq3ErHJbu2iFnD5Nh6gMm5Ri+4Atulaz2Om3G/M+PGEFyuATRKaYD62Q0ReozrtUe+y3wAexazwA5+s9crbpAlte9XQZIyrpTf6rG0GkCItrwFCLgbBFtfldc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738359929; c=relaxed/simple;
	bh=rbfb1xqPoYeAHg8oa7QfpxRg9NjcCsmhRiXGpNzLIy4=;
	h=Date:To:From:Subject:Message-Id; b=NBd7IhFS+NkRKnZpkIevsAHkQyTXXmJJfsMBoQrE6m0WZDHHUF909QR6ZhYYNRaq6JKa341hMotkX/Vxd2N+centEV7yUF//Yc+TI7EGYm4sEy4LMleaGsj2t1jLHBa+oO2CAYrlTk8O+UQD3LxCjx8ZTJ/KPCO+m7zzFZdVCd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tQeXsA+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tQeXsA+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C62CC4CED1;
	Fri, 31 Jan 2025 21:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738359928;
	bh=rbfb1xqPoYeAHg8oa7QfpxRg9NjcCsmhRiXGpNzLIy4=;
	h=Date:To:From:Subject:From;
	b=tQeXsA+5w4a2XHHE0q6fKc+Nu2F4iMTCkJgVOWuGK+0Kfg2z518UE0+ipEBkqvHe1
	 Umaw/GIi03GkMEohUzBtiPcWSsd4R2pO/oTGmbNjYd99k4W6F7BByaM9LJC/WMUfsF
	 kC+umojj6HHfv6Z5f+6LW4eC2v4RqJeu5QtqLEjU=
Date: Fri, 31 Jan 2025 13:45:27 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,souravpanda@google.com,rientjes@google.com,pasha.tatashin@soleen.com,nathan@kernel.org,kaiyang2@cs.cmu.edu,joel.granados@kernel.org,intelfx@intelfx.name,hannes@cmpxchg.org,david@redhat.com,david.laight@aculab.com,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-clang-w=1-compiler-warnings.patch added to mm-unstable branch
Message-Id: <20250131214528.5C62CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: Fix clang W=1 compiler warnings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-clang-w=1-compiler-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-clang-w=1-compiler-warnings.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Bart Van Assche <bvanassche@acm.org>
Subject: mm: Fix clang W=1 compiler warnings
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
Cc: Ivan Shapovalov <intelfx@intelfx.name>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
mm-fix-clang-w=1-compiler-warnings.patch

