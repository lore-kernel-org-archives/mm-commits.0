From: akpm@linux-foundation.org
Subject: + mm-balloon_compaction-ignore-anonymous-pages.patch added to -mm tree
Date: Wed, 27 Aug 2014 14:04:26 -0700
Message-ID: <53fe47da.W/K5wZhHdoB3Wu1w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:57794 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965297AbaH0VE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 17:04:27 -0400
Received: by mail-oi0-f74.google.com with SMTP id v63so69010oia.1
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 14:04:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.khlebnikov@samsung.com, aquini@redhat.com, ryabinin.a.a@gmail.com, sasha.levin@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/balloon_compaction: ignore anonymous pages
has been added to the -mm tree.  Its filename is
     mm-balloon_compaction-ignore-anonymous-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-balloon_compaction-ignore-anonymous-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-balloon_compaction-ignore-anonymous-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-balloon_compaction-ignore-anonymous-pages.patch
mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path.patch
mm-balloon_compaction-isolate-balloon-pages-without-lru_lock.patch
mm-introduce-common-page-state-for-ballooned-memory.patch
mm-balloon_compaction-use-common-page-ballooning.patch
mm-balloon_compaction-general-cleanup.patch

