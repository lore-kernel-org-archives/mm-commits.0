From: akpm@linux-foundation.org
Subject: + phonedev-remove-bkl.patch added to -mm tree
Date: Thu, 16 Oct 2008 12:28:04 -0700
Message-ID: <200810161928.m9GJS4GG007166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756531AbYJPT2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 15:28:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aciddeath@gmail.com


The patch titled
     phonedev: remove BKL
has been added to the -mm tree.  Its filename is
     phonedev-remove-bkl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: phonedev: remove BKL
From: Richard Holden <aciddeath@gmail.com>

The phone_device array is covered by the phone_lock mutex in all cases and
request_module no longer needs the BKL so we can remove the only remaining
instance of the BKL from phonedev.

Signed-off-by: Richard Holden <aciddeath@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/telephony/phonedev.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/telephony/phonedev.c~phonedev-remove-bkl drivers/telephony/phonedev.c
--- a/drivers/telephony/phonedev.c~phonedev-remove-bkl
+++ a/drivers/telephony/phonedev.c
@@ -54,7 +54,6 @@ static int phone_open(struct inode *inod
 	if (minor >= PHONE_NUM_DEVICES)
 		return -ENODEV;
 
-	lock_kernel();
 	mutex_lock(&phone_lock);
 	p = phone_device[minor];
 	if (p)
@@ -81,7 +80,6 @@ static int phone_open(struct inode *inod
 	fops_put(old_fops);
 end:
 	mutex_unlock(&phone_lock);
-	unlock_kernel();
 	return err;
 }
 
_

Patches currently in -mm which might be from aciddeath@gmail.com are

phonedev-remove-bkl.patch

