From: akpm@linux-foundation.org
Subject: + sg_io-dont-perform-unneeded-copy-in-compat-code.patch added to -mm tree
Date: Mon, 05 Jan 2009 14:57:04 -0800
Message-ID: <200901052257.n05Mv48n017676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbZAEW5p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 17:57:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexey.zaytsev@gmail.com, James.Bottomley@HansenPartnership.com, dgilbert@interlog.com, fujita.tomonori@lab.ntt.co.jp


The patch titled
     sg_io: don't perform unneeded copy in compat code
has been added to the -mm tree.  Its filename is
     sg_io-dont-perform-unneeded-copy-in-compat-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sg_io: don't perform unneeded copy in compat code
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>

FUJITA Tomonori says:

The members from 'status' in struct sg_io_hdr to the last are used to
transfer information from kernel to user space. The values that user
space sets are just ignored.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN fs/compat_ioctl.c~sg_io-dont-perform-unneeded-copy-in-compat-code fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~sg_io-dont-perform-unneeded-copy-in-compat-code
+++ a/fs/compat_ioctl.c
@@ -782,12 +782,6 @@ static int sg_ioctl_trans(unsigned int f
 	if (put_user(compat_ptr(data), &sgio->usr_ptr))
 		return -EFAULT;
 
-	if (copy_in_user(&sgio->status, &sgio32->status,
-			 (4 * sizeof(unsigned char)) +
-			 (2 * sizeof(unsigned (short))) +
-			 (3 * sizeof(int))))
-		return -EFAULT;
