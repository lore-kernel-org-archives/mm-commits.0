From: akpm@linux-foundation.org
Subject: + drivers-char-rawc-remove-call-to-kobject_put.patch added to -mm tree
Date: Thu, 05 May 2011 15:27:53 -0700
Message-ID: <201105052227.p45MRrUK006693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964Ab1EEW21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2011 18:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     drivers/char/raw.c: remove call to kobject_put().
has been added to the -mm tree.  Its filename is
     drivers-char-rawc-remove-call-to-kobject_put.patch

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
Subject: drivers/char/raw.c: remove call to kobject_put().
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

If cdev_add() fails, there is no justification for subsequently
calling kobject_put().

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/raw.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/raw.c~drivers-char-rawc-remove-call-to-kobject_put drivers/char/raw.c
--- a/drivers/char/raw.c~drivers-char-rawc-remove-call-to-kobject_put
+++ a/drivers/char/raw.c
@@ -319,7 +319,6 @@ static int __init raw_init(void)
 	cdev_init(&raw_cdev, &raw_fops);
 	ret = cdev_add(&raw_cdev, dev, MAX_RAW_MINORS);
 	if (ret) {
-		kobject_put(&raw_cdev.kobj);
 		goto error_region;
 	}
 
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

linux-next.patch
drivers-char-rawc-remove-call-to-kobject_put.patch

