From: akpm@linux-foundation.org
Subject: [merged]
 virtio_balloon-leak_balloon-only-tell-host-if-we-got-pages-deflated.patch
 removed from -mm tree
Date: Wed, 03 Jul 2013 12:32:23 -0700
Message-ID: <51d47c47.Asyjo5F9zMLNX08s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965294Ab3GCTcY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 15:32:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, aquini@redhat.com, lcapitulino@redhat.com

Subject: [merged] virtio_balloon-leak_balloon-only-tell-host-if-we-got-pages-deflated.patch removed from -mm tree
To: lcapitulino@redhat.com,aquini@redhat.com,rusty@rustcorp.com.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 12:32:23 -0700


The patch titled
     Subject: virtio_balloon: leak_balloon(): only tell host if we got pages deflated
has been removed from the -mm tree.  Its filename was
     virtio_balloon-leak_balloon-only-tell-host-if-we-got-pages-deflated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: virtio_balloon: leak_balloon(): only tell host if we got pages deflated

balloon_page_dequeue() can return NULL.  If it does for the first page
being freed then leak_balloon() will create a scatter list with len=0. 
Which in turn seems to generate an invalid virtio request.

I didn't get this in practice, I found it by code review.  On the other
hand, such an invalid virtio request will cause errors in QEMU and
fill_balloon() also performs the same check implemented by this commit.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/virtio/virtio_balloon.c~virtio_balloon-leak_balloon-only-tell-host-if-we-got-pages-deflated drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~virtio_balloon-leak_balloon-only-tell-host-if-we-got-pages-deflated
+++ a/drivers/virtio/virtio_balloon.c
@@ -191,7 +191,8 @@ static void leak_balloon(struct virtio_b
 	 * virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
 	 * is true, we *have* to do it in this order
 	 */
-	tell_host(vb, vb->deflate_vq);
+	if (vb->num_pfns != 0)
+		tell_host(vb, vb->deflate_vq);
 	mutex_unlock(&vb->balloon_lock);
 	release_pages_by_pfn(vb->pfns, vb->num_pfns);
 }
_

Patches currently in -mm which might be from lcapitulino@redhat.com are

linux-next.patch

