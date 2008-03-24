From: akpm@linux-foundation.org
Subject: - sh_keysc-fixdouble-free.patch removed from -mm tree
Date: Mon, 24 Mar 2008 12:24:55 -0700
Message-ID: <200803241924.m2OJOtaJ021457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759159AbYCXTZG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 15:25:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, damm@igel.co.jp, dtor@mail.ru, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     sh_keys.c: fixdouble free
has been removed from the -mm tree.  Its filename was
     sh_keysc-fixdouble-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sh_keys.c: fixdouble free
From: Magnus Damm <magnus.damm@gmail.com>

Avoid double free situation from happening by removing input_free_device()
after input_unregister_device().  Suggested by Dmitry Torokhov.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/sh_keysc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/input/keyboard/sh_keysc.c~sh_keysc-fixdouble-free drivers/input/keyboard/sh_keysc.c
--- a/drivers/input/keyboard/sh_keysc.c~sh_keysc-fixdouble-free
+++ a/drivers/input/keyboard/sh_keysc.c
@@ -238,7 +238,6 @@ static int __devexit sh_keysc_remove(str
 
 	input_unregister_device(priv->input);
 	free_irq(platform_get_irq(pdev, 0), pdev);
-	input_free_device(priv->input);
 	iounmap(priv->iomem_base);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

input-touchscreen-driver-for-the-superh-migor-board.patch
smc91x-pass-along-private-data-v2.patch
smc91x-introduce-platform-data-flags-v2.patch
smc91x-add-insw-outsw-to-default-config-v2.patch
smc91x-make-superh-use-default-config-v2.patch
git-sh.patch
sm501-add-uart-support.patch

