From: akpm@linux-foundation.org
Subject: + of-make-of_unregister_platform_driver-common-code.patch added to -mm tree
Date: Tue, 28 Apr 2009 11:01:15 -0700
Message-ID: <200904281801.n3SI1Fpd009032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758487AbZD1SFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 14:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grant.likely@secretlab.ca, benh@kernel.crashing.org, davem@davemloft.net, monstr@monstr.eu, rpurdie@rpsys.net, sfr@canb.auug.org.au


The patch titled
     of: make of_(un)register_platform_driver common code.
has been added to the -mm tree.  Its filename is
     of-make-of_unregister_platform_driver-common-code.patch

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
Subject: of: make of_(un)register_platform_driver common code.
From: Grant Likely <grant.likely@secretlab.ca>

Some drivers using of_register_platform_driver() wrapper break on sparc
because the wrapper isn't in the header file.  This patch moves it from
Microblaze and PowerPC implementations and makes it common code.

Fixes this sparc64 allmodconfig build error (at least):

drivers/leds/leds-gpio.c: In function `gpio_led_init':
drivers/leds/leds-gpio.c:295: error: implicit declaration of function `of_register_platform_driver'
drivers/leds/leds-gpio.c: In function `gpio_led_exit':
drivers/leds/leds-gpio.c:311: error: implicit declaration of function `of_unregister_platform_driver'

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/of_platform.h |   10 ----------
 arch/powerpc/include/asm/of_platform.h    |   10 ----------
 include/linux/of_platform.h               |   10 ++++++++++
 3 files changed, 10 insertions(+), 20 deletions(-)

diff -puN arch/microblaze/include/asm/of_platform.h~of-make-of_unregister_platform_driver-common-code arch/microblaze/include/asm/of_platform.h
--- a/arch/microblaze/include/asm/of_platform.h~of-make-of_unregister_platform_driver-common-code
+++ a/arch/microblaze/include/asm/of_platform.h
@@ -36,16 +36,6 @@ static const struct of_device_id of_defa
 	{},
 };
 
-/* Platform drivers register/unregister */
-static inline int of_register_platform_driver(struct of_platform_driver *drv)
-{
-	return of_register_driver(drv, &of_platform_bus_type);
-}
-static inline void of_unregister_platform_driver(struct of_platform_driver *drv)
-{
-	of_unregister_driver(drv);
-}
-
 /* Platform devices and busses creation */
 extern struct of_device *of_platform_device_create(struct device_node *np,
 						const char *bus_id,
diff -puN arch/powerpc/include/asm/of_platform.h~of-make-of_unregister_platform_driver-common-code arch/powerpc/include/asm/of_platform.h
--- a/arch/powerpc/include/asm/of_platform.h~of-make-of_unregister_platform_driver-common-code
+++ a/arch/powerpc/include/asm/of_platform.h
@@ -11,16 +11,6 @@
  *
  */
 
-/* Platform drivers register/unregister */
-static inline int of_register_platform_driver(struct of_platform_driver *drv)
-{
-	return of_register_driver(drv, &of_platform_bus_type);
-}
-static inline void of_unregister_platform_driver(struct of_platform_driver *drv)
-{
-	of_unregister_driver(drv);
-}
-
 /* Platform devices and busses creation */
 extern struct of_device *of_platform_device_create(struct device_node *np,
 						   const char *bus_id,
diff -puN include/linux/of_platform.h~of-make-of_unregister_platform_driver-common-code include/linux/of_platform.h
--- a/include/linux/of_platform.h~of-make-of_unregister_platform_driver-common-code
+++ a/include/linux/of_platform.h
@@ -51,6 +51,16 @@ extern int of_register_driver(struct of_
 			      struct bus_type *bus);
 extern void of_unregister_driver(struct of_platform_driver *drv);
 
+/* Platform drivers register/unregister */
+static inline int of_register_platform_driver(struct of_platform_driver *drv)
+{
+	return of_register_driver(drv, &of_platform_bus_type);
+}
+static inline void of_unregister_platform_driver(struct of_platform_driver *drv)
+{
+	of_unregister_driver(drv);
+}
+
 #include <asm/of_platform.h>
 
 extern struct of_device *of_find_device_by_node(struct device_node *np);
_

Patches currently in -mm which might be from grant.likely@secretlab.ca are

origin.patch
linux-next.patch
of-make-of_unregister_platform_driver-common-code.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch

