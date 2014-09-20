From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-balloon_compaction-ignore-anonymous-pages.patch removed from -mm tree
Date: Fri, 19 Sep 2014 23:26:29 -0700
Message-ID: <541d1e15.hW5qb93yNwLE+zZs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaITG0e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 20 Sep 2014 02:26:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.khlebnikov@samsung.com, aquini@redhat.com, ryabinin.a.a@gmail.com, sasha.levin@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/balloon_compaction: ignore anonymous pages
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-ignore-anonymous-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Subject: mm/balloon_compaction: ignore anonymous pages

Sasha Levin reported KASAN splash inside isolate_migratepages_range(). 
Problem is in function __is_movable_balloon_page() which tests
AS_BALLOON_MAP in page->mapping->flags.  This function has no protection
against anonymous pages.  As result it tried to check address space flags
in inside anon-vma.

See http://lkml.kernel.org/p/53E6CEAA.9020105@oracle.com.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: <stable@vger.kernel.org>	[v3.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/balloon_compaction.h~mm-balloon_compaction-ignore-anonymous-pages include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-ignore-anonymous-pages
+++ a/include/linux/balloon_compaction.h
@@ -128,7 +128,7 @@ static inline bool page_flags_cleared(st
 static inline bool __is_movable_balloon_page(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
-	return mapping_balloon(mapping);
+	return !PageAnon(page) && mapping_balloon(mapping);
 }
 
 /*
_

Patches currently in -mm which might be from k.khlebnikov@samsung.com are

include-linux-migrateh-remove-migratepage-define.patch
mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path.patch
mm-balloon_compaction-isolate-balloon-pages-without-lru_lock.patch
mm-introduce-common-page-state-for-ballooned-memory.patch
mm-balloon_compaction-use-common-page-ballooning.patch
mm-balloon_compaction-general-cleanup.patch
linux-next.patch

