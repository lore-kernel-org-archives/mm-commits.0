From: akpm@linux-foundation.org
Subject: - make-gpiochip-label-const.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:15:48 -0700
Message-ID: <200810182315.m9INFmoM028689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbYJRXPz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:15:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbaryshkov@gmail.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpio: make gpiochip label const
has been removed from the -mm tree.  Its filename was
     make-gpiochip-label-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: make gpiochip label const
From: Dmitry Baryshkov <dbaryshkov@gmail.com>

Mark gpiochip label as a const char pointer.  Fixes things like

arch/arm/common/scoop.c: In function `scoop_probe':
arch/arm/common/scoop.c:250: warning: assignment discards qualifiers from pointer target type

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/gpio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/gpio.h~make-gpiochip-label-const include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~make-gpiochip-label-const
+++ a/include/asm-generic/gpio.h
@@ -61,7 +61,7 @@ struct module;
  * is calculated by subtracting @base from the gpio number.
  */
 struct gpio_chip {
-	char			*label;
+	const char		*label;
 	struct device		*dev;
 	struct module		*owner;
 
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

origin.patch
add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs.patch

