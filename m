From: akpm@linux-foundation.org
Subject: + i2c-dev-return-correct-error-code-on-class_create-failure.patch added to -mm tree
Date: Thu, 11 Sep 2008 11:58:37 -0700
Message-ID: <200809111858.m8BIwbpc011183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbYIKS6p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Sep 2008 14:58:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sven.wegener@stealer.net


The patch titled
     i2c-dev: return correct error code on class_create() failure
has been added to the -mm tree.  Its filename is
     i2c-dev-return-correct-error-code-on-class_create-failure.patch

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
Subject: i2c-dev: return correct error code on class_create() failure
From: Sven Wegener <sven.wegener@stealer.net>

We need to convert the error pointer from class_create(), else we'll
return the successful return code from register_chrdev() on failure.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/i2c-dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/i2c/i2c-dev.c~i2c-dev-return-correct-error-code-on-class_create-failure drivers/i2c/i2c-dev.c
--- a/drivers/i2c/i2c-dev.c~i2c-dev-return-correct-error-code-on-class_create-failure
+++ a/drivers/i2c/i2c-dev.c
@@ -583,8 +583,10 @@ static int __init i2c_dev_init(void)
 		goto out;
 
 	i2c_dev_class = class_create(THIS_MODULE, "i2c-dev");
-	if (IS_ERR(i2c_dev_class))
+	if (IS_ERR(i2c_dev_class)) {
+		res = PTR_ERR(i2c_dev_class);
 		goto out_unreg_chrdev;
+	}
 
 	res = i2c_add_driver(&i2cdev_driver);
 	if (res)
_

Patches currently in -mm which might be from sven.wegener@stealer.net are

linux-next.patch
i2c-dev-return-correct-error-code-on-class_create-failure.patch
leds-avoid-needless-strlen-for-attributes.patch
leds-wrap-use-default-on-trigger-for-power-led.patch
leds-fsg-change-order-of-initialization-and-deinitialization.patch
leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling.patch

