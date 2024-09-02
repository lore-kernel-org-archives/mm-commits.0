Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A4C537FF
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247783; cv=none; b=IEPyoGC+KwZkJ7z9Nz9D12cnHyr2TpHc5m0YyJoO5VSKOJHvC8HlVbYk/3oy5OIejTwkFWaMd65KFf9C+gU0iAJow0p6MJsjzXHPhr4uuzt6E2CkNx5UwnoOSl52sg6IRvVIu/Zf0UFhynSzPtAJk7neseESk9UHXlTeunkF8DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247783; c=relaxed/simple;
	bh=qUMvNKsQ3P+nD5g0oGHz0Ekeg3F84wCBZLOfQVTkUMw=;
	h=Date:To:From:Subject:Message-Id; b=HjsSTIliAhq3HWEa6OFhJtep2IKntDa56d5AsfN2975k3a5k4AgE+4WLFCJNZiWpMmX3z5EQRrx/piUI4A0ZZSOJM+Tlj2p7q7X158s3yW2UHfya7RzXy4F0WL75h9/DVLr8MKOBU4hndbZyyhWg9G/HZuANQi2mOo1dUQCq2fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qweFyHJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qweFyHJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D7AC4CEC2;
	Mon,  2 Sep 2024 03:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247782;
	bh=qUMvNKsQ3P+nD5g0oGHz0Ekeg3F84wCBZLOfQVTkUMw=;
	h=Date:To:From:Subject:From;
	b=qweFyHJRw8bys9TxwPPp5WG2mfyS0vUbs6ZPKC1vc/ZUNaTLRDXqa5ORKLm5gzlXC
	 q+76YAUwqAHGa/uVWn5yppVonjirR8buJu/Hd7ydoDt0LYVHmrzrhgfGve3gNpKkB8
	 JUjz14EbriejZ0LVYVcL8Y3rpg9eajyyhqQ0pG9Y=
Date: Sun, 01 Sep 2024 20:29:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.lendacky@amd.com,rppt@kernel.org,mgorman@suse.de,hannes@cmpxchg.org,david@redhat.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-pageunaccepted-page-type.patch removed from -mm tree
Message-Id: <20240902032942.88D7AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce PageUnaccepted() page type
has been removed from the -mm tree.  Its filename was
     mm-introduce-pageunaccepted-page-type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: introduce PageUnaccepted() page type
Date: Fri, 9 Aug 2024 14:48:50 +0300

The new page type allows physical memory scanners to detect unaccepted
memory and handle it accordingly.

The page type is serialized with zone lock.

Link: https://lkml.kernel.org/r/20240809114854.3745464-5-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    8 ++++++++
 mm/page_alloc.c            |    2 ++
 2 files changed, 10 insertions(+)

--- a/include/linux/page-flags.h~mm-introduce-pageunaccepted-page-type
+++ a/include/linux/page-flags.h
@@ -939,6 +939,7 @@ enum pagetype {
 	PG_hugetlb	= 0x04000000,
 	PG_slab		= 0x02000000,
 	PG_zsmalloc	= 0x01000000,
+	PG_unaccepted	= 0x00800000,
 
 	PAGE_TYPE_BASE	= 0x80000000,
 
@@ -1072,6 +1073,13 @@ FOLIO_TEST_FLAG_FALSE(hugetlb)
 
 PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
 
+/*
+ * Mark pages that has to be accepted before touched for the first time.
+ *
+ * Serialized with zone lock.
+ */
+PAGE_TYPE_OPS(Unaccepted, unaccepted, unaccepted)
+
 /**
  * PageHuge - Determine if the page belongs to hugetlbfs
  * @page: The page to test.
--- a/mm/page_alloc.c~mm-introduce-pageunaccepted-page-type
+++ a/mm/page_alloc.c
@@ -6963,6 +6963,7 @@ static bool try_to_accept_memory_one(str
 
 	account_freepages(zone, -MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
 	__mod_zone_page_state(zone, NR_UNACCEPTED, -MAX_ORDER_NR_PAGES);
+	__ClearPageUnaccepted(page);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
 	accept_page(page, MAX_PAGE_ORDER);
@@ -7021,6 +7022,7 @@ static bool __free_unaccepted(struct pag
 	list_add_tail(&page->lru, &zone->unaccepted_pages);
 	account_freepages(zone, MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
 	__mod_zone_page_state(zone, NR_UNACCEPTED, MAX_ORDER_NR_PAGES);
+	__SetPageUnaccepted(page);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
 	if (first)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


