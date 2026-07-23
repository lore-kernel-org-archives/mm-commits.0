Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF8021883E;
	Thu, 23 Jul 2026 00:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784767012; cv=none; b=qen4I3gkVtrIWZ6c8kRzmMcHL+MzPSE0NLK5t1TjaoKXNQcGCvAfuYbLV8iLqwRedTcY1giO9XXD/u0S+RcvdAN4mXU6Gs7+Zz6Cup5397NXLIcyTu8/xb6TyXtu/MpUhCO3G5vuB93K645zOuglqwdB2jS4dGYWVH1ihSsx/bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784767012; c=relaxed/simple;
	bh=NxGEVJ0NCZ5+vonqmz7xjJhfAOCPAEgbmocu1jfWM+w=;
	h=Date:To:From:Subject:Message-Id; b=sufD+YMaHXB/SAxSS4KoFJ4FAloNDO8CU60gDmEDARu+t+OV5nYX7+5IZPC78Bp+PIcmNnvo+lN7HlYnORdDECD+NOWwu8GYWN4vL26lWSJWlaX0rQXFmZoNBPifTTGgHwIJ9GmGQlBXktgZhAdhMhl5bTS1OlnTeSjROttXmCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GNlZFilL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GNlZFilL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAF01F000E9;
	Thu, 23 Jul 2026 00:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784767010;
	bh=a9ECb29CnjSMhP5w1GLVIgpuQrZBCZs6k8kdHYM/ySg=;
	h=Date:To:From:Subject;
	b=GNlZFilLfLBUyGNehshKO2MJf7705P2sGQ2xukmIHNICYAJ4hLa4fCf7t1Jf7vRJO
	 HjAqzCMeO/ToT2fi3GFVNPOjljWKWqfIsu3jEt6iTXNFUie8z/6NbgEx7+SUok3LDv
	 2yGjLdZEmIOuCU9G7W1k6rpgbsBKAHKkAWVsTBZM=
Date: Wed, 22 Jul 2026 17:36:50 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,vbabka@kernel.org,stable@vger.kernel.org,rientjes@google.com,mst@redhat.com,jthoughton@google.com,jiaqiyan@google.com,jasowang@redhat.com,gthelen@google.com,david@kernel.org,alexander.duyck@gmail.com,linkl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_reporting-use-system_freezable_wq-to-fix-uaf-during-suspend.patch added to mm-hotfixes-unstable branch
Message-Id: <20260723003650.CAAF01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_reporting: use system_freezable_wq to fix UAF during suspend
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_reporting-use-system_freezable_wq-to-fix-uaf-during-suspend.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_reporting-use-system_freezable_wq-to-fix-uaf-during-suspend.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Tue, 21 Jul 2026 00:55:33 +0000

During PM freeze (e.g. S3 suspend or S4 hibernation), device drivers like
virtio_balloon reset their underlying virtio devices and delete their
virtqueues via vdev->config->del_vqs().

However, page reporting work (page_reporting_process) was scheduled on
the global system_wq. Because system_wq lacks the WQ_FREEZABLE flag, the
PM freezer skips it, leaving page_reporting_process active during suspend.

If pages are freed into the buddy allocator while suspending (for example,
when core MM invokes the balloon shrinker during S4 hibernation image
saving), page reporting triggers virtballoon_free_page_report() on deleted
virtqueues, resulting in a Use-After-Free / General Protection Fault:

    [  196.795226] general protection fault, probably for non-canonical add=
ress 0xaa1436fe70dae6df: 0000 [#1] SMP NOPTI
    [  196.825967] Workqueue: events page_reporting_process
    [  196.831038] RIP: 0010:virtqueue_add_split+0x233/0x4c0 [virtio_ring]
    [  196.927073] virtballoon_free_page_report+0x3a/0xe0 [virtio_balloon]
    [  196.946943] page_reporting_process+0x370/0x4f0

Fix this by switching page reporting work to system_freezable_wq. This
ensures that the PM freezer pauses page_reporting_process before device
drivers destroy their reporting virtqueues. Because the reporting worker
is frozen, memory reclamation/freeing (e.g. via shrinker execution) can
safely return pages to MM during freeze without triggering unfrozen
reporting work on deleted virtqueues.

This aligns with the driver's existing design. The comment in
virtballoon_freeze() states:
    /*
     * The workqueue is already frozen by the PM core before this
     * function is called.
     */

Testing:
I have verified these fixes using Google=E2=80=99s virtualization infrastru=
cture by
running continuous suspend/resume iterations (40+ cycles) while churning
memory using stress-ng (`stress-ng --vm 4 --vm-bytes 60% --timeout 1`) to
constantly create free pages for the buddy allocator. We also set the
`page_reporting_order` parameter to 0 to make the page reporting worker
highly sensitive, forcing it to pick up any 4K free pages. This confirmed
that the UAF crashes are no longer reproducible.

Link: https://lore.kernel.org/20260721005603.1710551-1-linkl@google.com
Fixes: 36e66c554b5c ("mm: introduce Reported pages")
Signed-off-by: Link Lin <linkl@google.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
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
@@ -80,7 +80,8 @@ __page_reporting_request(struct page_rep
 	 * now we are limiting this to running no more than once every
 	 * couple of seconds.
 	 */
-	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+	queue_delayed_work(system_freezable_wq, &prdev->work,
+			   PAGE_REPORTING_DELAY);
 }
 
 /* notify prdev of free page reporting request */
@@ -340,7 +341,8 @@ err_out:
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

