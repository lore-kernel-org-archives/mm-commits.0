From: akpm@linux-foundation.org
Subject: + zsmalloc-correct-fragile-_atomic-use.patch added to -mm tree
Date: Tue, 18 Nov 2014 15:29:55 -0800
Message-ID: <546bd673.HZU8zls8zS3gQT+a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37973 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbaKRX35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 18:29:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ddstreet@ieee.org, jmarchan@redhat.com, ngupta@vflare.org, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: correct fragile [kmap|kunmap]_atomic use
has been added to the -mm tree.  Its filename is
     zsmalloc-correct-fragile-_atomic-use.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-correct-fragile-_atomic-use.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-correct-fragile-_atomic-use.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: correct fragile [kmap|kunmap]_atomic use

The kunmap_atomic should use virtual address getting by kmap_atomic. 
However, some pieces of code in zsmalloc uses modified address, not the
one got by kmap_atomic for kunmap_atomic.

It's okay for working because zsmalloc modifies the address inner
PAGE_SIZE bounday so it works with current kmap_atomic's implementation. 
But it's still fragile with potential changing of kmap_atomic so let's
correct it.

I got a subtle bug when I implemented a new feature of zsmalloc
(compaction) due to a link's mishandling (the link was over page
boundary).  Although it was totally my mistake, it took a while to find
the cause because an unpredictable kmapped address was unmapped causing an
almost random crash.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-correct-fragile-_atomic-use mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-correct-fragile-_atomic-use
+++ a/mm/zsmalloc.c
@@ -629,6 +629,7 @@ static void init_zspage(struct page *fir
 		struct page *next_page;
 		struct link_free *link;
 		unsigned int i = 1;
+		void *vaddr;
 
 		/*
 		 * page->index stores offset of first object starting
@@ -639,8 +640,8 @@ static void init_zspage(struct page *fir
 		if (page != first_page)
 			page->index = off;
 
-		link = (struct link_free *)kmap_atomic(page) +
-						off / sizeof(*link);
+		vaddr = kmap_atomic(page);
+		link = (struct link_free *)vaddr + off / sizeof(*link);
 
 		while ((off += class->size) < PAGE_SIZE) {
 			link->next = obj_location_to_handle(page, i++);
@@ -654,7 +655,7 @@ static void init_zspage(struct page *fir
 		 */
 		next_page = get_next_page(page);
 		link->next = obj_location_to_handle(next_page, 0);
-		kunmap_atomic(link);
+		kunmap_atomic(vaddr);
 		page = next_page;
 		off %= PAGE_SIZE;
 	}
@@ -1064,6 +1065,7 @@ unsigned long zs_malloc(struct zs_pool *
 	unsigned long obj;
 	struct link_free *link;
 	struct size_class *class;
+	void *vaddr;
 
 	struct page *first_page, *m_page;
 	unsigned long m_objidx, m_offset;
@@ -1092,11 +1094,11 @@ unsigned long zs_malloc(struct zs_pool *
 	obj_handle_to_location(obj, &m_page, &m_objidx);
 	m_offset = obj_idx_to_offset(m_page, m_objidx, class->size);
 
-	link = (struct link_free *)kmap_atomic(m_page) +
-					m_offset / sizeof(*link);
+	vaddr = kmap_atomic(m_page);
+	link = (struct link_free *)vaddr + m_offset / sizeof(*link);
 	first_page->freelist = link->next;
 	memset(link, POISON_INUSE, sizeof(*link));
-	kunmap_atomic(link);
+	kunmap_atomic(vaddr);
 
 	first_page->inuse++;
 	/* Now move the zspage to another fullness group, if required */
@@ -1112,6 +1114,7 @@ void zs_free(struct zs_pool *pool, unsig
 	struct link_free *link;
 	struct page *first_page, *f_page;
 	unsigned long f_objidx, f_offset;
+	void *vaddr;
 
 	int class_idx;
 	struct size_class *class;
@@ -1130,10 +1133,10 @@ void zs_free(struct zs_pool *pool, unsig
 	spin_lock(&class->lock);
 
 	/* Insert this object in containing zspage's freelist */
-	link = (struct link_free *)((unsigned char *)kmap_atomic(f_page)
-							+ f_offset);
+	vaddr = kmap_atomic(f_page);
+	link = (struct link_free *)(vaddr + f_offset);
 	link->next = first_page->freelist;
-	kunmap_atomic(link);
+	kunmap_atomic(vaddr);
 	first_page->freelist = (void *)obj;
 
 	first_page->inuse--;
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-frontswap-invalidate-expired-data-on-a-dup-store-failure.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value-fix.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
zram-remove-bio-parameter-from-zram_bvec_rw.patch
zram-change-parameter-from-vaild_io_request.patch
zram-implement-rw_page-operation-of-zram.patch
zram-implement-rw_page-operation-of-zram-fix.patch
zram-implement-rw_page-operation-of-zram-fix-2.patch
zram-implement-rw_page-operation-of-zram-fix-2-cleanup.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
zsmalloc-correct-fragile-_atomic-use.patch
mm-zswap-add-__init-to-some-functions-in-zswap.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

