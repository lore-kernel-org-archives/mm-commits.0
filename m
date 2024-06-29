Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9607B7494
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628197; cv=none; b=VkXOhYouoYi/NJrsCSnTnfot3ZSD6n3Uj8+MJ+pq9MqiGi6PSWw+Yay94Tpj84M6tI8MLyX558P8mmjPfD0N1PXJo9z9Vh0h7CPbLQ7znv7riujW8b3INIcz9RHJqsaajXXCtFqlAqvBp3KumhgOi+Mwn+WwTAzCCZc/6EhY1x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628197; c=relaxed/simple;
	bh=XBTFH+ZWf/lPcx+R3yODlbx9vgqSEKeVQN0qCadGJrs=;
	h=Date:To:From:Subject:Message-Id; b=hFGwjzmDFk66VCLTJ3rWbtbb3Uui0JRc8YwUD2jDTwS448AW05WfR0JvtO1IzaOZEf9i7pScmaow8NfTpoyljDrdMrM1ttHvKC3jx9FID+isKnZvS+bNdn4g7sg9pvxugwfTZSB3uTLnvH9hgwtpBxFYwqNuHx4k5L5/ie8ijwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RxwnEKy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RxwnEKy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681E5C116B1;
	Sat, 29 Jun 2024 02:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628197;
	bh=XBTFH+ZWf/lPcx+R3yODlbx9vgqSEKeVQN0qCadGJrs=;
	h=Date:To:From:Subject:From;
	b=RxwnEKy4bE/HeA0a9kh/sGE+WME+0zYpUetp9fUHuulzVPMiCGYFVM28doj5zaB+U
	 /Bkm7WdBoPzt9yRlJZDb5Q1SYFZuEAKUex7j54vTQPBsC6i0tbQyJyJlMZgMhlC75q
	 woUzysDfi23PtlWllNwHkJ0fyECwXPe452A3DXBk=
Date: Fri, 28 Jun 2024 19:29:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,senozhatsky@chromium.org,rppt@kernel.org,minchan@kernel.org,42.hyeyoo@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch removed from -mm tree
Message-Id: <20240629022957.681E5C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: clear PageBuddy using __ClearPageBuddy() for bad pages
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: clear PageBuddy using __ClearPageBuddy() for bad pages
Date: Wed, 29 May 2024 13:19:02 +0200

Let's stop using page_mapcount_reset() and clear PageBuddy using
__ClearPageBuddy() instead.

Link: https://lkml.kernel.org/r/20240529111904.2069608-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>	[zram/zsmalloc workloads]
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages
+++ a/mm/page_alloc.c
@@ -498,7 +498,8 @@ static void bad_page(struct page *page,
 	dump_stack();
 out:
 	/* Leave bad fields for debug, except PageBuddy could make trouble */
-	page_mapcount_reset(page); /* remove PageBuddy */
+	if (PageBuddy(page))
+		__ClearPageBuddy(page);
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
@@ -1351,7 +1352,8 @@ static void check_new_page_bad(struct pa
 {
 	if (unlikely(page->flags & __PG_HWPOISON)) {
 		/* Don't complain about hwpoisoned pages */
-		page_mapcount_reset(page); /* remove PageBuddy */
+		if (PageBuddy(page))
+			__ClearPageBuddy(page);
 		return;
 	}
 
_

Patches currently in -mm which might be from david@redhat.com are


