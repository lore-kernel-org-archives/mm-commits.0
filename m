From: akpm@linux-foundation.org
Subject: + gpiolib-fix-request-related-issue.patch added to -mm tree
Date: Fri, 16 Jan 2009 14:24:11 -0800
Message-ID: <200901162224.n0GMOBZ4012627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbZAPWYZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 17:24:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@igel.co.jp, dbrownell@users.sourceforge.net, stable@kernel.org


The patch titled
     gpiolib: fix request related issue
has been added to the -mm tree.  Its filename is
     gpiolib-fix-request-related-issue.patch

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
Subject: gpiolib: fix request related issue
From: Magnus Damm <damm@igel.co.jp>

Fix request-already-requested handling in gpio_request().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpio/gpiolib.c~gpiolib-fix-request-related-issue drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-fix-request-related-issue
+++ a/drivers/gpio/gpiolib.c
@@ -789,6 +789,7 @@ int gpio_request(unsigned gpio, const ch
 	} else {
 		status = -EBUSY;
 		module_put(chip->owner);
+		goto done;
 	}
 
 	if (chip->request) {
_

Patches currently in -mm which might be from damm@igel.co.jp are

origin.patch
gpiolib-fix-request-related-issue.patch
linux-next.patch
early-platform-drivers-v2.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-add-enable-and-disable-callbacks.patch
irq-free-setup_irq-interrupt-using-free_irq.patch

