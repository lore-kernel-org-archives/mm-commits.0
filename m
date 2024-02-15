Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8FA13B294
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 23:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708040049; cv=none; b=obqw7f2MXa5jNO5FcQcAnPMgZBvP9Ei45MRlNvvv8lFNOruVeSizGqkmjDp06GW0+HNYycDTBxfJlf3trvAN69pDyPcXZ5ydYYlK9CeQvXDZeGziICi1hxc/N4Kr3nQt/BGbAuvi3FGyihITejvzkCt8B2xE10YzIQT/62fuNLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708040049; c=relaxed/simple;
	bh=RjRoIZhp3x7yxfpuSH3+4Vd0aZSX12zd8jzPaU/br6A=;
	h=Date:To:From:Subject:Message-Id; b=KbSfLtSX+ALC0RLZLi0JS0DuDWOfPMVASf0iYMEo1LWaiS2n8RBgwN9xz0S/MLVsfG0dD7MG6pnazleXn+YEZrZ4+Vm6Ie0huRiLvAkTtwji9oRxR6g5arKzykKsQF0j28KlnLg/RZOR/cbSf37Ip4BTl5QpcSMIl+i4Ob8JKW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EstsNqdb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EstsNqdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363F2C433C7;
	Thu, 15 Feb 2024 23:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708040048;
	bh=RjRoIZhp3x7yxfpuSH3+4Vd0aZSX12zd8jzPaU/br6A=;
	h=Date:To:From:Subject:From;
	b=EstsNqdb6B42Q2uNSir9o532yelhfMr0TnuetO1SLSafIb27c/LF0WED9KVsLA6ZU
	 SroT363MMsUUPnkDLJjQsRSJeHzI3po63Hr0dyhsQtnk6vCHYxWH+51P8gRGt71/8f
	 H05tOzEm64+E7qoEgvWwIEopM8vmDDCdXdzVHckg=
Date: Thu, 15 Feb 2024 15:34:07 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-fix-first-entry-having-a-0-handle.patch added to mm-unstable branch
Message-Id: <20240215233408.363F2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/stackdepot: fix first entry having a 0-handle
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-fix-first-entry-having-a-0-handle.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-fix-first-entry-having-a-0-handle.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: lib/stackdepot: fix first entry having a 0-handle
Date: Thu, 15 Feb 2024 22:59:01 +0100

Patch series "page_owner: print stacks and their outstanding allocations",
v10.

page_owner is a great debug functionality tool that lets us know about all
pages that have been allocated/freed and their specific stacktrace.  This
comes very handy when debugging memory leaks, since with some scripting we
can see the outstanding allocations, which might point to a memory leak.

In my experience, that is one of the most useful cases, but it can get
really tedious to screen through all pages and try to reconstruct the
stack <-> allocated/freed relationship, becoming most of the time a
daunting and slow process when we have tons of allocation/free operations.
 

This patchset aims to ease that by adding a new functionality into
page_owner.  This functionality creates a new directory called
'page_owner_stacks' under 'sys/kernel//debug' with a read-only file called
'show_stacks', which prints out all the stacks followed by their
outstanding number of allocations (being that the times the stacktrace has
allocated but not freed yet).  This gives us a clear and a quick overview
of stacks <-> allocated/free.

We take advantage of the new refcount_f field that stack_record struct
gained, and increment/decrement the stack refcount on every
__set_page_owner() (alloc operation) and __reset_page_owner (free
operation) call.

Unfortunately, we cannot use the new stackdepot api STACK_DEPOT_FLAG_GET
because it does not fulfill page_owner needs, meaning we would have to
special case things, at which point makes more sense for page_owner to do
its own {dec,inc}rementing of the stacks.  E.g: Using
STACK_DEPOT_FLAG_PUT, once the refcount reaches 0, such stack gets
evicted, so page_owner would lose information.

This patchset also creates a new file called 'set_threshold' within
'page_owner_stacks' directory, and by writing a value to it, the stacks
which refcount is below such value will be filtered out.

A PoC can be found below:

 # cat /sys/kernel/debug/page_owner_stacks/show_stacks > page_owner_full_stacks.txt
 # head -40 page_owner_full_stacks.txt 
  prep_new_page+0xa9/0x120
  get_page_from_freelist+0x801/0x2210
  __alloc_pages+0x18b/0x350
  alloc_pages_mpol+0x91/0x1f0
  folio_alloc+0x14/0x50
  filemap_alloc_folio+0xb2/0x100
  page_cache_ra_unbounded+0x96/0x180
  filemap_get_pages+0xfd/0x590
  filemap_read+0xcc/0x330
  blkdev_read_iter+0xb8/0x150
  vfs_read+0x285/0x320
  ksys_read+0xa5/0xe0
  do_syscall_64+0x80/0x160
  entry_SYSCALL_64_after_hwframe+0x6e/0x76
 stack_count: 521



  prep_new_page+0xa9/0x120
  get_page_from_freelist+0x801/0x2210
  __alloc_pages+0x18b/0x350
  alloc_pages_mpol+0x91/0x1f0
  folio_alloc+0x14/0x50
  filemap_alloc_folio+0xb2/0x100
  __filemap_get_folio+0x14a/0x490
  ext4_write_begin+0xbd/0x4b0 [ext4]
  generic_perform_write+0xc1/0x1e0
  ext4_buffered_write_iter+0x68/0xe0 [ext4]
  ext4_file_write_iter+0x70/0x740 [ext4]
  vfs_write+0x33d/0x420
  ksys_write+0xa5/0xe0
  do_syscall_64+0x80/0x160
  entry_SYSCALL_64_after_hwframe+0x6e/0x76
 stack_count: 4609
...
...

 # echo 5000 > /sys/kernel/debug/page_owner_stacks/set_threshold 
 # cat /sys/kernel/debug/page_owner_stacks/show_stacks > page_owner_full_stacks_5000.txt
 # head -40 page_owner_full_stacks_5000.txt 
  prep_new_page+0xa9/0x120
  get_page_from_freelist+0x801/0x2210
  __alloc_pages+0x18b/0x350
  alloc_pages_mpol+0x91/0x1f0
  folio_alloc+0x14/0x50
  filemap_alloc_folio+0xb2/0x100
  __filemap_get_folio+0x14a/0x490
  ext4_write_begin+0xbd/0x4b0 [ext4]
  generic_perform_write+0xc1/0x1e0
  ext4_buffered_write_iter+0x68/0xe0 [ext4]
  ext4_file_write_iter+0x70/0x740 [ext4]
  vfs_write+0x33d/0x420
  ksys_pwrite64+0x75/0x90
  do_syscall_64+0x80/0x160
  entry_SYSCALL_64_after_hwframe+0x6e/0x76
 stack_count: 6781



  prep_new_page+0xa9/0x120
  get_page_from_freelist+0x801/0x2210
  __alloc_pages+0x18b/0x350
  pcpu_populate_chunk+0xec/0x350
  pcpu_balance_workfn+0x2d1/0x4a0
  process_scheduled_works+0x84/0x380
  worker_thread+0x12a/0x2a0
  kthread+0xe3/0x110
  ret_from_fork+0x30/0x50
  ret_from_fork_asm+0x1b/0x30
 stack_count: 8641


This patch (of 7):

The very first entry of stack_record gets a handle of 0, but this is wrong
because stackdepot treats a 0-handle as a non-valid one.  E.g: See the
check in stack_depot_fetch()

Fix this by adding and offset of 1.

This bug has been lurking since the very beginning of stackdepot, but no
one really cared as it seems.  Because of that I am not adding a Fixes
tag.

Link: https://lkml.kernel.org/r/20240215215907.20121-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20240215215907.20121-2-osalvador@suse.de
Co-developed-by: Marco Elver <elver@google.com>
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-fix-first-entry-having-a-0-handle
+++ a/lib/stackdepot.c
@@ -45,15 +45,16 @@
 #define DEPOT_POOL_INDEX_BITS (DEPOT_HANDLE_BITS - DEPOT_OFFSET_BITS - \
 			       STACK_DEPOT_EXTRA_BITS)
 #define DEPOT_POOLS_CAP 8192
+/* The pool_index is offset by 1 so the first record does not have a 0 handle. */
 #define DEPOT_MAX_POOLS \
-	(((1LL << (DEPOT_POOL_INDEX_BITS)) < DEPOT_POOLS_CAP) ? \
-	 (1LL << (DEPOT_POOL_INDEX_BITS)) : DEPOT_POOLS_CAP)
+	(((1LL << (DEPOT_POOL_INDEX_BITS)) - 1 < DEPOT_POOLS_CAP) ? \
+	 (1LL << (DEPOT_POOL_INDEX_BITS)) - 1 : DEPOT_POOLS_CAP)
 
 /* Compact structure that stores a reference to a stack. */
 union handle_parts {
 	depot_stack_handle_t handle;
 	struct {
-		u32 pool_index	: DEPOT_POOL_INDEX_BITS;
+		u32 pool_index	: DEPOT_POOL_INDEX_BITS; /* pool_index is offset by 1 */
 		u32 offset	: DEPOT_OFFSET_BITS;
 		u32 extra	: STACK_DEPOT_EXTRA_BITS;
 	};
@@ -372,7 +373,7 @@ static struct stack_record *depot_pop_fr
 	stack = current_pool + pool_offset;
 
 	/* Pre-initialize handle once. */
-	stack->handle.pool_index = pool_index;
+	stack->handle.pool_index = pool_index + 1;
 	stack->handle.offset = pool_offset >> DEPOT_STACK_ALIGN;
 	stack->handle.extra = 0;
 	INIT_LIST_HEAD(&stack->hash_list);
@@ -483,18 +484,19 @@ static struct stack_record *depot_fetch_
 	const int pools_num_cached = READ_ONCE(pools_num);
 	union handle_parts parts = { .handle = handle };
 	void *pool;
+	u32 pool_index = parts.pool_index - 1;
 	size_t offset = parts.offset << DEPOT_STACK_ALIGN;
 	struct stack_record *stack;
 
 	lockdep_assert_not_held(&pool_lock);
 
-	if (parts.pool_index > pools_num_cached) {
+	if (pool_index > pools_num_cached) {
 		WARN(1, "pool index %d out of bounds (%d) for stack id %08x\n",
-		     parts.pool_index, pools_num_cached, handle);
+		     pool_index, pools_num_cached, handle);
 		return NULL;
 	}
 
-	pool = stack_pools[parts.pool_index];
+	pool = stack_pools[pool_index];
 	if (WARN_ON(!pool))
 		return NULL;
 
_

Patches currently in -mm which might be from osalvador@suse.de are

lib-stackdepot-fix-first-entry-having-a-0-handle.patch
lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch
mmpage_owner-maintain-own-list-of-stack_records-structs.patch
mmpage_owner-implement-the-tracking-of-the-stacks-count.patch
mmpage_owner-display-all-stacks-and-their-count.patch
mmpage_owner-filter-out-stacks-by-a-threshold.patch
mmpage_owner-update-documentation-regarding-page_owner_stacks.patch

