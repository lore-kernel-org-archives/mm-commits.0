Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9C3217673
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188409; cv=none; b=niZa0Xae9mqAVHTegCOc76ItAmS0d6lDaK4knOO/yuxgyKtCBfdcSEGNxNp5XDT3Pwocbqp3DcSf2ZRg8mPoQMcZoytjEoX7wRTEtNAqHMVxJNai1czFYhSVWUOFK6ZG8zajFj4CgWDtSRHoY3Ri0Mq9VkMcfoCwOWLMaQ2CcZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188409; c=relaxed/simple;
	bh=A2pqK48VZq3r84vIzRnBeEMpEiosYuYcmWMIWeLMWFE=;
	h=Date:To:From:Subject:Message-Id; b=vGW/bbm5RCE1gLuJdUa8sjjLfai6fIeokGlBz/pUwu0+1vn9RNfha7Ho+X5G6KRsNJS42cbGj0t2QTBAoUfyjtFV14NllYMZEZMNNacRsVH6SSbUZjn6h5BPtXMfiS2PjJtVUztl6HkDUcJYetm31dX1UJUqDrrUyXkYU9xkImQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ewYRtsD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ewYRtsD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DB7C4CEEC;
	Mon, 17 Mar 2025 05:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188409;
	bh=A2pqK48VZq3r84vIzRnBeEMpEiosYuYcmWMIWeLMWFE=;
	h=Date:To:From:Subject:From;
	b=ewYRtsD3wvubXamc1UEVkqqtyfP/7WAF/P09XW6F3K6z65vvZC4hmzPPC3UlTciia
	 BfJ9hpOLBMRzQlNxWxIVFmLHo9NPG1pm7ePbKqZ8jEXymySy4QID6VZejXSYPwI99x
	 /zDGsB3xq6r0+MuvY9ae71GTDl39KHf4nwdQqO4Y=
Date: Sun, 16 Mar 2025 22:13:28 -0700
To: mm-commits@vger.kernel.org,shivankg@amd.com,dhowells@redhat.com,dev.jain@arm.com,brauner@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-folio_queue-delete-__folio_order-and-use-folio_order-directly.patch removed from -mm tree
Message-Id: <20250317051329.42DB7C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/folio_queue: delete __folio_order and use folio_order directly
has been removed from the -mm tree.  Its filename was
     mm-folio_queue-delete-__folio_order-and-use-folio_order-directly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Ye <liuye@kylinos.cn>
Subject: mm/folio_queue: delete __folio_order and use folio_order directly
Date: Wed, 12 Feb 2025 10:58:42 +0800

__folio_order is the same as folio_order, remove __folio_order and then
just include mm.h and use folio_order directly.

Link: https://lkml.kernel.org/r/20250212025843.80283-2-liuye@kylinos.cn
Signed-off-by: Liu Ye <liuye@kylinos.cn>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/folio_queue.h |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/include/linux/folio_queue.h~mm-folio_queue-delete-__folio_order-and-use-folio_order-directly
+++ a/include/linux/folio_queue.h
@@ -15,6 +15,7 @@
 #define _LINUX_FOLIO_QUEUE_H
 
 #include <linux/pagevec.h>
+#include <linux/mm.h>
 
 /*
  * Segment in a queue of running buffers.  Each segment can hold a number of
@@ -216,13 +217,6 @@ static inline void folioq_unmark3(struct
 	clear_bit(slot, &folioq->marks3);
 }
 
-static inline unsigned int __folio_order(struct folio *folio)
-{
-	if (!folio_test_large(folio))
-		return 0;
-	return folio->_flags_1 & 0xff;
-}
-
 /**
  * folioq_append: Add a folio to a folio queue segment
  * @folioq: The segment to add to
@@ -241,7 +235,7 @@ static inline unsigned int folioq_append
 	unsigned int slot = folioq->vec.nr++;
 
 	folioq->vec.folios[slot] = folio;
-	folioq->orders[slot] = __folio_order(folio);
+	folioq->orders[slot] = folio_order(folio);
 	return slot;
 }
 
@@ -263,7 +257,7 @@ static inline unsigned int folioq_append
 	unsigned int slot = folioq->vec.nr++;
 
 	folioq->vec.folios[slot] = folio;
-	folioq->orders[slot] = __folio_order(folio);
+	folioq->orders[slot] = folio_order(folio);
 	folioq_mark(folioq, slot);
 	return slot;
 }
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-refactoring-function-__vmalloc_node_range_noprof.patch
mm-debug-add-line-breaks.patch

