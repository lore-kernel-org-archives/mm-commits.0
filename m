From: akpm@linux-foundation.org
Subject: + mb862xxfb-use-config_of-instead-of-config_ppc_of.patch added to -mm tree
Date: Mon, 11 May 2009 15:57:30 -0700
Message-ID: <200905112257.n4BMvU4S027874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760527AbZEKXBD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 19:01:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, agust@denx.de, davem@davemloft.net, monstr@monstr.eu


The patch titled
     mb862xxfb: use CONFIG_OF instead of CONFIG_PPC_OF
has been added to the -mm tree.  Its filename is
     mb862xxfb-use-config_of-instead-of-config_ppc_of.patch

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
Subject: mb862xxfb: use CONFIG_OF instead of CONFIG_PPC_OF
From: Arnd Bergmann <arnd@arndb.de>

With this change, the driver builds fine on Microblaze, which helps
allyesconfig compile tests.

I did not test sparc, but the change should have the same effect there.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mb862xx/mb862xxfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/mb862xx/mb862xxfb.c~mb862xxfb-use-config_of-instead-of-config_ppc_of drivers/video/mb862xx/mb862xxfb.c
--- a/drivers/video/mb862xx/mb862xxfb.c~mb862xxfb-use-config_of-instead-of-config_ppc_of
+++ a/drivers/video/mb862xx/mb862xxfb.c
@@ -19,7 +19,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
-#if defined(CONFIG_PPC_OF)
+#if defined(CONFIG_OF)
 #include <linux/of_platform.h>
 #endif
 #include "mb862xxfb.h"
_

Patches currently in -mm which might be from arnd@arndb.de are

linux-next.patch
mb862xxfb-use-config_of-instead-of-config_ppc_of.patch

