Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41819158524
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006234; cv=none; b=pCU/yx6d0C1vcF4blfn2/llMQsUb/DuCTAuJE4xtsMK2MtnrFFXBPHbqOTbLLNC9BBabE465XbpsERX1W2pquqK9KpNIIUh0lp8zmLjuLIZ9IXp9G4+GvbijDFFXrbKX28rZlDNGuYBP6YdwIA8/lrE/e4/iUhCtUcltEt4uANY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006234; c=relaxed/simple;
	bh=uJG7vKx7BHBNxxtW02/SUNKk1oysckwSSAV36qLtKcM=;
	h=Date:To:From:Subject:Message-Id; b=IYAefz9fCXj007khOI3iK7FSwlNeHqTDaCjHZNElbgd/UWX3RkcojK7YESBTrs+NHXjzI7Hb5ehv1A2+bAMbmKbcMwPo1QekPQqt35Yy1Vs0NXUG0ck7Uawez9SkbnUJ9AbgW7+a29BBFoNROvPP5V92C3oTQ5/KT4+ViCPRJmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EUp5/j9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EUp5/j9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0A3C4CED6;
	Thu, 16 Jan 2025 05:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006234;
	bh=uJG7vKx7BHBNxxtW02/SUNKk1oysckwSSAV36qLtKcM=;
	h=Date:To:From:Subject:From;
	b=EUp5/j9H1jb9XdLURjKmeD839Otk8X2rL5DE8Nf20BywYb47p8iI6rCClBloXsQjb
	 U64/JxQtCQggMUPoOCEoFcAAht0dq6Tl0UiwWaRJI+V7G68avkvTdGlvlL0dQ3tm5O
	 Ct4AnNKDOX+mqjPX3B+IC/muZzzrePzfkV6M2/gY=
Date: Wed, 15 Jan 2025 21:43:53 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-convert-migrate_zspage-to-use-zpdesc.patch removed from -mm tree
Message-Id: <20250116054354.0A0A3C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: convert migrate_zspage() to use zpdesc
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-convert-migrate_zspage-to-use-zpdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/zsmalloc: convert migrate_zspage() to use zpdesc
Date: Tue, 17 Dec 2024 00:04:45 +0900

Use get_first_zpdesc/get_next_zpdesc to replace get_first/next_page. No
functional change.

Link: https://lkml.kernel.org/r/20241216150450.1228021-15-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-migrate_zspage-to-use-zpdesc
+++ a/mm/zsmalloc.c
@@ -1602,14 +1602,14 @@ static void migrate_zspage(struct zs_poo
 	unsigned long used_obj, free_obj;
 	unsigned long handle;
 	int obj_idx = 0;
-	struct page *s_page = get_first_page(src_zspage);
+	struct zpdesc *s_zpdesc = get_first_zpdesc(src_zspage);
 	struct size_class *class = pool->size_class[src_zspage->class];
 
 	while (1) {
-		handle = find_alloced_obj(class, page_zpdesc(s_page), &obj_idx);
+		handle = find_alloced_obj(class, s_zpdesc, &obj_idx);
 		if (!handle) {
-			s_page = get_next_page(s_page);
-			if (!s_page)
+			s_zpdesc = get_next_zpdesc(s_zpdesc);
+			if (!s_zpdesc)
 				break;
 			obj_idx = 0;
 			continue;
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are


