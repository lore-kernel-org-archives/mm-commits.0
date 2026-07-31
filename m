Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A0D33938D
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465812; cv=none; b=FDT5SFHfLVTDniBISn74O9xPDbfhXwG4NB173g9Nrue0fyfMbFJmPLs4vREME4A3Upovo+brbh9fTEsaABnISqAYbblLv5T4nyx2agfUpoEQMSd1R853hF8GuBN6tYBVI+KKaAjyIy8IYjX6vLJN6xkS/EaX7wVHZq0gOnUUMOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465812; c=relaxed/simple;
	bh=Sm6L6Npy0Ws6AVNDkzrxiqZ8rsHQDYFpASSi/KD+GqY=;
	h=Date:To:From:Subject:Message-Id; b=UQvE1NlcO6QGOtz/dXpL8FS6v2zuQ6E7MqdJHXyM/SEAAgd7voSQbfi3as4tm/YLgQElRtmlb4kjRdC5EvbQW0v0Zh0FeNvK4tOvAInV4FGWwsBNz7MQjTcW+jpB1i+gKP9AEIRLBt53W3JgumU7tu4cCfgIXYrizkVwNyJnPUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yuEMfmB2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yuEMfmB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0A11F00A3A;
	Fri, 31 Jul 2026 02:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465811;
	bh=17G4QQj7xuLpakTwcljNZ+JVQS2TXahcy5v+TC6mb+o=;
	h=Date:To:From:Subject;
	b=yuEMfmB26krosPDiwz/OnDaa7/TcYbLEm+tIk9nkMEQIjWeRuQzFLwAQ25Eal5GYM
	 NLWaYrsPX8jQ6SnWQ5wmuu8w0ad/6AnwDlC7yzQhxYQnzuX/nHGfd5mZos77KAn6YA
	 ePAgi6bZq92ANNIigXgc6/KqY+MmUBQBft2aSrMc=
Date: Thu, 30 Jul 2026 19:43:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-__alloc_pages-to-mm-page_alloch.patch removed from -mm tree
Message-Id: <20260731024331.0A0A11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move __alloc_pages() to mm/page_alloc.h
has been removed from the -mm tree.  Its filename was
     mm-move-__alloc_pages-to-mm-page_alloch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-secretmem-dont-allow-highmem-folios.patch
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

