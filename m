Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95822C0268;
	Thu,  2 Jul 2026 02:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957819; cv=none; b=GMzwwiVIJQO0UAyqcK8+nvXR7/NioYKccD2wnV2vaGIejULVfdP0+5O5nn192RolXnTYFwqOTRfoyFY17D/JxjLFlfBK5EZ9eObMA0FYXhKFjVqcLE3XV5BYA3j3gvJi3ggAOcQ3Fe+xBznnIMijg+2+GPaxCsTnbTo7SRqfgYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957819; c=relaxed/simple;
	bh=0E5/Qy4NS5/UKj3zIql3QL3cRmqjt0otCSTgfiSNF+A=;
	h=Date:To:From:Subject:Message-Id; b=qi5UfwpbRz+7YPGgFjGcOQ7jivDeScUMWjQ1iOkwwQgH41Ln6x1XFqVF7qX5bVKfbcPcfbVCb7bg4KQ5fE1tQwLxCKnrRgtYoXqd6voHQvj4ZOkcY80k54aNC/JHHynujCryJqSYonOefP7dQMokTqQHspHDVpXDKbYBM7ON+Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nbKPJViw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nbKPJViw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4451F00A3A;
	Thu,  2 Jul 2026 02:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782957817;
	bh=A1nMR+lL5N39L7ZXZcjAeXV60HSJwat3K5dE6Jcb2BI=;
	h=Date:To:From:Subject;
	b=nbKPJViw2xJDgjWtBEufphtrNV+CyGV63gPgqWxu4psho/ivK837j/xRNXznygoTV
	 xMDN1XM9E5eauAL/Gz6TsVT7AAIBCmyRd8KwcrEbWhnauTMC12o/JheNc1pJaJ98xI
	 KRxTTX2C+eeokwLlE8o1SLoBmTtdLLzzET3LCkPU=
Date: Wed, 01 Jul 2026 19:03:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,david@kernel.org,ketan.kishore@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_ext-add-count-limit-to-page_ext_iter_next-to-prevent-invalid-pfn-access.patch removed from -mm tree
Message-Id: <20260702020337.6A4451F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_ext: add count limit to page_ext_iter_next to prevent invalid PFN access
has been removed from the -mm tree.  Its filename was
     mm-page_ext-add-count-limit-to-page_ext_iter_next-to-prevent-invalid-pfn-access.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ketan <ketan.kishore@oss.qualcomm.com>
Subject: mm: page_ext: add count limit to page_ext_iter_next to prevent invalid PFN access
Date: Tue, 23 Jun 2026 02:48:04 +0530

The page_ext iteration API does not validate if the PFN still belongs to a
valid section while advancing the iterator.  When dynamically adding
memory in the hotplug path, it can lead to a NULL pointer dereference
during page_ext_lookup at the boundary of the last valid section when
iterator count equals __pgcount.

The for_each_page_ext() macro calls page_ext_iter_next() as its loop
increment.  for_each_page_ext() does a "__page_ext =
page_ext_iter_next(&__iter)" at the end.  This causes page_ext_iter_next()
to increment iter->index past __pgcount and call page_ext_lookup(start_pfn
+ __pgcount).  During memory hotplug (online), the PFN at start_pfn +
__pgcount may belong to a section that has not yet been initialized,
causing page_ext_lookup() to trigger a NULL pointer dereference.

[   14.555124][  T846] Call trace:
[   14.555125][  T846]  lookup_page_ext+0x6c/0x108 (P)
[   14.555127][  T846]  page_ext_lookup+0x30/0x3c
[   14.555129][  T846]  __reset_page_owner+0x11c/0x260
[   14.571201][  T846]  __free_pages_ok+0x5e8/0x8e0
[   14.571204][  T846]  __free_pages_core+0x78/0xf0
[   14.571206][  T846]  generic_online_page+0x14/0x24
[   14.597782][  T846]  online_pages+0x178/0x30c
[   14.597784][  T846]  memory_block_change_state+0x284/0x32c
[   14.597787][  T846]  memory_subsys_online+0x4c/0x64
[   14.597789][  T846]  device_online+0x88/0xb0
[   14.597791][  T846]  online_memory_block+0x30/0x40
[   14.597793][  T846]  walk_memory_blocks+0xac/0xe8
[   14.597794][  T846]  add_memory_resource+0x280/0x298
[   14.656161][  T846]  add_memory+0x60/0x98

Move the iteration boundary enforcement inside the iterator functions, so
callers cannot inadvertently access beyond the requested range.

Link: https://lore.kernel.org/20260623-page_ext-v3-1-a89799a5367c@oss.qualcomm.com
Fixes: 9039b9096ea2 ("mm: page_ext: add an iteration API for page extensions")
Signed-off-by: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/include/linux/page_ext.h~mm-page_ext-add-count-limit-to-page_ext_iter_next-to-prevent-invalid-pfn-access
+++ a/include/linux/page_ext.h
@@ -120,14 +120,18 @@ struct page_ext_iter {
  * page_ext_iter_begin() - Prepare for iterating through page extensions.
  * @iter: page extension iterator.
  * @pfn: PFN of the page we're interested in.
+ * @count: maximum number of page extensions to return.
  *
  * Must be called with RCU read lock taken.
  *
  * Return: NULL if no page_ext exists for this page.
  */
 static inline struct page_ext *page_ext_iter_begin(struct page_ext_iter *iter,
-						unsigned long pfn)
+		unsigned long pfn, unsigned long count)
 {
+	if (!count)
+		return NULL;
+
 	iter->index = 0;
 	iter->start_pfn = pfn;
 	iter->page_ext = page_ext_lookup(pfn);
@@ -138,19 +142,22 @@ static inline struct page_ext *page_ext_
 /**
  * page_ext_iter_next() - Get next page extension
  * @iter: page extension iterator.
+ * @count: maximum number of page extensions to return.
  *
  * Must be called with RCU read lock taken.
  *
  * Return: NULL if no next page_ext exists.
  */
-static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter)
+static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter,
+		unsigned long count)
 {
 	unsigned long pfn;
 
 	if (WARN_ON_ONCE(!iter->page_ext))
 		return NULL;
 
-	iter->index++;
+	if (++iter->index >= count)
+		return NULL;
 	pfn = iter->start_pfn + iter->index;
 
 	if (page_ext_iter_next_fast_possible(pfn))
@@ -183,9 +190,9 @@ static inline struct page_ext *page_ext_
  * IMPORTANT: must be called with RCU read lock taken.
  */
 #define for_each_page_ext(__page, __pgcount, __page_ext, __iter) \
-	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page));\
-		__page_ext && __iter.index < __pgcount;          \
-		__page_ext = page_ext_iter_next(&__iter))
+	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page), __pgcount); \
+		__page_ext; \
+		__page_ext = page_ext_iter_next(&__iter, __pgcount))
 
 #else /* !CONFIG_PAGE_EXTENSION */
 struct page_ext;
_

Patches currently in -mm which might be from ketan.kishore@oss.qualcomm.com are


