Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2333335F609;
	Sat, 18 Jul 2026 20:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784405396; cv=none; b=f8pA95dksBJTMKzTz7ygVBpmm8LwcJk/Z1eoaYsJWodsYNFbEuWIln4FO3CEEGfr6A00IP/bCgA0G2ZPMq8lXx3djNvUFzb2Q5u5OMjMSPN/JOt/SGZIc/sXhn1IVaL6mhUGG4rsRn6o5ewSRrYk2gHMiVX88SqcpOjDqXEGgSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784405396; c=relaxed/simple;
	bh=s6dh2Qoufnm1NG1/Sx5OXVui+FawFigXmJaK68ktrOI=;
	h=Date:To:From:Subject:Message-Id; b=Ef7xnP89SukufV/GgxMCLBiev1Up3RZGRm843RWEx+pfaCB+6BZ7mYd1PQwMknQQQDKp9agtc2HGDrA5NPqNbFbkyUIGGsiUul24r2yQjSCNKDgc8YxBanQYoSgtrfg16TryKusBW5MgBpcBKi/wn9krUNLHLHvml1Vtt1rAtfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qEeK8048; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qEeK8048"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB59E1F00A3A;
	Sat, 18 Jul 2026 20:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784405394;
	bh=kRlNat1tgv4wo8O60ejDy+bez9CPlJRDx3d+rpOWvg4=;
	h=Date:To:From:Subject;
	b=qEeK8048IAdk4V4XICq0KVSqGnroGupE7YX9J+4E7XOAKrfmQ7m0SZYFPepd9VxEb
	 2jBivyVaJKDx6a7KxAgeOwDQJhLzFUP5M3IHY29gCrtd0PqQME935gwdytnbh00iqq
	 xepz8Bbdjf6n3S+CSqeZl4+hUlyOj6NgHJInQ77M=
Date: Sat, 18 Jul 2026 13:09:54 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,vbabka@kernel.org,stable@vger.kernel.org,rientjes@google.com,mst@redhat.com,jthoughton@google.com,jiaqiyan@google.com,jasowang@redhat.com,gthelen@google.com,david@redhat.com,david@kernel.org,alexander.duyck@gmail.com,linkl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] virtio_balloon-avoid-shrinker-execution-during-pm-suspend.patch removed from -mm tree
Message-Id: <20260718200954.BB59E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: virtio_balloon: avoid shrinker execution during PM suspend
has been removed from the -mm tree.  Its filename was
     virtio_balloon-avoid-shrinker-execution-during-pm-suspend.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Link Lin <linkl@google.com>
Subject: virtio_balloon: avoid shrinker execution during PM suspend
Date: Fri, 17 Jul 2026 00:22:21 +0000

During PM freeze (e.g. S4 hibernation), virtballoon_freeze() calls
remove_common() which resets the virtio device and deletes all virtqueues.
However, the balloon shrinker remains registered with core MM.

If memory pressure occurs during S4 hibernation image creation/saving, MM
invokes virtio_balloon_shrinker_scan(), which attempts to reclaim free
pages. Although return_free_pages_to_mm() only frees pages back to MM,
reclaiming free pages under memory pressure can trigger page reporting
which might access the deleted reporting virtqueue if it is not yet
frozen, or interact with other parts of the driver in a teardown state.

Avoid this by adding a `suspended` flag to `struct virtio_balloon`. Set
this flag to true in virtballoon_freeze() and false in
virtballoon_restore(). Check this flag in both shrinker callbacks (scan
and count) and return 0 if the device is suspended, preventing any
shrinker execution while virtqueues are deleted. Wrap the lockless reads
in READ_ONCE() and writes in WRITE_ONCE() to prevent compiler
optimization issues and KCSAN data race warnings.

Link: https://lore.kernel.org/20260717002311.681748-3-linkl@google.com
Fixes: 71019de8219b ("virtio_balloon: Add free page hinting support")
Signed-off-by: Link Lin <linkl@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Suggested-by: James Houghton <jthoughton@google.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |   49 +++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 8 deletions(-)

--- a/drivers/virtio/virtio_balloon.c~virtio_balloon-avoid-shrinker-execution-during-pm-suspend
+++ a/drivers/virtio/virtio_balloon.c
@@ -68,6 +68,8 @@ struct virtio_balloon {
 	/* Prevent updating balloon when it is being canceled. */
 	spinlock_t stop_update_lock;
 	bool stop_update;
+	/* Prevent shrinker from running while device is suspended. */
+	bool suspended;
 	/* Bitmap to indicate if reading the related config fields are needed */
 	unsigned long config_read_bitmap;
 
@@ -471,9 +473,9 @@ static inline s64 towards_target(struct
 	return target - vb->num_pages;
 }
 
-/* Gives back @num_to_return blocks of free pages to mm. */
-static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
-					     unsigned long num_to_return)
+/* Helper: must be called with free_page_list_lock held */
+static unsigned long __return_free_pages_to_mm(struct virtio_balloon *vb,
+					       unsigned long num_to_return)
 {
 	unsigned long num_returned = 0;
 	struct page *page, *next;
@@ -481,8 +483,6 @@ static unsigned long return_free_pages_t
 	if (unlikely(!num_to_return))
 		return 0;
 
-	spin_lock_irq(&vb->free_page_list_lock);
-
 	list_for_each_entry_safe(page, next, &vb->free_page_list, lru) {
 		list_del(&page->lru);
 		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
@@ -490,11 +490,27 @@ static unsigned long return_free_pages_t
 			break;
 	}
 	vb->num_free_page_blocks -= num_returned;
-	spin_unlock_irq(&vb->free_page_list_lock);
 
 	return num_returned;
 }
 
+/* Gives back @num_to_return blocks of free pages to mm. */
+static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
+					     unsigned long num_to_return)
+{
+	unsigned long ret;
+
+	spin_lock_irq(&vb->free_page_list_lock);
+	if (vb->suspended) {
+		spin_unlock_irq(&vb->free_page_list_lock);
+		return 0;
+	}
+	ret = __return_free_pages_to_mm(vb, num_to_return);
+	spin_unlock_irq(&vb->free_page_list_lock);
+
+	return ret;
+}
+
 static void virtio_balloon_queue_free_page_work(struct virtio_balloon *vb)
 {
 	if (!virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
@@ -871,6 +887,9 @@ static unsigned long virtio_balloon_shri
 {
 	struct virtio_balloon *vb = shrinker->private_data;
 
+	if (READ_ONCE(vb->suspended))
+		return 0;
+
 	return shrink_free_pages(vb, sc->nr_to_scan);
 }
 
@@ -879,6 +898,9 @@ static unsigned long virtio_balloon_shri
 {
 	struct virtio_balloon *vb = shrinker->private_data;
 
+	if (READ_ONCE(vb->suspended))
+		return 0;
+
 	return vb->num_free_page_blocks * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
 }
 
@@ -1086,8 +1108,11 @@ static void remove_common(struct virtio_
 	update_balloon_size(vb);
 
 	/* There might be free pages that are being reported: release them. */
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
-		return_free_pages_to_mm(vb, ULONG_MAX);
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
+		spin_lock_irq(&vb->free_page_list_lock);
+		__return_free_pages_to_mm(vb, ULONG_MAX);
+		spin_unlock_irq(&vb->free_page_list_lock);
+	}
 
 	/* Now we reset the device so we can clean up the queues. */
 	virtio_reset_device(vb->vdev);
@@ -1130,6 +1155,10 @@ static int virtballoon_freeze(struct vir
 	 * The workqueue is already frozen by the PM core before this
 	 * function is called.
 	 */
+	spin_lock_irq(&vb->free_page_list_lock);
+	WRITE_ONCE(vb->suspended, true);
+	spin_unlock_irq(&vb->free_page_list_lock);
+
 	remove_common(vb);
 	return 0;
 }
@@ -1145,6 +1174,10 @@ static int virtballoon_restore(struct vi
 
 	virtio_device_ready(vdev);
 
+	spin_lock_irq(&vb->free_page_list_lock);
+	WRITE_ONCE(vb->suspended, false);
+	spin_unlock_irq(&vb->free_page_list_lock);
+
 	if (towards_target(vb))
 		virtballoon_changed(vdev);
 	update_balloon_size(vb);
_

Patches currently in -mm which might be from linkl@google.com are


