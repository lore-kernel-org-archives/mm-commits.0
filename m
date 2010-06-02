From: akpm@linux-foundation.org
Subject: + char-add-warn_on-in-misc_deregister.patch added to -mm tree
Date: Wed, 02 Jun 2010 13:11:11 -0700
Message-ID: <201006022011.o52KBBah014394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932805Ab0FBULR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 16:11:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     char: add WARN_ON() in misc_deregister()
has been added to the -mm tree.  Its filename is
     char-add-warn_on-in-misc_deregister.patch

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
Subject: char: add WARN_ON() in misc_deregister()
From: Akinobu Mita <akinobu.mita@gmail.com>

misc_deregister() returns an error only when it attempts to unregister
the device that is not registered. This is the driver's bug.

Most of the drivers don't check the return value of misc_deregister().
(It is not bad thing because most of kernel *_unregister() API always
succeed and do not return value)

So it is better to indicate the error by WARN_ON() in misc_deregister().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/misc.c~char-add-warn_on-in-misc_deregister drivers/char/misc.c
--- a/drivers/char/misc.c~char-add-warn_on-in-misc_deregister
+++ a/drivers/char/misc.c
@@ -242,7 +242,7 @@ int misc_deregister(struct miscdevice *m
 {
 	int i = DYNAMIC_MINORS - misc->minor - 1;
 
-	if (list_empty(&misc->list))
+	if (WARN_ON(list_empty(&misc->list)))
 		return -EINVAL;
 
 	mutex_lock(&misc_mtx);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
kernel-fix-bug_on-checks-for-cpu-notifier-callbacks-direct-call.patch
char-add-warn_on-in-misc_deregister.patch
s390-remove-warn_on-for-misc_deregister-failures.patch

