From: akpm@linux-foundation.org
Subject: + ip2-return-efault-on-copy_to_user-errors.patch added to -mm tree
Date: Thu, 12 Aug 2010 13:48:59 -0700
Message-ID: <201008122048.o7CKmxm5011932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754980Ab0HLUtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 16:49:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, greg@kroah.com, mhw@wittsend.com


The patch titled
     ip2: return -EFAULT on copy_to_user errors
has been added to the -mm tree.  Its filename is
     ip2-return-efault-on-copy_to_user-errors.patch

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
Subject: ip2: return -EFAULT on copy_to_user errors
From: Dan Carpenter <error27@gmail.com>

copy_to_user() returns the number of bytes remaining but we want to return
a negative error code on errors.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: "Michael H. Warfield" <mhw@wittsend.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/char/ip2/ip2main.c~ip2-return-efault-on-copy_to_user-errors drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~ip2-return-efault-on-copy_to_user-errors
+++ a/drivers/char/ip2/ip2main.c
@@ -2930,6 +2930,8 @@ ip2_ipl_ioctl (struct file *pFile, UINT 
 				if ( pCh )
 				{
 					rc = copy_to_user(argp, pCh, sizeof(i2ChanStr));
+					if (rc)
+						rc = -EFAULT;
 				} else {
 					rc = -ENODEV;
 				}
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
ip2-remove-unneeded-null-check.patch
ip2-return-efault-on-copy_to_user-errors.patch

