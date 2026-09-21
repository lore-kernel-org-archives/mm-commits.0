Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3D2347BD9
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 04:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789963821; cv=none; b=D3lFG9t+ZVNcWVr8k7SXyFPf3IfpMXol0HpR0yLb2I8ykcd38AT2EmbVuJ1OlG5zTTnk5uT46BgoSu+qi/wVQDWgY5QYR5PJFt92J8kMURHDW0mN/hmOFNS7pMgOnchbDLG+FwZH6DoOgNIOLq5PkB4+eI7W7pUnKaR9i3dQ2UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789963821; c=relaxed/simple;
	bh=7wqipwVxhMal73Q7Ynmy7GtvyLFSF/C3CiMaFKCUOjM=;
	h=Date:To:From:Subject:Message-Id; b=X2mIigp0JtuHoqNUFr9B8lgoFPEZOb3uIrub6E/DgWoO5UwHSLCKzo+8bvWNNV7nCFjLALBH+WERHlp1WKj9aXtPiisJsJIF+v/MQVD+tSF4umLgQsNtTNIlCxLbhdjY1tjHpEWRCWKMGuwJuQLYVgU8dx14sQzYyUOkkuwSkck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WOkZc2Zm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WOkZc2Zm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B9D1F000FF;
	Mon, 21 Sep 2026 04:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789963819;
	bh=d4ZDnsKktnIrJtbKQDIlgj3QiWmIT8i7CPeEWlwhvOI=;
	h=Date:To:From:Subject;
	b=WOkZc2ZmKRZNPMSI588kgggw0RFDcYzfg1swKQP2vzlBquwzkNBJLQfB8FEpjXtEd
	 MOV2GlqKMIBP6dAPaHn1VZnk1++igjNGwEZljUMz1cAC95IStiiZiSW3JkBcqwp6Kc
	 XDvZTfS7evetjGFLmkaFXRuSPhxDWBN07i2YINPI=
Date: Sun, 20 Sep 2026 21:10:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-flags-remove-pg_private.patch added to mm-unstable branch
Message-Id: <20260921041019.64B9D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page-flags: remove PG_private
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page-flags-remove-pg_private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-flags-remove-pg_private.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page-flags: remove PG_private
Date: Sun, 20 Sep 2026 22:28:13 -0400

folio->private != NULL indicates a folio carries private data, replacing
PG_private.  All PG_private users are converted.  Remove PG_private and
reserve the space as PG_folio for future use.  Unused PG_private functions
are removed too.

Assisted-by: LLM
Link: https://lore.kernel.org/20260920-remove-pg_private-v5-17-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---

 include/linux/page-flags.h     |   18 +-----------------
 include/trace/events/mmflags.h |    2 +-
 kernel/vmcore_info.c           |    1 -
 3 files changed, 2 insertions(+), 19 deletions(-)

--- a/include/linux/page-flags.h~mm-page-flags-remove-pg_private
+++ a/include/linux/page-flags.h
@@ -44,10 +44,6 @@
  * Consequently, PG_reserved for a page mapped into user space can indicate
  * the zero page, the vDSO, MMIO pages or device memory.
  *
- * The PG_private bitflag is set on pagecache pages if they contain filesystem
- * specific data (which is normally at page->private). It can be used by
- * private allocations for its own usage.
- *
  * During initiation of disk I/O, PG_locked is set. This bit is set before I/O
  * and cleared when writeback _starts_ or when read _completes_. PG_writeback
  * is set before writeback starts and cleared when it finishes.
@@ -105,7 +101,7 @@ enum pageflags {
 	PG_owner_2,		/* Owner use. If pagecache, fs may use */
 	PG_arch_1,
 	PG_reserved,
-	PG_private,		/* If pagecache, has fs-private data */
+	PG_folio,		/* Do not use: reserved for folio identification */
 	PG_private_2,		/* If pagecache, has fs aux data */
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_swapbacked,		/* Page is backed by RAM/swap */
@@ -588,18 +584,6 @@ static __always_inline bool folio_test_p
 	return data_race(folio->private);
 }
 
-static __always_inline int PagePrivate(const struct page *page)
-{
-	/* See folio_test_private() for data_race() use */
-	return !!data_race(page->private);
-}
-
-/* no-ops during transition */
-static __always_inline void folio_set_private(struct folio *folio) { }
-static __always_inline void folio_clear_private(struct folio *folio) { }
-static __always_inline void SetPagePrivate(struct page *page) { }
-static __always_inline void ClearPagePrivate(struct page *page) { }
-
 FOLIO_FLAG(private_2, FOLIO_HEAD_PAGE)
 
 /* owner_2 can be set on tail pages for anon memory */
--- a/include/trace/events/mmflags.h~mm-page-flags-remove-pg_private
+++ a/include/trace/events/mmflags.h
@@ -144,7 +144,7 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 	DEF_PAGEFLAG_NAME(owner_2),					\
 	DEF_PAGEFLAG_NAME(arch_1),					\
 	DEF_PAGEFLAG_NAME(reserved),					\
-	DEF_PAGEFLAG_NAME(private),					\
+	DEF_PAGEFLAG_NAME(folio),					\
 	DEF_PAGEFLAG_NAME(private_2),					\
 	DEF_PAGEFLAG_NAME(writeback),					\
 	DEF_PAGEFLAG_NAME(head),					\
--- a/kernel/vmcore_info.c~mm-page-flags-remove-pg_private
+++ a/kernel/vmcore_info.c
@@ -216,7 +216,6 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
 	VMCOREINFO_NUMBER(PG_lru);
-	VMCOREINFO_NUMBER(PG_private);
 	VMCOREINFO_NUMBER(PG_swapcache);
 	VMCOREINFO_NUMBER(PG_swapbacked);
 #define PAGE_SLAB_MAPCOUNT_VALUE	(PGTY_slab << 24)
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-zsmalloc-replace-pg_private-with-pointer-comparison.patch
perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch
xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch
fscrypt-stop-setting-pg_private-on-bounce-page.patch
mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch
f2fs-stop-using-pg_private.patch
f2fs-convert-the-private-flag-helpers-to-folio-only.patch
erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private.patch
erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch
mm-page-flags-check-page-folio-private-instead-of-pg_private.patch
treewide-remove-folio_set-clear_private-usage.patch
ceph-replace-pageprivate-with-page_private.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

