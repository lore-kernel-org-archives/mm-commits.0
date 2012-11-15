From: akpm@linux-foundation.org
Subject: [folded-dropped] virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix.patch removed from -mm tree
Date: Thu, 15 Nov 2012 11:55:23 -0800
Message-ID: <20121115195524.5D687200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:54882 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768751Ab2KOTz0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 14:55:26 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so136185wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 11:55:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: virtio: balloon: fix missing unlock on error in fill_balloon()
has been removed from the -mm tree.  Its filename was
     virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix.patch

This patch was dropped because it was folded into virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: virtio: balloon: fix missing unlock on error in fill_balloon()

Add the missing unlock before return from function fill_balloon()
in the error handling case.

Introduced by 9864a8 ("virtio_balloon: introduce migration primitives to
balloon pages").

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/virtio/virtio_balloon.c~virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix
+++ a/drivers/virtio/virtio_balloon.c
@@ -152,8 +152,10 @@ static void fill_balloon(struct virtio_b
 	}
 
 	/* Didn't get any?  Oh well. */
-	if (vb->num_pfns == 0)
+	if (vb->num_pfns == 0) {
+		mutex_unlock(&vb->balloon_lock);
 		return;
+	}
 
 	tell_host(vb, vb->inflate_vq);
 	mutex_unlock(&vb->balloon_lock);
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

linux-next.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
procfs-use-kbasename-fix.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch

