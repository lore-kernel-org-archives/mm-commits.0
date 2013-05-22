From: akpm@linux-foundation.org
Subject: + block-compat_ioctlc-do-not-leak-info-to-user-space.patch added
 to -mm tree
Date: Wed, 22 May 2013 14:07:38 -0700
Message-ID: <519d339a./VkfrS4U+j7lJXf3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab3EVVHj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 17:07:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, amwang@redhat.com

Subject: + block-compat_ioctlc-do-not-leak-info-to-user-space.patch added to -mm tree
To: amwang@redhat.com,axboe@kernel.dk
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 14:07:38 -0700


The patch titled
     Subject: block/compat_ioctl.c: do not leak info to user-space
has been added to the -mm tree.  Its filename is
     block-compat_ioctlc-do-not-leak-info-to-user-space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
block-compat_ioctlc-do-not-leak-info-to-user-space.patch

