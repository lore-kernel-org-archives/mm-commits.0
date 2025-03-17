Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBD260DCF
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 00:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742172073; cv=none; b=s3bFBITetb2CEeGPnof0mjzrDHAB1zx3CgEYI15neINyT0kzDDuTZtEfrKoV9D7JvDVGT1iu0/42inKfDF4ph/IXolrNe6WdTjJ+QvI2E63UB3WNmPTQ8pISLhqaLuRtmtTkEtHZOeVsjV7+MAHAsoir43VYL8T+xqQlraWdQsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742172073; c=relaxed/simple;
	bh=U4R0T0RkP4SKH2PhbGiNoKfw8XsNzpSPoLatj86rT5o=;
	h=Date:To:From:Subject:Message-Id; b=ASN8kRP+NApMOrjHT1ohOMqdrA+8tTHXFhIqVHvVvOHVxttQDS51Cklkn14lmBZSlSO+qp4JZtiEOeLTw9zJzPxFdRiBrXellgEKlqpQfwEN+gPyLpOqgBMTD2VhV1kfN7sWmJn0zpq4wXAkVcCbWQSnmwS/qPwL40NPM80aBWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HUswt2qO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HUswt2qO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111C0C4CEDD;
	Mon, 17 Mar 2025 00:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742172073;
	bh=U4R0T0RkP4SKH2PhbGiNoKfw8XsNzpSPoLatj86rT5o=;
	h=Date:To:From:Subject:From;
	b=HUswt2qO+BdZQ2tktmzS+GvtL8xYwv973zCFdouSqce7qLR/oUF/OXd9+IcaUiZOI
	 UuofHW8I/e35NUICcLgLlETZlJvebmoOKwZouHZypCkdfiyC0UWUpzCCb5AKXkmUK5
	 rbw9uezNS/kcCXk01DIDQXOl6ilbWUQLmLMUDGgc=
Date: Sun, 16 Mar 2025 17:41:12 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,zhiyuzhang999@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] squashfs-fix-invalid-pointer-dereference-in-squashfs_cache_delete.patch removed from -mm tree
Message-Id: <20250317004113.111C0C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: fix invalid pointer dereference in squashfs_cache_delete
has been removed from the -mm tree.  Its filename was
     squashfs-fix-invalid-pointer-dereference-in-squashfs_cache_delete.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Subject: squashfs: fix invalid pointer dereference in squashfs_cache_delete
Date: Thu, 6 Mar 2025 21:28:55 +0800

When mounting a squashfs fails, squashfs_cache_init() may return an error
pointer (e.g., -ENOMEM) instead of NULL.  However, squashfs_cache_delete()
only checks for a NULL cache, and attempts to dereference the invalid
pointer.  This leads to a kernel crash (BUG: unable to handle kernel
paging request in squashfs_cache_delete).

This patch fixes the issue by checking IS_ERR(cache) before accessing it.

Link: https://lkml.kernel.org/r/20250306132855.2030-1-zhiyuzhang999@gmail.com
Fixes: 49ff29240ebb ("squashfs: make squashfs_cache_init() return ERR_PTR(-ENOMEM)")
Signed-off-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Reported-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Closes: https://lore.kernel.org/linux-fsdevel/CALf2hKvaq8B4u5yfrE+BYt7aNguao99mfWxHngA+=o5hwzjdOg@mail.gmail.com/
Tested-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/cache.c~squashfs-fix-invalid-pointer-dereference-in-squashfs_cache_delete
+++ a/fs/squashfs/cache.c
@@ -198,7 +198,7 @@ void squashfs_cache_delete(struct squash
 {
 	int i, j;
 
-	if (cache == NULL)
+	if (IS_ERR(cache) || cache == NULL)
 		return;
 
 	for (i = 0; i < cache->entries; i++) {
_

Patches currently in -mm which might be from zhiyuzhang999@gmail.com are


