From: akpm@linux-foundation.org
Subject: + sg_io-fix-sg_io_hdrinfo-corruption-in-compat-code.patch added to -mm tree
Date: Tue, 30 Dec 2008 15:46:13 -0800
Message-ID: <200812302346.mBUNkDiC014444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbYL3XqU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:46:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexey.zaytsev@gmail.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com


The patch titled
     sg_io: fix sg_io_hdr.info corruption in compat code
has been added to the -mm tree.  Its filename is
     sg_io-fix-sg_io_hdrinfo-corruption-in-compat-code.patch

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
Subject: sg_io: fix sg_io_hdr.info corruption in compat code
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>

sizeof(unsigned (short)) is actually sizeof(function), == 1.  Spotted by
sparse.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/compat_ioctl.c~sg_io-fix-sg_io_hdrinfo-corruption-in-compat-code fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~sg_io-fix-sg_io_hdrinfo-corruption-in-compat-code
+++ a/fs/compat_ioctl.c
@@ -784,7 +784,7 @@ static int sg_ioctl_trans(unsigned int f
 
 	if (copy_in_user(&sgio->status, &sgio32->status,
 			 (4 * sizeof(unsigned char)) +
-			 (2 * sizeof(unsigned (short))) +
+			 (2 * sizeof(unsigned short)) +
 			 (3 * sizeof(int))))
 		return -EFAULT;
 
_

Patches currently in -mm which might be from alexey.zaytsev@gmail.com are

sg_io-fix-sg_io_hdrinfo-corruption-in-compat-code.patch

