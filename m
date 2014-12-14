From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-correct-fragile-_atomic-use.patch removed from
 -mm tree
Date: Sat, 13 Dec 2014 20:08:48 -0800
Message-ID: <548d0d50.7vl3FM2EvsrNFTR+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbaLNEIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ddstreet@ieee.org, jmarchan@redhat.com, ngupta@vflare.org, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: correct fragile [kmap|kunmap]_atomic use
has been removed from the -mm tree.  Its filename was
     zsmalloc-correct-fragile-_atomic-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

