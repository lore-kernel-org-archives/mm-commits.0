Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E6D35F191
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 07:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783236710; cv=none; b=IaOJxhDe8OpRX1I0ggEhwRoKBBMF+d4iLSd2Ud0DHNoEAhtmwoNEfiV/8tKb6oKLboz50nylBvxHQKUraca6+OHAjNjLsvcKdg0gwkfuCW69e/0LvVsV1iV1HB35EL3JqWbP2B6fpws5kNnKWTT7/dFM0El9/X6djk0UzxQyMq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783236710; c=relaxed/simple;
	bh=A6+UhMq3dM5Kk7v5YgTFfVJ4GdQAzzxbYJ2Zi2ytUkk=;
	h=Date:To:From:Subject:Message-Id; b=d8NsCA4q0Fw+NwXqxl0GjalGgOdkKHg90NRn8QQcJB8rKkg03OG9zlWd1LTSX/Wvils/vIhByr5/ny+RM+XxhlnCXRUm4Q/kadP6wXyJbBwoFbHhBWJ9XpyVPowm/Wv1QQ7SYjhQKt4wy2B1Y4MvTLw3R++6DUFLCJWKVsrTwrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S4QJnMCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S4QJnMCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843321F000E9;
	Sun,  5 Jul 2026 07:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783236708;
	bh=ykaWsQrGqs9eeKFTQjljTLjgVm1stQZ14SmXnTRmQcA=;
	h=Date:To:From:Subject;
	b=S4QJnMCRKav7cGjVE08i6g2XcVe2az3MhLhOfGzX5uwDGjuIy8RR6ftaKGsvxyNSE
	 3EzQrdHdcgCisakdVLpA3/6CwQ4AAEAj4JaTl43QtoJeZ89zTSjoUX/DyPRa+2MYBO
	 Pcdyy86w07hxMEN+V4SWDhqSdTSrQ+PEIwTpL2cc=
Date: Sun, 05 Jul 2026 00:31:48 -0700
To: mm-commits@vger.kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-__alloc_pages-to-mm-page_alloch.patch added to mm-new branch
Message-Id: <20260705073148.843321F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move __alloc_pages() to mm/page_alloc.h
has been added to the -mm mm-new branch.  Its filename is
     mm-move-__alloc_pages-to-mm-page_alloch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-__alloc_pages-to-mm-page_alloch.patch

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
Subject: mm: move __alloc_pages() to mm/page_alloc.h
Date: Fri, 03 Jul 2026 12:31:54 +0000

It's no longer used outside of mm/.

Since this means __alloc_pages_noprof() is no longer visible from gfp.h,
this also means moving the definition of alloc_pages_node_noprof into
the .c file.

Also remove references to this API from the documentation tree -
referring to the specific function name was already questionable but
now the function is not even public it definitely seems wrong.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-14-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/cpusets.rst |    2 -
 Documentation/admin-guide/mm/transhuge.rst      |    2 -
 include/linux/gfp.h                             |   16 --------------
 mm/page_alloc.c                                 |   13 ++++++++++-
 mm/page_alloc.h                                 |    4 +++
 5 files changed, 19 insertions(+), 18 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/cpusets.rst~mm-move-__alloc_pages-to-mm-page_alloch
+++ a/Documentation/admin-guide/cgroup-v1/cpusets.rst
@@ -284,7 +284,7 @@ take action.
 ==>
     Unless this feature is enabled by writing "1" to the special file
     /dev/cpuset/memory_pressure_enabled, the hook in the rebalance
-    code of __alloc_pages() for this metric reduces to simply noticing
+    code of the page allocator for this metric reduces to simply noticing
     that the cpuset_memory_pressure_enabled flag is zero.  So only
     systems that enable this feature will compute the metric.
 
--- a/Documentation/admin-guide/mm/transhuge.rst~mm-move-__alloc_pages-to-mm-page_alloch
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -761,7 +761,7 @@ compact_fail
 	but failed.
 
 It is possible to establish how long the stalls were using the function
-tracer to record how long was spent in __alloc_pages() and
+tracer to record how long was spent in the page allocator and
 using the mm_page_alloc tracepoint to identify which allocations were
 for huge pages.
 
--- a/include/linux/gfp.h~mm-move-__alloc_pages-to-mm-page_alloch
+++ a/include/linux/gfp.h
@@ -204,10 +204,6 @@ static inline void arch_free_page(struct
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
-struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask);
-#define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
-
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
 		nodemask_t *nodemask);
 #define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
@@ -272,17 +268,7 @@ struct folio *__folio_alloc_node_noprof(
  * prefer the current CPU's closest node. Otherwise node must be valid and
  * online.
  */
-static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
-						   unsigned int order)
-{
-	if (nid == NUMA_NO_NODE)
-		nid = numa_mem_id();
-
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
-	warn_if_node_offline(nid, gfp_mask);
-
-	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
-}
+struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order);
 
 #define  alloc_pages_node(...)			alloc_hooks(alloc_pages_node_noprof(__VA_ARGS__))
 
--- a/mm/page_alloc.c~mm-move-__alloc_pages-to-mm-page_alloch
+++ a/mm/page_alloc.c
@@ -5431,7 +5431,18 @@ struct page *__alloc_pages_noprof(gfp_t
 		set_page_refcounted(page);
 	return page;
 }
-EXPORT_SYMBOL(__alloc_pages_noprof);
+
+struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order)
+{
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
+
+	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
+	warn_if_node_offline(nid, gfp_mask);
+
+	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
+}
+EXPORT_SYMBOL(alloc_pages_node_noprof);
 
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
 		nodemask_t *nodemask)
--- a/mm/page_alloc.h~mm-move-__alloc_pages-to-mm-page_alloch
+++ a/mm/page_alloc.h
@@ -244,6 +244,10 @@ struct page *alloc_frozen_pages_nolock_n
 	alloc_hooks(alloc_frozen_pages_nolock_noprof(__VA_ARGS__))
 void free_frozen_pages_nolock(struct page *page, unsigned int order);
 
+struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
+		nodemask_t *nodemask);
+#define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
+
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
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

