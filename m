Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080702D879E
	for <mm-commits@vger.kernel.org>; Wed, 20 Aug 2025 21:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755726612; cv=none; b=mQWKcAADfQUiO3Zz3mGmJMzRgqcl+zpczh+WvTkUPvAsGfyi5UCtb7rD6w+U/EeY7O3JyNb3U5g9WUN0tVg/VA3/NRy/15i+USGSmxWzDruOaI91v6yqIkNr+lKG8tMNxZjnJZuo0PzU32viPNZQoJkzfCTDIq+rAwNH0hjIk7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755726612; c=relaxed/simple;
	bh=PffPjIy4Aq+vpkxC/OS2ZAblp1jstlimvafIohJMW8M=;
	h=Date:To:From:Subject:Message-Id; b=ThbiU5qUbUbfY7Cs6/sNhe0VaJdQPUl1tFtN2vwd5kg2fudKL8JqMO9S5EIJI2xVk4VHqZINXfTu5M/XR3P5kXtwge0JCTXoqYMuQKPZ2wIDTnEi1rDKYlSHuol6BlH+bVYOHPQIXjhkBdP/Il0TXNz5lOLtETYka0zXjPDWvXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zjP1nAfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zjP1nAfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B06C4CEE7;
	Wed, 20 Aug 2025 21:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755726610;
	bh=PffPjIy4Aq+vpkxC/OS2ZAblp1jstlimvafIohJMW8M=;
	h=Date:To:From:Subject:From;
	b=zjP1nAfNZ8F7ss1yyHodH7iIPlsmm18xBYcDLP0M2xsvY5EgOY37BccjPKLXXJDtV
	 CCyQli6/Hr+jV3dFvOEsagRKCaqTtod6uDY/5hg4ZRStfdiAkbI7ZZjXTcePdaaAgT
	 +ZhHNShTHx1KNE8OdDdxez85z5P0D3u+DK9vpyA0=
Date: Wed, 20 Aug 2025 14:50:09 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-tag-kernel-stack-pages.patch added to mm-new branch
Message-Id: <20250820215010.82B06C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: tag kernel stack pages
has been added to the -mm mm-new branch.  Its filename is
     mm-tag-kernel-stack-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-tag-kernel-stack-pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm: tag kernel stack pages
Date: Wed, 20 Aug 2025 13:20:29 -0700

Currently, we have no way to distinguish a kernel stack page from an
unidentified page.  Being able to track this information can be beneficial
for optimizing kernel memory usage (i.e.  analyzing fragmentation,
location etc.).  Knowing a page is being used for a kernel stack gives us
more insight about pages that are certainly immovable and important to
kernel functionality.

Add a new pagetype, and tag pages alongside the kernel stack accounting. 
Also, ensure the type is dumped to /proc/kpageflags and the page-types
tool can find it.

Link: https://lkml.kernel.org/r/20250820202029.1909925-1-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c                         |    3 ++-
 include/linux/page-flags.h             |    5 +++++
 include/uapi/linux/kernel-page-flags.h |    1 +
 kernel/fork.c                          |   19 +++++++++++++++++--
 tools/mm/page-types.c                  |    1 +
 5 files changed, 26 insertions(+), 3 deletions(-)

--- a/fs/proc/page.c~mm-tag-kernel-stack-pages
+++ a/fs/proc/page.c
@@ -201,7 +201,8 @@ u64 stable_page_flags(const struct page
 
 	if (ps.flags & PAGE_SNAPSHOT_PG_BUDDY)
 		u |= 1 << KPF_BUDDY;
-
+	if (folio_test_stack(folio))
+		u |= 1 << KPF_KSTACK;
 	if (folio_test_offline(folio))
 		u |= 1 << KPF_OFFLINE;
 	if (folio_test_pgtable(folio))
--- a/include/linux/page-flags.h~mm-tag-kernel-stack-pages
+++ a/include/linux/page-flags.h
@@ -933,6 +933,7 @@ enum pagetype {
 	PGTY_zsmalloc		= 0xf6,
 	PGTY_unaccepted		= 0xf7,
 	PGTY_large_kmalloc	= 0xf8,
+	PGTY_kstack		= 0xf9,
 
 	PGTY_mapcount_underflow = 0xff
 };
@@ -995,6 +996,10 @@ static __always_inline void __ClearPage#
 	page->page_type = UINT_MAX;					\
 }
 
+/* PageStack() indicates that a page is used by kernel stacks.
+ */
+PAGE_TYPE_OPS(Stack, kstack, stack)
+
 /*
  * PageBuddy() indicates that the page is free and in the buddy system
  * (see mm/page_alloc.c).
--- a/include/uapi/linux/kernel-page-flags.h~mm-tag-kernel-stack-pages
+++ a/include/uapi/linux/kernel-page-flags.h
@@ -36,5 +36,6 @@
 #define KPF_ZERO_PAGE		24
 #define KPF_IDLE		25
 #define KPF_PGTABLE		26
+#define KPF_KSTACK		27
 
 #endif /* _UAPILINUX_KERNEL_PAGE_FLAGS_H */
--- a/kernel/fork.c~mm-tag-kernel-stack-pages
+++ a/kernel/fork.c
@@ -440,15 +440,22 @@ static void account_kernel_stack(struct
 		struct vm_struct *vm_area = task_stack_vm_area(tsk);
 		int i;
 
-		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
+		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
 			mod_lruvec_page_state(vm_area->pages[i], NR_KERNEL_STACK_KB,
 					      account * (PAGE_SIZE / 1024));
+			__SetPageStack(vm_area->pages[i]);
+		}
 	} else {
 		void *stack = task_stack_page(tsk);
+		struct page *page = virt_to_head_page(stack);
+		int i;
 
 		/* All stack pages are in the same node. */
 		mod_lruvec_kmem_state(stack, NR_KERNEL_STACK_KB,
 				      account * (THREAD_SIZE / 1024));
+
+		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++, page++)
+			__SetPageStack(page);
 	}
 }
 
@@ -461,8 +468,16 @@ void exit_task_stack_account(struct task
 		int i;
 
 		vm_area = task_stack_vm_area(tsk);
-		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
+		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
 			memcg_kmem_uncharge_page(vm_area->pages[i], 0);
+			__ClearPageStack(vm_area->pages[i]);
+		}
+	} else {
+		struct page *page = virt_to_head_page(task_stack_page(tsk));
+		int i;
+
+		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++, page++)
+			__ClearPageStack(page);
 	}
 }
 
--- a/tools/mm/page-types.c~mm-tag-kernel-stack-pages
+++ a/tools/mm/page-types.c
@@ -127,6 +127,7 @@ static const char * const page_flag_name
 	[KPF_PGTABLE]		= "g:pgtable",
 	[KPF_ZERO_PAGE]		= "z:zero_page",
 	[KPF_IDLE]              = "i:idle_page",
+	[KPF_KSTACK]		= "k:kernel_stack",
 
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-tag-kernel-stack-pages.patch

