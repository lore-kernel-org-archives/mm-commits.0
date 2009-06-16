From: akpm@linux-foundation.org
Subject: [merged] sg_io-dont-perform-unneeded-copy-in-compat-code.patch removed from -mm tree
Date: Tue, 16 Jun 2009 11:27:46 -0700
Message-ID: <200906161827.n5GIRkPR028213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756631AbZFPS2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 14:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexey.zaytsev@gmail.com, James.Bottomley@HansenPartnership.com, dgilbert@interlog.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     sg_io: don't perform unneeded copy in compat code
has been removed from the -mm tree.  Its filename was
     sg_io-dont-perform-unneeded-copy-in-compat-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sg_io: don't perform unneeded copy in compat code
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>

The members from 'status' in struct sg_io_hdr to the last are used to
transfer information from kernel to user space.  The values that user
space sets are just ignored.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN fs/compat_ioctl.c~sg_io-dont-perform-unneeded-copy-in-compat-code fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~sg_io-dont-perform-unneeded-copy-in-compat-code
+++ a/fs/compat_ioctl.c
@@ -787,12 +787,6 @@ static int sg_ioctl_trans(unsigned int f
 	if (put_user(compat_ptr(data), &sgio->usr_ptr))
 		return -EFAULT;
 
-	if (copy_in_user(&sgio->status, &sgio32->status,
-			 (4 * sizeof(unsigned char)) +
-			 (2 * sizeof(unsigned short)) +
-			 (3 * sizeof(int))))
-		return -EFAULT;
