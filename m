Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DBF29D292
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489906; cv=none; b=UIcni73bungL1iTss5ve+DCq9XdlemOFqnCVh81+lCBuK4+SL8RM2RNgI+1ecD0shivNPWStkZj8Pl0VafoLNQ2oAqYp6uVooPt9/qWiinzJte5DAPKFgw8dd9VCvXPv/F2flTaTYDWs+LD7ZvdMTzl6rA8CjD/XPQu/S4QhGI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489906; c=relaxed/simple;
	bh=SlfyBqXXMvHAkcdydMqyhKFJpZ3qGT50UlZxQxQ7MrM=;
	h=Date:To:From:Subject:Message-Id; b=UnqfVgusUweeXondhkI9uZvmJKLMhgdTupCLJ/u1xqrF/Rwd9iRv2o6Kj7Aw3jyac69qocoMVdtfiaXTOLXqB77iBzoKNk7ITW0Pv0WbsAP+ipUouyhK67VutvEJxFpm0lYXdjjy955JGlYUs/n5lZ+hl5r/ETCJ9GJ7GJ4wuqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HRMQCmho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HRMQCmho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12262C4CEE7;
	Sun, 21 Sep 2025 21:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489906;
	bh=SlfyBqXXMvHAkcdydMqyhKFJpZ3qGT50UlZxQxQ7MrM=;
	h=Date:To:From:Subject:From;
	b=HRMQCmhobeCL9qkx8nlFh9fbifjYkcMXHKHZ4WiBVObIJa4ktyFl/tjY1GkjaM5/k
	 6P3cMA/UbgXb37Zu4Lj0h3AIQUfAbZbyyotSnUbd/LavnZT3cgS88vRXU96RDowZhJ
	 1mSFU6g1p5HvjmIzjWaN1nhLIQYqiPyXK3+TfuT4=
Date: Sun, 21 Sep 2025 14:25:05 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,sj@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mst@redhat.com,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,justin@coraid.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,axboe@kernel.dk,aou@eecs.berkeley.edu,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] virtio_balloon-stop-calling-page_address-in-free_pages.patch removed from -mm tree
Message-Id: <20250921212506.12262C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: virtio_balloon: stop calling page_address() in free_pages()
has been removed from the -mm tree.  Its filename was
     virtio_balloon-stop-calling-page_address-in-free_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: virtio_balloon: stop calling page_address() in free_pages()
Date: Wed, 3 Sep 2025 11:59:21 -0700

free_pages() should be used when we only have a virtual address.  We
should call __free_pages() directly on our page instead.

Link: https://lkml.kernel.org/r/20250903185921.1785167-8-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Justin Sanders <justin@coraid.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/virtio/virtio_balloon.c~virtio_balloon-stop-calling-page_address-in-free_pages
+++ a/drivers/virtio/virtio_balloon.c
@@ -488,8 +488,7 @@ static unsigned long return_free_pages_t
 		page = balloon_page_pop(&vb->free_page_list);
 		if (!page)
 			break;
-		free_pages((unsigned long)page_address(page),
-			   VIRTIO_BALLOON_HINT_BLOCK_ORDER);
+		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
 	}
 	vb->num_free_page_blocks -= num_returned;
 	spin_unlock_irq(&vb->free_page_list_lock);
@@ -719,8 +718,7 @@ static int get_free_page_and_send(struct
 	if (vq->num_free > 1) {
 		err = virtqueue_add_inbuf(vq, &sg, 1, p, GFP_KERNEL);
 		if (unlikely(err)) {
-			free_pages((unsigned long)p,
-				   VIRTIO_BALLOON_HINT_BLOCK_ORDER);
+			__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
 			return err;
 		}
 		virtqueue_kick(vq);
@@ -733,7 +731,7 @@ static int get_free_page_and_send(struct
 		 * The vq has no available entry to add this page block, so
 		 * just free it.
 		 */
-		free_pages((unsigned long)p, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
+		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


