Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F9C30AD0A;
	Tue, 13 Jan 2026 05:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280992; cv=none; b=s3l9X/VAR0rwdWW8+zMuG/DVVUjYBjLChLkNJb1yrbMTsSgiB6jee1aYxVrxmlpsxbKjpFiznmds3jqmUB2ueNSCKLJgJdFoIacl+CTPclSJBdbnUHYUV0wQNf7e9tNtGVlgRVb6Hmtwg9R9AQT9r/aub5JowVCHxlteKxzGuts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280992; c=relaxed/simple;
	bh=Qkv/rukeZgsHW0r2LqRDBgg6esrCVl8ykwxVy08u2X0=;
	h=Date:To:From:Subject:Message-Id; b=mpYroJTIyaDjZrg8I2YK5EoIuhgiK9LrBRq8hqfYFgeJKlO1I3pdF8cCDQd5aOUP3jCV7FWjWX7hAS0CtGvmFncv/ytFtclBw3TRGqUvtLKH6Yw+6EqXqEIemKhJUNqK/taeheIp0iQXn/0+S4FClmSSYcINrhy6HrSXyfjDyT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DrjBI3QW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DrjBI3QW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A971C19421;
	Tue, 13 Jan 2026 05:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280990;
	bh=Qkv/rukeZgsHW0r2LqRDBgg6esrCVl8ykwxVy08u2X0=;
	h=Date:To:From:Subject:From;
	b=DrjBI3QWnExiSSwFElkVdikyTgfknDLxp3ZxKUa0zIU+H/q9L+YgKsSAD4rIW7P1o
	 UStPNFR2emlz499n/J7emAX/uCOQxFSvAxdhT8pkQ7x0Gjc+nKWhTJUjsbHn4MTLgg
	 CUnCuwpN9wpHyyNbrwQvnf6A/L48DC6pLifwWv9g=
Date: Mon, 12 Jan 2026 21:09:49 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kmsan-fix-poisoning-of-high-order-non-compound-pages.patch removed from -mm tree
Message-Id: <20260113050950.7A971C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmsan: fix poisoning of high-order non-compound pages
has been removed from the -mm tree.  Its filename was
     mm-kmsan-fix-poisoning-of-high-order-non-compound-pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: kmsan: fix poisoning of high-order non-compound pages
Date: Sun, 4 Jan 2026 13:43:47 +0000

kmsan_free_page() is called by the page allocator's free_pages_prepare()
during page freeing.  Its job is to poison all the memory covered by the
page.  It can be called with an order-0 page, a compound high-order page
or a non-compound high-order page.  But page_size() only works for order-0
and compound pages.  For a non-compound high-order page it will
incorrectly return PAGE_SIZE.

The implication is that the tail pages of a high-order non-compound page
do not get poisoned at free, so any invalid access while they are free
could go unnoticed.  It looks like the pages will be poisoned again at
allocation time, so that would bookend the window.

Fix this by using the order parameter to calculate the size.

Link: https://lkml.kernel.org/r/20260104134348.3544298-1-ryan.roberts@arm.com
Fixes: b073d7f8aee4 ("mm: kmsan: maintain KMSAN metadata for page operations")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/shadow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmsan/shadow.c~mm-kmsan-fix-poisoning-of-high-order-non-compound-pages
+++ a/mm/kmsan/shadow.c
@@ -207,7 +207,7 @@ void kmsan_free_page(struct page *page,
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
 	kmsan_enter_runtime();
-	kmsan_internal_poison_memory(page_address(page), page_size(page),
+	kmsan_internal_poison_memory(page_address(page), PAGE_SIZE << order,
 				     GFP_KERNEL & ~(__GFP_RECLAIM),
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


