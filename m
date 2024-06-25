Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C981428F3
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291578; cv=none; b=P4iFJtpQYvHPBmO63qe03kZhIjMgWWHiAXIrqoq1eyhv/MJsKm3v+kQwDU2tcs3b0GtQSHvnSoxjPXvrItQfDcSe4Exn+zLD6na+0aIkafcMs1cXxm2LFzjExmAmOmXrvjw5YbN63MFSav2KUmBgF7fdQiEOZhgvVLkjfBBoUGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291578; c=relaxed/simple;
	bh=TZcvTrnBfsfcwDY8DSQDZOIwSUgjcCAtuuvjYqeUrh0=;
	h=Date:To:From:Subject:Message-Id; b=m0UIBwI5OciPydqO5TmmdV3yydaDjW0ZHovUUgcv5Vuo4IYbb+FXwkFeHbJUjAsCFbWfFjDvw3bHrOSCZtVIPJ0Uf/V2uJblQ6ncPuYNV2iUhRTY1LkwkQy21EqFCGsJwuEoB0JEdBU2EmEgQ61DTaUHVvLmSFzW0jFw7BlqVqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f9xmB79D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f9xmB79D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209E7C32782;
	Tue, 25 Jun 2024 04:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291578;
	bh=TZcvTrnBfsfcwDY8DSQDZOIwSUgjcCAtuuvjYqeUrh0=;
	h=Date:To:From:Subject:From;
	b=f9xmB79DPVgEl+D5WLfIauA9sRac1IuMydrJZSvzjBfS3Jl7E63vmFnPVQnLDTh9g
	 bV9+8H8cpZ52XNBBJZH2VCw+uBSeFtKst58+lc6Ql7EBtufybInwXcVmZdujc8H6jq
	 HFDdMJotyTPNVOCcQ/l8AnsppTxuQyVLkI9cGLmk=
Date: Mon, 24 Jun 2024 21:59:37 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,oalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-move-hwpoison_filter-higher-up.patch removed from -mm tree
Message-Id: <20240625045938.209E7C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: move hwpoison_filter() higher up
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-move-hwpoison_filter-higher-up.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/memory-failure: move hwpoison_filter() higher up
Date: Fri, 24 May 2024 15:53:05 -0600

Move hwpoison_filter() higher up as there is no need to spend a lot cycles
only to find out later that the page is supposed to be skipped from
hwpoison handling.

Link: https://lkml.kernel.org/r/20240524215306.2705454-5-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <oalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-move-hwpoison_filter-higher-up
+++ a/mm/memory-failure.c
@@ -2300,6 +2300,18 @@ try_again:
 	}
 
 	folio = page_folio(p);
+
+	/* filter pages that are protected from hwpoison test by users */
+	folio_lock(folio);
+	if (hwpoison_filter(p)) {
+		ClearPageHWPoison(p);
+		folio_unlock(folio);
+		folio_put(folio);
+		res = -EOPNOTSUPP;
+		goto unlock_mutex;
+	}
+	folio_unlock(folio);
+
 	if (folio_test_large(folio)) {
 		/*
 		 * The flag must be set after the refcount is bumped
@@ -2363,14 +2375,6 @@ try_again:
 	 */
 	page_flags = folio->flags;
 
-	if (hwpoison_filter(p)) {
-		ClearPageHWPoison(p);
-		folio_unlock(folio);
-		folio_put(folio);
-		res = -EOPNOTSUPP;
-		goto unlock_mutex;
-	}
-
 	/*
 	 * __munlock_folio() may clear a writeback folio's LRU flag without
 	 * the folio lock. We need to wait for writeback completion for this
_

Patches currently in -mm which might be from jane.chu@oracle.com are


