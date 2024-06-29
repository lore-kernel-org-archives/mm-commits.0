Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2550AC148
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628225; cv=none; b=Kn+ulCYglaLe0BfFZEdjHeCc6mE1UjTXtjS5Q0q3TsLbpQFz2RE5u0fprt0blTDeA7DqBgD7IzyOUvYHOBPT+Jt6SmQZy5HxmqD+CJkMQaHhNiO6MvTsS7lK5hIw+gSBcRSND/JX4g/ek9HJ/Cl3KXUuHIuIHMKcWRflPrMjSIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628225; c=relaxed/simple;
	bh=Qd/Zl9EgaO/AKqJFS+ei1KimdePXLVNRyktKAN7sc5E=;
	h=Date:To:From:Subject:Message-Id; b=OYDQXQUgPjAfFWCuGVAq/5cecJBvdM/kVlz91TmNsJO5MNbz+YvCkSlv3/K7xtQb31Yt0Z6JVBtKxxhdxh9Cn8YjEvOtEvBXkY5G73HLnwk86xnXdF5cIWB7uGMw28xpI3FUdOgwoZrlDEWpYhQTvmWsrc109e//pwy76cg6iVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=damqQ+l5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="damqQ+l5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD5BC32781;
	Sat, 29 Jun 2024 02:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628225;
	bh=Qd/Zl9EgaO/AKqJFS+ei1KimdePXLVNRyktKAN7sc5E=;
	h=Date:To:From:Subject:From;
	b=damqQ+l5LRX8lseU2guFgT/nYtlKaCpKyB4j6aEn6hNb+oKy00JP50nWN8I1529HQ
	 FJdMtmfdNN74C59pN2PlXzeh5ggN9U2Z2kS9Rw43fz/vAVnrpNy+lFj5MszvkICJ1j
	 +D2mzh2SM+Cs81ySae+xYy6i1y6vItM9IJTBXW7A=
Date: Fri, 28 Jun 2024 19:30:24 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-reword-the-comment-of-buddy_merge_likely.patch removed from -mm tree
Message-Id: <20240629023024.ECD5BC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: reword the comment of buddy_merge_likely()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-reword-the-comment-of-buddy_merge_likely.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc: reword the comment of buddy_merge_likely()
Date: Wed, 19 Jun 2024 01:06:12 +0000

For page with order O, we are checking its order (O + 1)'s buddy.  If it
is free, we would like to put it to the tail and expect it would be merged
to a page with order (O + 2).

Reword the comment to reflect it.

Link: https://lkml.kernel.org/r/20240619010612.20740-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-reword-the-comment-of-buddy_merge_likely
+++ a/mm/page_alloc.c
@@ -712,12 +712,12 @@ static inline struct page *get_page_from
 }
 
 /*
- * If this is not the largest possible page, check if the buddy
- * of the next-highest order is free. If it is, it's possible
+ * If this is less than the 2nd largest possible page, check if the buddy
+ * of the next-higher order is free. If it is, it's possible
  * that pages are being freed that will coalesce soon. In case,
  * that is happening, add the free page to the tail of the list
  * so it's less likely to be used soon and more likely to be merged
- * as a higher order page
+ * as a 2-level higher order page
  */
 static inline bool
 buddy_merge_likely(unsigned long pfn, unsigned long buddy_pfn,
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


