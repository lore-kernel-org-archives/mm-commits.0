From: akpm@linux-foundation.org
Subject: + rocket-release_region-or-error-path.patch added to -mm tree
Date: Wed, 25 Aug 2010 15:22:55 -0700
Message-ID: <201008252222.o7PMMt21019260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012Ab0HYWW4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Aug 2010 18:22:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com


The patch titled
     drivers/char/rocket.c: release_region or error path
has been added to the -mm tree.  Its filename is
     rocket-release_region-or-error-path.patch

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
Subject: drivers/char/rocket.c: release_region or error path
From: Dan Carpenter <error27@gmail.com>

There was a release_region() missing on the error path.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/char/rocket.c~rocket-release_region-or-error-path drivers/char/rocket.c
--- a/drivers/char/rocket.c~rocket-release_region-or-error-path
+++ a/drivers/char/rocket.c
@@ -2345,7 +2345,7 @@ static int __init rp_init(void)
 	ret = tty_register_driver(rocket_driver);
 	if (ret < 0) {
 		printk(KERN_ERR "Couldn't install tty RocketPort driver\n");
-		goto err_tty;
+		goto err_controller;
 	}
 
 #ifdef ROCKET_DEBUG_OPEN
@@ -2380,6 +2380,9 @@ static int __init rp_init(void)
 	return 0;
 err_ttyu:
 	tty_unregister_driver(rocket_driver);
+err_controller:
+	if (controller)
+		release_region(controller, 4);
 err_tty:
 	put_tty_driver(rocket_driver);
 err:
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
drivers-scsi-pm8001-pm8001_hwic-handle-allocation-failures.patch
rocket-release_region-or-error-path.patch

