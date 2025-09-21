Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046B728DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489831; cv=none; b=FUH9ojlG7j6jF5twKIv8aE+fiTFvOItE72HTTOgaQhyClhKqUn+yEdMRq4y1W3l57y9AoJxbK3v6AYbSyl+CDAvmhA/dD3dCUGXdLK1+frcj8rmCA0zlhhV3LK3BUZzDXm5/gM83IDm0HIhqSZRnIH0wPwgRyvnEIBzpgcorwxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489831; c=relaxed/simple;
	bh=M7mQcwLlYYrZb+mlGGeh5ahuA3SSdd2V8daY+ext8i4=;
	h=Date:To:From:Subject:Message-Id; b=RoJnKApl363QHi/Nhje1PVhwt0QjQ10jqg+j8aTN++lIQUpf6NNKEAe6QpMz0YtyIik2sX4p5GOTbYuklY2cWnckJ9ApXW5OvrlTdsj6cUlpGNKrDJW8NTIz4GsFZPKTZEnql+nYmq/JKDI5vqllC52b4+w+Zy/HA/pEYrOgKuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aAiVZZhu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aAiVZZhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE80AC4CEE7;
	Sun, 21 Sep 2025 21:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489830;
	bh=M7mQcwLlYYrZb+mlGGeh5ahuA3SSdd2V8daY+ext8i4=;
	h=Date:To:From:Subject:From;
	b=aAiVZZhu24hmsleHKuyFMRtvtU8nblE05G5MQKW1ESmedGluMoRZXJqWM6j3eTjyQ
	 ysdzXTWRyNLXc9BXuqcOA4C7+Az1ZerS/vWj7IvPUR4L3xLgytJFEOvM/7ogIYKpiy
	 jNAkWGms9/4iPnsPFJy6M1BSDtSULMHekdq/mcEo=
Date: Sun, 21 Sep 2025 14:23:50 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,axboe@kernel.dk,asml.silence@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] io_uring-zcrx-remove-nth_page-usage-within-folio.patch removed from -mm tree
Message-Id: <20250921212350.CE80AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: io_uring/zcrx: remove nth_page() usage within folio
has been removed from the -mm tree.  Its filename was
     io_uring-zcrx-remove-nth_page-usage-within-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: io_uring/zcrx: remove nth_page() usage within folio
Date: Mon, 1 Sep 2025 17:03:41 +0200

Within a folio/compound page, nth_page() is no longer required.  Given
that we call folio_test_partial_kmap()+kmap_local_page(), the code would
already be problematic if the pages would span multiple folios.

So let's just assume that all src pages belong to a single folio/compound
page and can be iterated ordinarily.  The dst page is currently always a
single page, so we're not actually iterating anything.

Link: https://lkml.kernel.org/r/20250901150359.867252-21-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 io_uring/zcrx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/io_uring/zcrx.c~io_uring-zcrx-remove-nth_page-usage-within-folio
+++ a/io_uring/zcrx.c
@@ -975,9 +975,9 @@ static ssize_t io_copy_page(struct io_co
 
 		if (folio_test_partial_kmap(page_folio(dst_page)) ||
 		    folio_test_partial_kmap(page_folio(src_page))) {
-			dst_page = nth_page(dst_page, dst_offset / PAGE_SIZE);
+			dst_page += dst_offset / PAGE_SIZE;
 			dst_offset = offset_in_page(dst_offset);
-			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
+			src_page += src_offset / PAGE_SIZE;
 			src_offset = offset_in_page(src_offset);
 			n = min(PAGE_SIZE - src_offset, PAGE_SIZE - dst_offset);
 			n = min(n, len);
_

Patches currently in -mm which might be from david@redhat.com are


