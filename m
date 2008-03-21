From: akpm@linux-foundation.org
Subject: + sh_keysc-fixdouble-free.patch added to -mm tree
Date: Fri, 21 Mar 2008 15:46:11 -0700
Message-ID: <200803212246.m2LMkBFq014332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762716AbYCUWqU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 18:46:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, damm@igel.co.jp, dtor@mail.ru, lethal@linux-sh.org


The patch titled
     sh_keys.c: fixdouble free
has been added to the -mm tree.  Its filename is
     sh_keysc-fixdouble-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

smc91x-pass-along-private-data-v2.patch
smc91x-introduce-platform-data-flags-v2.patch
smc91x-add-insw-outsw-to-default-config-v2.patch
smc91x-make-superh-use-default-config-v2.patch
git-sh.patch
sh_keysc-fixdouble-free.patch
sm501-add-uart-support.patch

