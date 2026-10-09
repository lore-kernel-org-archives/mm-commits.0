Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F48413221
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525581; cv=none; b=FqOX0k+Dk2WlYOeQfAbpEDwLEN6Q1lyuroqiGehYtsKPcG0FcCwHQYYAsM9Y628gXa5+3nktsKVyi9jDen36LU5azsdPKLJImdLMs8G3j7GUJJCfD9dnfU2a64TgYXjc4GzFfb1rJDDaeogmJY3WwLvlefWQDMv926yyeVfbRCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525581; c=relaxed/simple;
	bh=pkb1oMnBPV/pIcCOiVTiB9KofTYvZjuae2VWNbcLAo0=;
	h=Date:To:From:Subject:Message-Id; b=aVnB+5e7cm2tQmpM3nA9/RqOwF4Tef0Bhzirk21t16BZ9HEZDyHDZfcy0vQL2exc7h+LPq7Pk0c9CjtPOA0U7HY26U3gxuGcVzuVFHowe4ILmXAKWlexDehY2OVREmy/vSnAJOauv2Xjg99cDoOlVU10hZinwLu4EbeQ8PgpDaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qCI2HL8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qCI2HL8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3C61F0089A;
	Fri,  9 Oct 2026 05:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525577;
	bh=eeYM52QIh358k+reFHUr2GKcEKvN8p1cPMMzJapnGBc=;
	h=Date:To:From:Subject;
	b=qCI2HL8YszAAAf8HxZ3WJRI4AxvB1ZZtATYBVoLeB2Ss9Ife/lsINg+L4AJu+5xs4
	 8NNs8uLvo6e5juUeGbWyv000zfLOg1yP2hnCglkCnLYmUBpGemkZtnfxpvbWuJdwdr
	 aYisUiczy8NrgU+DIz2NjPXNnTwoHAdUDbC1m70c=
Date: Thu, 08 Oct 2026 22:59:37 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,jaegeuk@kernel.org,david@kernel.org,chao@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] f2fs-stop-using-pg_private.patch removed from -mm tree
Message-Id: <20261009055937.8D3C61F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: f2fs: stop using PG_private
has been removed from the -mm tree.  Its filename was
     f2fs-stop-using-pg_private.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: f2fs: stop using PG_private
Date: Sun, 20 Sep 2026 22:28:02 -0400

f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
page->private != NULL is equivalent to checking PG_private. Change
PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
but it can cause confusion when PG_private is removed and
page->private != NULL is used instead. Change it to initialize
page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
semantics.

It prepares for a future commit that removes PG_private.

No functional change intended.

Link: https://lore.kernel.org/20260920-remove-pg_private-v5-6-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Chao Yu <chao@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
---

 fs/f2fs/f2fs.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/f2fs/f2fs.h~f2fs-stop-using-pg_private
+++ a/fs/f2fs/f2fs.h
@@ -2691,7 +2691,7 @@ static inline bool folio_test_f2fs_##nam
 }									\
 static inline bool page_private_##name(struct page *page) \
 { \
-	return PagePrivate(page) && \
+	return page_private(page) && \
 		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
 		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
@@ -2710,9 +2710,9 @@ static inline void folio_set_f2fs_##name
 }									\
 static inline void set_page_private_##name(struct page *page) \
 { \
-	if (!PagePrivate(page)) \
-		attach_page_private(page, (void *)0); \
-	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
+	if (!page_private(page)) \
+		attach_page_private(page, \
+				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
 	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
 
_

Patches currently in -mm which might be from ziy@nvidia.com are


