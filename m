Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264DE140E50
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249634; cv=none; b=Lj0BgDl7K9NJjNkYP3PUedG1rJCHsfZ6EYgzJVyBtTNcpE+X0OqBBDR1Ffu2SRFb7YDxipc25o+5K2Ab7pKx/wsGJY59JOkvZUoltY62dsSZ/9D9pBf+amlP0CRjM8xcrVmsYUxoIPoUcI/zz9vjJhHMSIvnoPvuXSpIact+I3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249634; c=relaxed/simple;
	bh=79lyG0kMF8aKL4JGGjKIPU0jGiJZtbxo58od0cQPsa4=;
	h=Date:To:From:Subject:Message-Id; b=PR74iFuXEIX+XuTAGf874Sa4FzTn06dcYgigoPJHm4aCP8plN7L5fMKbqe8B6m+I8ve3EmWOelAuE+RHtLtPjWXCppYXFlKT1yHFCPCPMYkdt6hyT3cv2EA9kKlotg+BjI00vS4wXjbvkIDxvf5ubg4xeejB9qZT5bseGFo7hJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B8dQ7PUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B8dQ7PUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E810BC4CED1;
	Thu, 26 Dec 2024 21:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249634;
	bh=79lyG0kMF8aKL4JGGjKIPU0jGiJZtbxo58od0cQPsa4=;
	h=Date:To:From:Subject:From;
	b=B8dQ7PUGbnyXfESAOhQ2s50vj1GPly2RWIRdGH1CV0weMw8KoA89RYD5S6jIgM9h7
	 FyWBacSoeX+xczy1xNXEacwhKd3Nm7B0CXBtdqIp8PVtN5Idk+YX9fyfvTOX8cdjhi
	 O84WQySt93p6Ti7WQP/Sv5fzHf0BWb6zITzgEBXw=
Date: Thu, 26 Dec 2024 13:47:13 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,42.hyeyoo@gmail.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-convert-reset_page-to-reset_zpdesc.patch added to mm-unstable branch
Message-Id: <20241226214713.E810BC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: convert reset_page to reset_zpdesc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-convert-reset_page-to-reset_zpdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-convert-reset_page-to-reset_zpdesc.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alex Shi <alexs@kernel.org>
Subject: mm/zsmalloc: convert reset_page to reset_zpdesc
Date: Tue, 17 Dec 2024 00:04:42 +0900

zpdesc.zspage matches with page.private, zpdesc.next matches with
page.index.  They will be reset in reset_page() which is called prior to
free base pages of a zspage.

Since the fields that need to be initialized are independent of the order
in struct zpdesc, Keep it to use struct page to ensure robustness against
potential rearrangements of struct zpdesc fields in the future.

[42.hyeyoo@gmail.com: keep reset_zpdesc() to use struct page fields]
Link: https://lkml.kernel.org/r/20241216150450.1228021-12-42.hyeyoo@gmail.com
Signed-off-by: Alex Shi <alexs@kernel.org>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-reset_page-to-reset_zpdesc
+++ a/mm/zsmalloc.c
@@ -843,8 +843,10 @@ static inline bool obj_allocated(struct
 	return true;
 }
 
-static void reset_page(struct page *page)
+static void reset_zpdesc(struct zpdesc *zpdesc)
 {
+	struct page *page = zpdesc_page(zpdesc);
+
 	__ClearPageMovable(page);
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
@@ -887,7 +889,7 @@ static void __free_zspage(struct zs_pool
 	do {
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		next = get_next_page(page);
-		reset_page(page);
+		reset_zpdesc(page_zpdesc(page));
 		unlock_page(page);
 		dec_zone_page_state(page, NR_ZSPAGES);
 		put_page(page);
@@ -1865,7 +1867,7 @@ static int zs_page_migrate(struct page *
 		zpdesc_inc_zone_page_state(newzpdesc);
 	}
 
-	reset_page(page);
+	reset_zpdesc(zpdesc);
 	zpdesc_put(zpdesc);
 
 	return MIGRATEPAGE_SUCCESS;
_

Patches currently in -mm which might be from alexs@kernel.org are

mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool.patch
mm-zsmalloc-use-zpdesc-in-trylock_zspage-lock_zspage.patch
mm-zsmalloc-convert-create_page_chain-and-its-users-to-use-zpdesc.patch
mm-zsmalloc-convert-reset_page-to-reset_zpdesc.patch
mm-zsmalloc-convert-setzspagemovable-and-remove-unused-funcs.patch
mm-zsmalloc-convert-get-set_first_obj_offset-to-take-zpdesc.patch
mm-zsmalloc-introduce-__zpdesc_clear-set_zsmalloc.patch

