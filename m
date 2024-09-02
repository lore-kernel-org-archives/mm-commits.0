Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4968156742
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247790; cv=none; b=Pnq7uMIDqwhUDv4FKJl9vSwPcWxDXfbSWrYSaUrhtJHOUhYsxFqwXHdwsogEckHB3btpEQe+Wck7qlIz5IG7Mp76kWmcRGPbSg8ra8IOCNgCl6RAW5+rQoWUefU/CDGhh+6gVZDdtzPnOV1O8uuoK1EGREUIEmsOticKk4u2bYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247790; c=relaxed/simple;
	bh=2yOtN6ZW+lux4j7P6zq024yJOrSMGpZLhJ5KaE+Z0ew=;
	h=Date:To:From:Subject:Message-Id; b=rak6GMfvXKkoMb4TdQSGLQ+bVhHEhV69j7zYSBStHUBzvdHrRHXCr/RzpLY3YIZY9XSj+QwxHz/DJQOUdO1LrJwXUuKpq4qwuS9xo+z/L4ZcIOcpER4qs0r7Kmx7oPGbkTcqSI0MbPhK8wMOR9XjPI8A/8DvOZNp5glgHhL8+lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aWVCEluW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aWVCEluW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23437C4CEC2;
	Mon,  2 Sep 2024 03:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247790;
	bh=2yOtN6ZW+lux4j7P6zq024yJOrSMGpZLhJ5KaE+Z0ew=;
	h=Date:To:From:Subject:From;
	b=aWVCEluW9uRNaAlBamM0KS0itpOjY6GMJGOJvDOvKV/GVGb27T76KxNXTE+HgIAvu
	 FikyINcdr+vpjMQwV5qofEzqbj4Cx/NYVNltxr2F6LIbexgRIA7nzQghEOi1XvCy+N
	 o6mlE0d7QOs+2JXpAXkSk8pGFpmsDh423TMfp2ys=
Date: Sun, 01 Sep 2024 20:29:49 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,hariom1.p@samsung.com,shankerwangmiao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-add-optimization-hint-on-page-existence-check.patch removed from -mm tree
Message-Id: <20240902032950.23437C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: add optimization hint on page existence check
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-optimization-hint-on-page-existence-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miao Wang <shankerwangmiao@gmail.com>
Subject: mm: vmalloc: add optimization hint on page existence check
Date: Wed, 14 Aug 2024 01:12:13 +0800

In commit 21e516b913c1 ("mm: vmalloc: dump page owner info if page is
already mapped"), a BUG_ON macro was changed into an if statement, where
the compiler optimization hint introduced in the BUG_ON macro was removed
along with this change.  This patch adds back the hint.

Link: https://lkml.kernel.org/r/20240814-fix_vmap_unlikely-v1-1-cd7954775f12@gmail.com
Fixes: 21e516b913c1 ("mm: vmalloc: dump page owner info if page is already mapped")
Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hariom Panthi <hariom1.p@samsung.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-optimization-hint-on-page-existence-check
+++ a/mm/vmalloc.c
@@ -105,7 +105,7 @@ static int vmap_pte_range(pmd_t *pmd, un
 	if (!pte)
 		return -ENOMEM;
 	do {
-		if (!pte_none(ptep_get(pte))) {
+		if (unlikely(!pte_none(ptep_get(pte)))) {
 			if (pfn_valid(pfn)) {
 				page = pfn_to_page(pfn);
 				dump_page(page, "remapping already mapped page");
_

Patches currently in -mm which might be from shankerwangmiao@gmail.com are


