Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60DAA2D
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 22:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741301671; cv=none; b=kuOlrbTPA7BcpZ0+bKwMpJ05G7rL5Z0b3HseoqnGo3NmVnwamkmkpo7D1XJNcR5NQ46Ixm+ADccJdmJeornAK0/AoX+/oJm+IpyyYSX9Y3bw1++agl3DoYFmJvGsxgVJgCVybLijrY4dPzOiffL8CUO1q5YW2Ni60sqKppX5AjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741301671; c=relaxed/simple;
	bh=Lgeuqx8JzJiIXhAzQblbCdzCC5EcHaV/oeAVNCZQ+uc=;
	h=Date:To:From:Subject:Message-Id; b=H1ZKM4RfiQCIXi9BL1K/7/RKkqQvDI195md49XCyW9gFZJIOYF3bKGR9C5JVedKhfgUJ7ztYaRj/swIggl1hefGgT4xdM7mWstM/37L7SrV2OS3sR80gHRw6ffkrkiSULxYZswfA3DtXxaMu4rf8Y0sfpbs3+8/TVcbsoOUo4Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZPFlII4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZPFlII4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA53C4CEE0;
	Thu,  6 Mar 2025 22:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741301671;
	bh=Lgeuqx8JzJiIXhAzQblbCdzCC5EcHaV/oeAVNCZQ+uc=;
	h=Date:To:From:Subject:From;
	b=ZPFlII4xTjRan6OJJy5fwXXCcZfq+tcMBx5FIlwvf279S9FXenW715w1HajGSLMZJ
	 UF22VsFzna0r7HMyC6EwR73tlaHzIz+0oHjdf/lO5gJ7VZNcKmuXlhiEJ8OLbyr6go
	 4mbJigHnESxzHqAqYbGAQ7Xw420n7dqswOtccII0=
Date: Thu, 06 Mar 2025 14:54:30 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,pasha.tatashin@soleen.com,muchun.song@linux.dev,hannes@cmpxchg.org,david@redhat.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ext-add-an-iteration-api-for-page-extensions.patch added to mm-unstable branch
Message-Id: <20250306225431.3DA53C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_ext: add an iteration API for page extensions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ext-add-an-iteration-api-for-page-extensions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-add-an-iteration-api-for-page-extensions.patch

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
From: Luiz Capitulino <luizcap@redhat.com>
Subject: mm: page_ext: add an iteration API for page extensions
Date: Thu, 6 Mar 2025 17:44:50 -0500

Patch series "mm: page_ext: Introduce new iteration API", v3.

Introduction
============

  [ Thanks to David Hildenbrand for identifying the root cause of this
    issue and proving guidance on how to fix it. The new API idea, bugs
    and misconceptions are all mine though ]

Currently, trying to reserve 1G pages with page_owner=on and sparsemem
causes a crash. The reproducer is very simple:

 1. Build the kernel with CONFIG_SPARSEMEM=y and the table extensions
 2. Pass 'default_hugepagesz=1 page_owner=on' in the kernel command-line
 3. Reserve one 1G page at run-time, this should crash (see patch 1 for
    backtrace) 

 [ A crash with page_table_check is also possible, but harder to trigger ]

Apparently, starting with commit cf54f310d0d3 ("mm/hugetlb: use __GFP_COMP
for gigantic folios") we now pass the full allocation order to page
extension clients and the page extension implementation assumes that all
PFNs of an allocation range will be stored in the same memory section (which
is not true for 1G pages).

To fix this, this series introduces a new iteration API for page extension
objects. The API checks if the next page extension object can be retrieved
from the current section or if it needs to look up for it in another
section.

Please, find all details in patch 1.

I tested this series on arm64 and x86 by reserving 1G pages at run-time
and doing kernel builds (always with page_owner=on and page_table_check=on).


This patch (of 3):

The page extension implementation assumes that all page extensions of a
given page order are stored in the same memory section.  The function
page_ext_next() relies on this assumption by adding an offset to the
current object to return the next adjacent page extension.

This behavior works as expected for flatmem but fails for sparsemem when
using 1G pages.  The commit cf54f310d0d3 ("mm/hugetlb: use __GFP_COMP for
gigantic folios") exposes this issue, making it possible for a crash when
using page_owner or page_table_check page extensions.

The problem is that for 1G pages, the page extensions may span memory
section boundaries and be stored in different memory sections.  This issue
was not visible before commit cf54f310d0d3 ("mm/hugetlb: use __GFP_COMP
for gigantic folios") because alloc_contig_pages() never passed more than
MAX_PAGE_ORDER to post_alloc_hook().  However, the series introducing
mentioned commit changed this behavior allowing the full 1G page order to
be passed.

Reproducer:

 1. Build the kernel with CONFIG_SPARSEMEM=y and table extensions
    support
 2. Pass 'default_hugepagesz=1 page_owner=on' in the kernel command-line
 3. Reserve one 1G page at run-time, this should crash (backtrace below)

To address this issue, this commit introduces a new API for iterating
through page extensions.  The main iteration macro is for_each_page_ext()
and it must be called with the RCU read lock taken.  Here's an usage
example:

"""
struct page_ext_iter iter;
struct page_ext *page_ext;

...

rcu_read_lock();
for_each_page_ext(page, 1 << order, page_ext, iter) {
	struct my_page_ext *obj = get_my_page_ext_obj(page_ext);
	...
}
rcu_read_unlock();
"""

The loop construct uses page_ext_iter_next() which checks to see if we
have crossed sections in the iteration.  In this case,
page_ext_iter_next() retrieves the next page_ext object from another
section.

Thanks to David Hildenbrand for helping identify the root cause and
providing suggestions on how to fix and optmize the solution (final
implementation and bugs are all mine through).

Lastly, here's the backtrace, without kasan you can get random crashes:

[   76.052526] BUG: KASAN: slab-out-of-bounds in __update_page_owner_handle+0x238/0x298
[   76.060283] Write of size 4 at addr ffff07ff96240038 by task tee/3598
[   76.066714]
[   76.068203] CPU: 88 UID: 0 PID: 3598 Comm: tee Kdump: loaded Not tainted 6.13.0-rep1 #3
[   76.076202] Hardware name: WIWYNN Mt.Jade Server System B81.030Z1.0007/Mt.Jade Motherboard, BIOS 2.10.20220810 (SCP: 2.10.20220810) 2022/08/10
[   76.088972] Call trace:
[   76.091411]  show_stack+0x20/0x38 (C)
[   76.095073]  dump_stack_lvl+0x80/0xf8
[   76.098733]  print_address_description.constprop.0+0x88/0x398
[   76.104476]  print_report+0xa8/0x278
[   76.108041]  kasan_report+0xa8/0xf8
[   76.111520]  __asan_report_store4_noabort+0x20/0x30
[   76.116391]  __update_page_owner_handle+0x238/0x298
[   76.121259]  __set_page_owner+0xdc/0x140
[   76.125173]  post_alloc_hook+0x190/0x1d8
[   76.129090]  alloc_contig_range_noprof+0x54c/0x890
[   76.133874]  alloc_contig_pages_noprof+0x35c/0x4a8
[   76.138656]  alloc_gigantic_folio.isra.0+0x2c0/0x368
[   76.143616]  only_alloc_fresh_hugetlb_folio.isra.0+0x24/0x150
[   76.149353]  alloc_pool_huge_folio+0x11c/0x1f8
[   76.153787]  set_max_huge_pages+0x364/0xca8
[   76.157961]  __nr_hugepages_store_common+0xb0/0x1a0
[   76.162829]  nr_hugepages_store+0x108/0x118
[   76.167003]  kobj_attr_store+0x3c/0x70
[   76.170745]  sysfs_kf_write+0xfc/0x188
[   76.174492]  kernfs_fop_write_iter+0x274/0x3e0
[   76.178927]  vfs_write+0x64c/0x8e0
[   76.182323]  ksys_write+0xf8/0x1f0
[   76.185716]  __arm64_sys_write+0x74/0xb0
[   76.189630]  invoke_syscall.constprop.0+0xd8/0x1e0
[   76.194412]  do_el0_svc+0x164/0x1e0
[   76.197891]  el0_svc+0x40/0xe0
[   76.200939]  el0t_64_sync_handler+0x144/0x168
[   76.205287]  el0t_64_sync+0x1ac/0x1b0

Link: https://lkml.kernel.org/r/cover.1741301089.git.luizcap@redhat.com
Link: https://lkml.kernel.org/r/a45893880b7e1601082d39d2c5c8b50bcc096305.1741301089.git.luizcap@redhat.com
Fixes: cf54f310d0d3 ("mm/hugetlb: use __GFP_COMP for gigantic folios")
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |   93 +++++++++++++++++++++++++++++++++++++
 mm/page_ext.c            |   13 +++++
 2 files changed, 106 insertions(+)

--- a/include/linux/page_ext.h~mm-page_ext-add-an-iteration-api-for-page-extensions
+++ a/include/linux/page_ext.h
@@ -3,6 +3,7 @@
 #define __LINUX_PAGE_EXT_H
 
 #include <linux/types.h>
+#include <linux/mmzone.h>
 #include <linux/stacktrace.h>
 
 struct pglist_data;
@@ -69,16 +70,31 @@ extern void page_ext_init(void);
 static inline void page_ext_init_flatmem_late(void)
 {
 }
+
+static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
+{
+	/*
+	 * page_ext is allocated per memory section. Once we cross a
+	 * memory section, we have to fetch the new pointer.
+	 */
+	return next_pfn % PAGES_PER_SECTION;
+}
 #else
 extern void page_ext_init_flatmem(void);
 extern void page_ext_init_flatmem_late(void);
 static inline void page_ext_init(void)
 {
 }
+
+static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
+{
+	return true;
+}
 #endif
 
 extern struct page_ext *page_ext_get(const struct page *page);
 extern void page_ext_put(struct page_ext *page_ext);
+extern struct page_ext *page_ext_lookup(unsigned long pfn);
 
 static inline void *page_ext_data(struct page_ext *page_ext,
 				  struct page_ext_operations *ops)
@@ -93,6 +109,83 @@ static inline struct page_ext *page_ext_
 	return next;
 }
 
+struct page_ext_iter {
+	unsigned long index;
+	unsigned long start_pfn;
+	struct page_ext *page_ext;
+};
+
+/**
+ * page_ext_iter_begin() - Prepare for iterating through page extensions.
+ * @iter: page extension iterator.
+ * @pfn: PFN of the page we're interested in.
+ *
+ * Must be called with RCU read lock taken.
+ *
+ * Return: NULL if no page_ext exists for this page.
+ */
+static inline struct page_ext *page_ext_iter_begin(struct page_ext_iter *iter,
+						unsigned long pfn)
+{
+	iter->index = 0;
+	iter->start_pfn = pfn;
+	iter->page_ext = page_ext_lookup(pfn);
+
+	return iter->page_ext;
+}
+
+/**
+ * page_ext_iter_next() - Get next page extension
+ * @iter: page extension iterator.
+ *
+ * Must be called with RCU read lock taken.
+ *
+ * Return: NULL if no next page_ext exists.
+ */
+static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter)
+{
+	unsigned long pfn;
+
+	if (WARN_ON_ONCE(!iter->page_ext))
+		return NULL;
+
+	iter->index++;
+	pfn = iter->start_pfn + iter->index;
+
+	if (page_ext_iter_next_fast_possible(pfn))
+		iter->page_ext = page_ext_next(iter->page_ext);
+	else
+		iter->page_ext = page_ext_lookup(pfn);
+
+	return iter->page_ext;
+}
+
+/**
+ * page_ext_iter_get() - Get current page extension
+ * @iter: page extension iterator.
+ *
+ * Return: NULL if no page_ext exists for this iterator.
+ */
+static inline struct page_ext *page_ext_iter_get(const struct page_ext_iter *iter)
+{
+	return iter->page_ext;
+}
+
+/**
+ * for_each_page_ext(): iterate through page_ext objects.
+ * @__page: the page we're interested in
+ * @__pgcount: how many pages to iterate through
+ * @__page_ext: struct page_ext pointer where the current page_ext
+ *              object is returned
+ * @__iter: struct page_ext_iter object (defined in the stack)
+ *
+ * IMPORTANT: must be called with RCU read lock taken.
+ */
+#define for_each_page_ext(__page, __pgcount, __page_ext, __iter) \
+	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page));\
+		__page_ext && __iter.index < __pgcount;          \
+		__page_ext = page_ext_iter_next(&__iter))
+
 #else /* !CONFIG_PAGE_EXTENSION */
 struct page_ext;
 
--- a/mm/page_ext.c~mm-page_ext-add-an-iteration-api-for-page-extensions
+++ a/mm/page_ext.c
@@ -508,6 +508,19 @@ void __meminit pgdat_page_ext_init(struc
 #endif
 
 /**
+ * page_ext_lookup() - Lookup a page extension for a PFN.
+ * @pfn: PFN of the page we're interested in.
+ *
+ * Must be called with RCU read lock taken and @pfn must be valid.
+ *
+ * Return: NULL if no page_ext exists for this page.
+ */
+struct page_ext *page_ext_lookup(unsigned long pfn)
+{
+	return lookup_page_ext(pfn_to_page(pfn));
+}
+
+/**
  * page_ext_get() - Get the extended information for a page.
  * @page: The page we're interested in.
  *
_

Patches currently in -mm which might be from luizcap@redhat.com are

mm-page_ext-add-an-iteration-api-for-page-extensions.patch
mm-page_table_check-use-new-iteration-api.patch
mm-page_owner-use-new-iteration-api.patch

