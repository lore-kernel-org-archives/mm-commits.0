Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B9C331ED3
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 03:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961507; cv=none; b=R9yuNvCk5yPA73yo9DhFUh2Hs23Negb5/ZjTUtMv1m2DWkkv2Jh7fTLkMgGhUnR/cDy/S7pbGpCvwy0/PrgkOTjC0Cb+IC0f4iwo1uzA3/Q3Og26VXLd8gY4QZlq+bd4x8qQUTryJ8gylbpmx2X2BVYKnq7cOsM4uvCIu91cv2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961507; c=relaxed/simple;
	bh=KnfIQ9bbO4DStFoJM59q0wYwiXSqjtWU75RfAWH165c=;
	h=Date:To:From:Subject:Message-Id; b=MZuRqTganQeU9iibnG4A2rbA/xRCLB2TkLoI3v72qFa2YZae4x6HoWNjnMgCUPltYzRS10RMWyScKVBU3hE9tbADIYDdORSDPNRxXColchxPoN3GOSvLzpMoXKpDeGCKailq9cJR8hYwns4mSRB/+soTX6xSgpkH/Fmd5TO7Waw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qj2RDwYW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qj2RDwYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBD51F000FF;
	Mon, 21 Sep 2026 03:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789961506;
	bh=O7rvNuAUevfo1MhOmjjz1g3SmOJQlkR+XP6Uf+fdjyE=;
	h=Date:To:From:Subject;
	b=Qj2RDwYWyvGxyjdxTiunWxWlm8udRWKeg9Eoe+PKzhqmRLK/P9zdoYmAUvVajsrAv
	 FkQbZDUs6KKNlesmbooqV+Z3eviCrPa0NFnliTh26dRFqrg/elRBvc866WclagANEM
	 52V+JEBsrt2jFjeemLC0FqVd1mNulmN+QneTymDI=
Date: Sun, 20 Sep 2026 20:31:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page-flags-remove-pg_private.patch removed from -mm tree
Message-Id: <20260921033146.3DBD51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page-flags: remove PG_private
has been removed from the -mm tree.  Its filename was
     mm-page-flags-remove-pg_private.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page-flags: remove PG_private
Date: Sun, 13 Sep 2026 22:24:14 -0400

folio->private != NULL indicates a folio carries private data, replacing
PG_private.  All PG_private users are converted.  Remove PG_private and
reserve the space as PG_folio for future use.  Unused PG_private functions
are removed too.

Assisted-by: LLM
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-16-848550f7574e@nvidia.com
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

 include/linux/page-flags.h     |   19 ++-----------------
 include/trace/events/mmflags.h |    2 +-
 kernel/vmcore_info.c           |    1 -
 3 files changed, 3 insertions(+), 19 deletions(-)

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
@@ -575,7 +571,7 @@ FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
 /*
  * Private page markings that may be used by the filesystem that owns the page
  * for its own purposes.
- * - PG_private and PG_private_2 cause release_folio() and co to be invoked
+ * - folio->private and PG_private_2 cause release_folio() and co to be invoked
  */
 
 static __always_inline bool folio_test_private(const struct folio *folio)
@@ -583,17 +579,6 @@ static __always_inline bool folio_test_p
 	return folio->private;
 }
 
-static __always_inline int PagePrivate(const struct page *page)
-{
-	return !!page->private;
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

usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

