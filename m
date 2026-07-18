Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0803636CDF2;
	Sat, 18 Jul 2026 20:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784405395; cv=none; b=htejm4KCjXGIB27gn2oMfhZggCZwMTASOQsNxbLM9vXviJyK5Qw1bCUJeik1GLt/XwYvhcDP1BjiYxixIhaMumRSx67E9pny2N3VJTjSQeza/C4Q6NkAlVPpJPjFtpH6fkbJyTPcZ46gULdPiLOxAxYZmz2GDUf3uV37HiwOKcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784405395; c=relaxed/simple;
	bh=cUS3fOfCAFr1yeB+OGxun9/ZBhl3IOHQ6yYm5QB0BQY=;
	h=Date:To:From:Subject:Message-Id; b=Ybm7QfY4+WzekRGbd9hHHAb3t2JAtiRKrRhTYyK5vOxpAwRDnwqw3uY59PSTKnryxtUHX3RgTOfhpxK6WO/EM8hxuJPaX0o/kNOV9fu32BXyuaHH/7qvtLcK8aZgX3KBdFhWhD8gjF8mA1CLhHKB27A321Bgfxm66Axx9ineLrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S7Rvm0Wd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S7Rvm0Wd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8971F000E9;
	Sat, 18 Jul 2026 20:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784405393;
	bh=EJKz072rpmaTlCP1ReN8e6gL8iWeXc85cEsUTLflTD8=;
	h=Date:To:From:Subject;
	b=S7Rvm0Wd++0MyMOTCmBG/R7MwtezdURLfID9sq4o6q8zBmXbBeV+kK66vFckcUt2O
	 iaj4eKCaIDNy3l5q0wCEzGpjeOsgDTRPoIpH62OvQw2eb7G8OQkYp5APnhE+ziB+g1
	 wU+W4mmWr86UGryfwkrDNDXRIEIkW1pjDCfwKWhE=
Date: Sat, 18 Jul 2026 13:09:53 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,vbabka@kernel.org,stable@vger.kernel.org,rientjes@google.com,mst@redhat.com,jthoughton@google.com,jiaqiyan@google.com,jasowang@redhat.com,gthelen@google.com,david@redhat.com,david@kernel.org,alexander.duyck@gmail.com,linkl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_reporting-use-system_freezable_wq-to-fix-uaf-during-suspend.patch removed from -mm tree
Message-Id: <20260718200953.8C8971F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_reporting: use system_freezable_wq to fix UAF during suspend
has been removed from the -mm tree.  Its filename was
     mm-page_reporting-use-system_freezable_wq-to-fix-uaf-during-suspend.patch

This patch was dropped because an updated version will be issued

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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
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

virtio_balloon-avoid-shrinker-execution-during-pm-suspend.patch

