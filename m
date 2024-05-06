Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C037938F96
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957137; cv=none; b=byHArewGspThjEvmuQjj1EVw1TVKvwPT+eiYiie1oZHTNGx1iDByh4yBXVtXb75DakTLots9c1X+qsUxXL+s6pVuQ7kuEKB7KthWx9JBz3a2kzFoM/k3z3ZtJUdfcXCdgYaRmtPsJkI4c2zK2RYol7SxyooVRxP306lprmOTH3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957137; c=relaxed/simple;
	bh=M+ZzpHJsNyPT3M/FfsMIRdRGBLnn93Vctcpq7OvDY0U=;
	h=Date:To:From:Subject:Message-Id; b=NA7m6ur6EUZuF6Q0BJaKLbcCMnDBc25RN7lWwcIshIAidyo5qEc9r6GaZaXEaYUKPm8CHiLSiSHSPFnqj6vkuU2H+MWLsBwmblFj/+S1bFBHXqhxGeym/DEJ67PnLhj/gPVu4fD+tWgPFBJ5XRl4cHZwz1YNQEDB2c2ylZsYBds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dmZA9d8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dmZA9d8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984E9C116B1;
	Mon,  6 May 2024 00:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957137;
	bh=M+ZzpHJsNyPT3M/FfsMIRdRGBLnn93Vctcpq7OvDY0U=;
	h=Date:To:From:Subject:From;
	b=dmZA9d8kFbFML6FNUz1c83N46zLSx6r/0ir3lL5cvlN3+BVmCQsNQ59mZvKZ6pkE6
	 wMArgOjnOZ9fWdH8rlA3tdst8r/J6oTH7WBNyiznrT4aMyzCOcqy6jEh/NB7V3McfC
	 sn2bWa0qljXUTaHGQ/eplyCq37gi1LcjfY8TT1vA=
Date: Sun, 05 May 2024 17:58:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pagemap-make-trylock_page-return-bool.patch removed from -mm tree
Message-Id: <20240506005857.984E9C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/pagemap: make trylock_page return bool
has been removed from the -mm tree.  Its filename was
     mm-pagemap-make-trylock_page-return-bool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/pagemap: make trylock_page return bool
Date: Sun, 28 Apr 2024 09:47:11 +0800

Make trylock_page return bool to align the return values of folio_trylock
function and it also corresponds to its comment.

Link: https://lkml.kernel.org/r/20240428014711.11169-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pagemap.h~mm-pagemap-make-trylock_page-return-bool
+++ a/include/linux/pagemap.h
@@ -1012,7 +1012,7 @@ static inline bool folio_trylock(struct
 /*
  * Return true if the page was successfully locked
  */
-static inline int trylock_page(struct page *page)
+static inline bool trylock_page(struct page *page)
 {
 	return folio_trylock(page_folio(page));
 }
_

Patches currently in -mm which might be from gehao@kylinos.cn are


