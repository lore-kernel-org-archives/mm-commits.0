Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C63426438
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525596; cv=none; b=dIPpfXiQhJxkzQsdFFWc1CWedkapGBeOedpTyCRmfNKV1wOUyZBJbdt7y6Mg5wcIrU50CaVu5LwqOTNwDABjQjetKznFH74usDiv3cBMzF023kj+x9glx/eLFNKAAHouQyREOkswCYkrotCL+cliUuchuWTA/P8Kc3RiCdAE4Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525596; c=relaxed/simple;
	bh=8vwpzqgPzP3Lkini+SH8nVio3ASvOznNjImZxgC1Dqk=;
	h=Date:To:From:Subject:Message-Id; b=lqzvF21K7fb5WalGFsNxVJ4ZQadmoJdWmoGcG5IXfbbtItP42l+S6aLGsM/qYXMVyx0+97jcDgRrxd9C4nUx5UD/Cb6d834C3026FoxCvHdRLAiJcs3J/LSFtuGXH80DMrpDokMzaeqg/x8mieP3DpErl9Y9Cawnk4K03Df/jL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m9hPqvM1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m9hPqvM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8EC1F000FF;
	Fri,  9 Oct 2026 05:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525590;
	bh=RGv0gyYI/pDwvxCGcS3yu6l7/mrUmt8yjLLUrilM0Eo=;
	h=Date:To:From:Subject;
	b=m9hPqvM10jkGb7YFnFbU5LMuK/YNX+dJHagYPTY5fr+qEe3ZyNH/BRkyGVxsHv0UO
	 ZRrCYYUBH0BM0QiZsYEt3Iuatld16Y9jf3PXzYUlFApED9d2YDCjSMvJIk8/mLZrE9
	 bJV8R7o9+nCbl2TLhqgppygMwFuX7Jmn2VIGMASw=
Date: Thu, 08 Oct 2026 22:59:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,ruirui.yang@linux.dev,rppt@kernel.org,rostedt@goodmis.org,pratyush@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,jack@suse.cz,david@kernel.org,corbet@lwn.net,baoquan.he@linux.dev,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page-flags-remove-pg_private.patch removed from -mm tree
Message-Id: <20261009055950.3F8EC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page-flags: remove PG_private
has been removed from the -mm tree.  Its filename was
     mm-page-flags-remove-pg_private.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page-flags: remove PG_private
Date: Sun, 20 Sep 2026 22:28:13 -0400

folio->private != NULL indicates a folio carries private data, replacing
PG_private.  All PG_private users are converted.  Remove PG_private and
reserve the space as PG_folio for future use.  Unused PG_private functions
are removed too.

Link: https://lore.kernel.org/20260920-remove-pg_private-v5-17-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
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


