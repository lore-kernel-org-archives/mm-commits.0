From: akpm@linux-foundation.org
Subject: + c2port-fix-device_create-return-value-check.patch added to -mm tree
Date: Mon, 15 Mar 2010 15:13:36 -0700
Message-ID: <201003152213.o2FMDaBJ025666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936957Ab0COWNq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 18:13:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-jani.1.nikula@nokia.com, vegard.nossum@gmail.com


The patch titled
     c2port: fix device_create() return value check
has been added to the -mm tree.  Its filename is
     c2port-fix-device_create-return-value-check.patch

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
Subject: c2port: fix device_create() return value check
From: Jani Nikula <ext-jani.1.nikula@nokia.com>

Use IS_ERR() instead of comparing to NULL.

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/c2port/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/c2port/core.c~c2port-fix-device_create-return-value-check drivers/misc/c2port/core.c
--- a/drivers/misc/c2port/core.c~c2port-fix-device_create-return-value-check
+++ a/drivers/misc/c2port/core.c
@@ -912,7 +912,7 @@ struct c2port_device *c2port_device_regi
 
 	c2dev->dev = device_create(c2port_class, NULL, 0, c2dev,
 					"c2port%d", id);
-	if (unlikely(!c2dev->dev)) {
+	if (unlikely(IS_ERR(c2dev->dev))) {
 		ret = -ENOMEM;
 		goto error_device_create;
 	}
_

Patches currently in -mm which might be from ext-jani.1.nikula@nokia.com are

c2port-fix-device_create-return-value-check.patch
c2port-fix-device_create-return-value-check-fix.patch
errh-add-__must_check-to-error-pointer-handlers.patch

