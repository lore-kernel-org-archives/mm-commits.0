From: akpm@linux-foundation.org
Subject: [merged] gpiolib-fix-request-related-issue.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:13:48 -0800
Message-ID: <200901301913.n0UJDmfc026571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512AbZA3TRg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:17:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@igel.co.jp, dbrownell@users.sourceforge.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     gpiolib: fix request related issue
has been removed from the -mm tree.  Its filename was
     gpiolib-fix-request-related-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
early-platform-driver-v3.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-add-enable-and-disable-callbacks.patch
irq-free-setup_irq-interrupt-using-free_irq.patch

