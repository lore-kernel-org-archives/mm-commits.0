Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD8421B9E9
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 23:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740007844; cv=none; b=ojWt56LD2oKXBtOZ4n/nqAXz/FwNqe11qJKywZKZa16ViY8gJqOXRkhr3Sl1wAJVGe9zzLuoif9JV/oiK+kMDL2dH6gr8cmBsJmWxbaPPn+Gzb1a7DhokwHib7g3hDpEUO0aJOvmCk3aYok1VMLsJddkrto1SSJMLSwiD4dUbW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740007844; c=relaxed/simple;
	bh=7/ahxFDGt21CbL/x+A66rHx0UkDrpgZ8aAGEEefxh94=;
	h=Date:To:From:Subject:Message-Id; b=LYbdEckFXM5W/57iIZzN82Bs8m7gqCAirw8AF5LMy1wpf+JA9KM+Nz5SAFvK7xqBhCLubZx8LoNoXym3Uj/FG2eTn5hiLP66fa6fLWm18jfsFts8vt/QmHRoyknbnOaudei1cO9vjss3Uh30ghMnLngPqnRk1BOuUPcEuVGt24Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BmizHcTr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BmizHcTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C24AC4CED1;
	Wed, 19 Feb 2025 23:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740007843;
	bh=7/ahxFDGt21CbL/x+A66rHx0UkDrpgZ8aAGEEefxh94=;
	h=Date:To:From:Subject:From;
	b=BmizHcTrO1SiEEgMv3bjng4YjwzxO8v1KGClBCOiqkssweMaFNX3nZFrI+OzdC6LC
	 FtfjuQagRSC2JYrhHV1yu/w3mo5q1P9bHepKhQTcix0n5vIiCkjzRv5lHyoM6Sgl4t
	 EBG68IxfV4XKbBJEMAd8xLY7h9GphE7SX1DP/iGo=
Date: Wed, 19 Feb 2025 15:30:43 -0800
To: mm-commits@vger.kernel.org,shivankg@amd.com,dhowells@redhat.com,dev.jain@arm.com,brauner@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-folio_queue-delete-__folio_order-and-use-folio_order-directly.patch added to mm-unstable branch
Message-Id: <20250219233043.9C24AC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/folio_queue: delete __folio_order and use folio_order directly
has been added to the -mm mm-unstable branch.  Its filename is
     mm-folio_queue-delete-__folio_order-and-use-folio_order-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-folio_queue-delete-__folio_order-and-use-folio_order-directly.patch

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

mm-memfd-fix-spelling-and-grammatical-issues.patch
mm-folio_queue-delete-__folio_order-and-use-folio_order-directly.patch

