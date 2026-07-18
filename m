Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451761A6836;
	Sat, 18 Jul 2026 00:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784335142; cv=none; b=leE+f3Ibqkdrh86OsaRCBQK7YmLNGjY7Hy+HuItTasBGVExk6X0uv3bQ9U+Qe4keOCkBgnxhHlmJR6+PKjeamCIcQxmviqQ4SAuWBFx8Nu5cu2CnF9cp40aY06qq7TGrDtxqIhCgYi1O01WtyoPauX01c1zvl9CgsEU9WjnEMSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784335142; c=relaxed/simple;
	bh=vMUVqKrtQaxjgxyLSzGNFv2QLAlGkh0RByaEYG5T2Ho=;
	h=Date:To:From:Subject:Message-Id; b=GldZBh2LYc46O/fnNl9firPneeR/J49U6pfVUKWsNW/9npbp55LDJ3JfiCXUWx09cauI9Nz4zQVgKnLCmT9CPU1IPoF9Xe8tWzGwq/XE7tqlPK4m7wtwH6/IXSaDNM6PP7UY1DRx4V+v4T1paY0Wi5m8BJgrnng8K5ArnqNHWkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XcQosxQx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XcQosxQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BECB1F000E9;
	Sat, 18 Jul 2026 00:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784335140;
	bh=Hj9EWKPqdgK3X+nZt7McjhWI8bDBdNWC5u5TqHcgMYo=;
	h=Date:To:From:Subject;
	b=XcQosxQxvT96YWVpFsw+KReYD4D7iTRYvsv5Xjf0ozasjaiLQv4lUp+E0A1j4PCJp
	 PokbBCZQXWLqH8xRPX8BXuVpiJGg0iKwFrGTDLt0Rij3DGa02mOUeIoFpAEWfsjvnR
	 ukj/aFP4DE++CmMSlKq4Ps3qSgpDGytm4YjV+adU=
Date: Fri, 17 Jul 2026 17:39:00 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,vbabka@kernel.org,stable@vger.kernel.org,rientjes@google.com,mst@redhat.com,jthoughton@google.com,jiaqiyan@google.com,jasowang@redhat.com,gthelen@google.com,david@redhat.com,david@kernel.org,alexander.duyck@gmail.com,linkl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_reporting-use-system_freezable_wq-to-fix-uaf-during-suspend.patch added to mm-new branch
Message-Id: <20260718003900.9BECB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_reporting: use system_freezable_wq to fix UAF during suspend
has been added to the -mm mm-new branch.  Its filename is
     mm-page_reporting-use-system_freezable_wq-to-fix-uaf-during-suspend.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_reporting-use-system_freezable_wq-to-fix-uaf-during-suspend.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Link Lin <linkl@google.com>
Subject: mm/page_reporting: use system_freezable_wq to fix UAF during suspend
Date: Fri, 17 Jul 2026 00:22:20 +0000

During PM freeze (e.g.  S3 suspend or S4 hibernation), device drivers like
virtio_balloon reset their underlying virtio devices and delete their
virtqueues via vdev->config->del_vqs().

However, page reporting work (page_reporting_process) was scheduled on the
global system_wq.  Because system_wq lacks the WQ_FREEZABLE flag, the PM
freezer skips it, leaving page_reporting_process active during suspend. 
If pages are freed into the buddy allocator while suspending, page
reporting invokes virtballoon_free_page_report() on deleted virtqueues:

    [  196.795226] general protection fault, probably for non-canonical address 0xaa1436fe70dae6df: 0000 [#1] SMP NOPTI
    [  196.825967] Workqueue: events page_reporting_process
    [  196.831038] RIP: 0010:virtqueue_add_split+0x233/0x4c0 [virtio_ring]
    [  196.927073] virtballoon_free_page_report+0x3a/0xe0 [virtio_balloon]
    [  196.946943] page_reporting_process+0x370/0x4f0

Fix this by switching page reporting work to system_freezable_wq.  This
ensures that the PM freezer pauses page_reporting_process before device
drivers destroy their reporting virtqueues.

This aligns with the driver's existing design. The comment in
virtballoon_freeze() states:
    /*
     * The workqueue is already frozen by the PM core before this
     * function is called.
     */

Link: https://lore.kernel.org/20260717002311.681748-2-linkl@google.com
Fixes: 924a663f75e2 ("virtio-balloon: Reporting free page reservations")
Signed-off-by: Link Lin <linkl@google.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_reporting.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_reporting.c~mm-page_reporting-use-system_freezable_wq-to-fix-uaf-during-suspend
+++ a/mm/page_reporting.c
@@ -81,7 +81,8 @@ __page_reporting_request(struct page_rep
 	 * now we are limiting this to running no more than once every
 	 * couple of seconds.
 	 */
-	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+	queue_delayed_work(system_freezable_wq, &prdev->work,
+			   PAGE_REPORTING_DELAY);
 }
 
 /* notify prdev of free page reporting request */
@@ -341,7 +342,8 @@ err_out:
 	 */
 	state = atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
 	if (state == PAGE_REPORTING_REQUESTED)
-		schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+		queue_delayed_work(system_freezable_wq, &prdev->work,
+				   PAGE_REPORTING_DELAY);
 }
 
 static DEFINE_MUTEX(page_reporting_mutex);
_

Patches currently in -mm which might be from linkl@google.com are

mm-page_reporting-use-system_freezable_wq-to-fix-uaf-during-suspend.patch
virtio_balloon-avoid-shrinker-execution-during-pm-suspend.patch

