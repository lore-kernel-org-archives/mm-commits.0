From: akpm@linux-foundation.org
Subject: [merged] block-compat_ioctlc-do-not-leak-info-to-user-space.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:41 -0700
Message-ID: <51db11bd.PiEJe2OHiWXl3yWW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3GHTXl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, amwang@redhat.com

Subject: [merged] block-compat_ioctlc-do-not-leak-info-to-user-space.patch removed from -mm tree
To: amwang@redhat.com,axboe@kernel.dk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:41 -0700


The patch titled
     Subject: block/compat_ioctl.c: do not leak info to user-space
has been removed from the -mm tree.  Its filename was
     block-compat_ioctlc-do-not-leak-info-to-user-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cong Wang <amwang@redhat.com>
Subject: block/compat_ioctl.c: do not leak info to user-space

There is a hole in struct hd_geometry, so we have to zero the struct on
stack before copying it to user-space.

Signed-off-by: Cong Wang <amwang@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/compat_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN block/compat_ioctl.c~block-compat_ioctlc-do-not-leak-info-to-user-space block/compat_ioctl.c
--- a/block/compat_ioctl.c~block-compat_ioctlc-do-not-leak-info-to-user-space
+++ a/block/compat_ioctl.c
@@ -59,6 +59,7 @@ static int compat_hdio_getgeo(struct gen
 	if (!disk->fops->getgeo)
 		return -ENOTTY;
 
+	memset(&geo, 0, sizeof(geo));
 	/*
 	 * We need to set the startsect first, the driver may
 	 * want to override it.
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
linux-next.patch

