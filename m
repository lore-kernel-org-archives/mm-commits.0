Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A87321E
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tAZ8SFIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978B8C433C7;
	Mon, 11 Dec 2023 00:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256064;
	bh=y1/xf52XtOAxjxehYsK2JFqTC77DdARwvSKOnd3PHzI=;
	h=Date:To:From:Subject:From;
	b=tAZ8SFIPt228Sg4xmunsGeckI7Hnn5B5E2WNYPp2mLWrg7PHJmTIpY8uLE12DW1RB
	 Dxjz4TG7ncdwLlsgcWODkO/SuyWQLydaxx4pzFcDCemj4Jtu9qoqizzzkRyrLXJU+m
	 PC96jZE6M+uGJiPm4jKrQ7he/FjyIvKwN7KVvs5E=
Date: Sun, 10 Dec 2023 16:54:24 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-dedupe-some-memcg-uncharging-logic.patch removed from -mm tree
Message-Id: <20231211005424.978B8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: dedupe some memcg uncharging logic
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dedupe-some-memcg-uncharging-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: dedupe some memcg uncharging logic
Date: Wed, 8 Nov 2023 16:49:20 +0000

The duplication makes it seem like some work is required before uncharging
in the !PageHWPoison case.  But it isn't, so we can simplify the code a
little.

Note the PageMemcgKmem check is redundant, but I've left it in as it
avoids an unnecessary function call.

Link: https://lkml.kernel.org/r/20231108164920.3401565-1-jackmanb@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-dedupe-some-memcg-uncharging-logic
+++ a/mm/page_alloc.c
@@ -1086,13 +1086,11 @@ static __always_inline bool free_pages_p
 	trace_mm_page_free(page, order);
 	kmsan_free_page(page, order);
 
+	if (memcg_kmem_online() && PageMemcgKmem(page))
+		__memcg_kmem_uncharge_page(page, order);
+
 	if (unlikely(PageHWPoison(page)) && !order) {
-		/*
-		 * Do not let hwpoison pages hit pcplists/buddy
-		 * Untie memcg state and reset page's owner
-		 */
-		if (memcg_kmem_online() && PageMemcgKmem(page))
-			__memcg_kmem_uncharge_page(page, order);
+		/* Do not let hwpoison pages hit pcplists/buddy */
 		reset_page_owner(page, order);
 		page_table_check_free(page, order);
 		return false;
@@ -1123,8 +1121,6 @@ static __always_inline bool free_pages_p
 	}
 	if (PageMappingFlags(page))
 		page->mapping = NULL;
-	if (memcg_kmem_online() && PageMemcgKmem(page))
-		__memcg_kmem_uncharge_page(page, order);
 	if (is_check_pages_enabled()) {
 		if (free_page_is_bad(page))
 			bad++;
_

Patches currently in -mm which might be from jackmanb@google.com are


