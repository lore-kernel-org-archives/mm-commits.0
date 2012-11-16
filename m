From: akpm@linux-foundation.org
Subject: + virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix.patch added to -mm tree
Date: Fri, 16 Nov 2012 12:37:19 -0800
Message-ID: <20121116203720.A487720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:49379 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab2KPUhW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Nov 2012 15:37:22 -0500
Received: by mail-fa0-f74.google.com with SMTP id w1so203029fad.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Nov 2012 12:37:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn


The patch titled
     Subject: virtio: balloon: fix missing unlock on error in fill_balloon()
has been added to the -mm tree.  Its filename is
     virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
linux-next.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
procfs-use-kbasename-fix.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch

