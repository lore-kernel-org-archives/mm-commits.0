Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23F0225413
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 07:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783236695; cv=none; b=XVuK64WN8aZ2nvjM1ATO+QuDYx1rxQ5yG/mUdI7LZjKdVhA0K76RGqfN++/S7WY8VsJmd6gqf8JX/QF7XNvk0CETX8ysloptRCD+EV00LEucTVJc/DUZcTVKpONUPz53f66BpmF8uJpI9bdH1NQi0XRYXxMJh+z409K7Xtvl3ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783236695; c=relaxed/simple;
	bh=f8FoVCRMUNxQegTBCrthci+jRubnw4HUIcxUd04aDbY=;
	h=Date:To:From:Subject:Message-Id; b=IicdqQZeliaajEmz8bbUVtbTl+g+Yd9D2nu3TU9s0uGXcwO6dbGlSMevjPLcXSez9bcVZokL8qNThtQma4BcJdGHcW/5hHILbNIFhWOlBJ1m2tHXeCoxLLeDZgsVNPrSH3hyi69UFfNkYOgCwDU4sNEWM7Y0gc2NnnoWoPbYd4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u8eVqidi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u8eVqidi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917DF1F000E9;
	Sun,  5 Jul 2026 07:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783236693;
	bh=gc7B7HGK/w+lH91F6pvNpK8qpXBo7KtCl67XN0ZJMW8=;
	h=Date:To:From:Subject;
	b=u8eVqidikQbxNJxBSkvvk1lqbAmlSZBNkQVENXO1xQPNOm4xa6fsrW1NHnqCn3hvC
	 bwI4n3C/rCdRWoyg+H9OdLWpDvv7bu3FXDYtFlVQ0s41OhH1XuimQPXWHrQjeqqcsY
	 LwnjIS6CMVaXEc9BNAn469F71bAHmyocsyaGixPE=
Date: Sun, 05 Jul 2026 00:31:33 -0700
To: mm-commits@vger.kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-some-stuff-to-mm-page_alloch.patch added to mm-new branch
Message-Id: <20260705073133.917DF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move some stuff to mm/page_alloc.h
has been added to the -mm mm-new branch.  Its filename is
     mm-move-some-stuff-to-mm-page_alloch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-some-stuff-to-mm-page_alloch.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm: move some stuff to mm/page_alloc.h
Date: Fri, 03 Jul 2026 12:31:47 +0000

Some of this stuff in the public header is only used internally so shrink
the scope to avoid silently growing new users.

drain_local_pages() is still used from kernel/power/snapshot.c so that
needs to stay behind.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-7-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   26 --------------------------
 mm/page_alloc.h     |   27 +++++++++++++++++++++++++++
 mm/vmstat.c         |    1 +
 3 files changed, 28 insertions(+), 26 deletions(-)

--- a/include/linux/gfp.h~mm-move-some-stuff-to-mm-page_alloch
+++ a/include/linux/gfp.h
@@ -17,28 +17,6 @@ struct mempolicy;
 #define __default_gfp(a,b,...) b
 #define default_gfp(...) __default_gfp(,##__VA_ARGS__,GFP_KERNEL)
 
-/* Convert GFP flags to their corresponding migrate type */
-#define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
-#define GFP_MOVABLE_SHIFT 3
-
-static inline int gfp_migratetype(const gfp_t gfp_flags)
-{
-	VM_WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
-	BUILD_BUG_ON((1UL << GFP_MOVABLE_SHIFT) != ___GFP_MOVABLE);
-	BUILD_BUG_ON((___GFP_MOVABLE >> GFP_MOVABLE_SHIFT) != MIGRATE_MOVABLE);
-	BUILD_BUG_ON((___GFP_RECLAIMABLE >> GFP_MOVABLE_SHIFT) != MIGRATE_RECLAIMABLE);
-	BUILD_BUG_ON(((___GFP_MOVABLE | ___GFP_RECLAIMABLE) >>
-		      GFP_MOVABLE_SHIFT) != MIGRATE_HIGHATOMIC);
-
-	if (unlikely(page_group_by_mobility_disabled))
-		return MIGRATE_UNMOVABLE;
-
-	/* Group based on mobility */
-	return (__force unsigned long)(gfp_flags & GFP_MOVABLE_MASK) >> GFP_MOVABLE_SHIFT;
-}
-#undef GFP_MOVABLE_MASK
-#undef GFP_MOVABLE_SHIFT
-
 static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
 {
 	return !!(gfp_flags & __GFP_DIRECT_RECLAIM);
@@ -395,10 +373,6 @@ extern void free_pages(unsigned long add
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
 
-void page_alloc_init_cpuhp(void);
-bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
-void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
-void drain_all_pages(struct zone *zone);
 void drain_local_pages(struct zone *zone);
 
 void page_alloc_init_late(void);
--- a/mm/page_alloc.h~mm-move-some-stuff-to-mm-page_alloch
+++ a/mm/page_alloc.h
@@ -266,6 +266,33 @@ static inline bool free_area_empty(struc
 	return list_empty(&area->free_list[migratetype]);
 }
 
+/* Convert GFP flags to their corresponding migrate type */
+#define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
+#define GFP_MOVABLE_SHIFT 3
+
+static inline int gfp_migratetype(const gfp_t gfp_flags)
+{
+	VM_WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
+	BUILD_BUG_ON((1UL << GFP_MOVABLE_SHIFT) != ___GFP_MOVABLE);
+	BUILD_BUG_ON((___GFP_MOVABLE >> GFP_MOVABLE_SHIFT) != MIGRATE_MOVABLE);
+	BUILD_BUG_ON((___GFP_RECLAIMABLE >> GFP_MOVABLE_SHIFT) != MIGRATE_RECLAIMABLE);
+	BUILD_BUG_ON(((___GFP_MOVABLE | ___GFP_RECLAIMABLE) >>
+		      GFP_MOVABLE_SHIFT) != MIGRATE_HIGHATOMIC);
+
+	if (unlikely(page_group_by_mobility_disabled))
+		return MIGRATE_UNMOVABLE;
+
+	/* Group based on mobility */
+	return (__force unsigned long)(gfp_flags & GFP_MOVABLE_MASK) >> GFP_MOVABLE_SHIFT;
+}
+#undef GFP_MOVABLE_MASK
+#undef GFP_MOVABLE_SHIFT
+
+bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
+void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
+void drain_all_pages(struct zone *zone);
+
+void page_alloc_init_cpuhp(void);
 void page_alloc_sysctl_init(void);
 
 #endif /* __MM_PAGE_ALLOC_H */
--- a/mm/vmstat.c~mm-move-some-stuff-to-mm-page_alloch
+++ a/mm/vmstat.c
@@ -30,6 +30,7 @@
 #include <linux/sched/isolation.h>
 
 #include "internal.h"
+#include "page_alloc.h"
 
 #ifdef CONFIG_PROC_FS
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-drop-flag-conversion-optimisation.patch
mm-secretmem-disable-under-highmem.patch
mm-page_alloc-rename-alloc_trylock-alloc_nolock.patch
mm-page_alloc-some-renames-to-clarify-alloc_flags-scopes.patch
mm-name-some-args-in-a-function-declaration.patch
mm-split-out-internal-page_alloch.patch
mm-page_alloc-unify-__alloc_frozen_pages_noprof.patch
mm-page_alloc-relax-gfp-warn-in-nolock-allocs.patch
mm-move-some-stuff-to-mm-page_alloch.patch
perf-x86-intel-use-higher-level-allocator-api.patch
kvm-vmx-use-higher-level-allocator-api.patch
x86-virt-use-higher-level-allocator-api.patch
sgi-xp-use-higher-level-allocator-api.patch
net-funeth-switch-to-higher-level-allocator-api.patch
mm-remove-__alloc_pages_node.patch
mm-move-__alloc_pages-to-mm-page_alloch.patch
mm-replace-__gfp_no_codetag-with-alloc_no_codetag.patch
mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma.patch
mm-factor-out-can_spin_trylock.patch

