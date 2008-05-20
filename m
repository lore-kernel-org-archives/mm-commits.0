From: akpm@linux-foundation.org
Subject: + sfc-do-not-define-inline-macro.patch added to -mm tree
Date: Mon, 19 May 2008 20:27:42 -0700
Message-ID: <200805200327.m4K3RgQl002711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757337AbYETD1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 23:27:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhutchings@solarflare.com, jeff@garzik.org


The patch titled
     sfc: do not define inline macro
has been added to the -mm tree.  Its filename is
     sfc-do-not-define-inline-macro.patch

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
Subject: sfc: do not define inline macro
From: Ben Hutchings <bhutchings@solarflare.com>

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/net_driver.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/net/sfc/net_driver.h~sfc-do-not-define-inline-macro drivers/net/sfc/net_driver.h
--- a/drivers/net/sfc/net_driver.h~sfc-do-not-define-inline-macro
+++ a/drivers/net/sfc/net_driver.h
@@ -81,11 +81,6 @@ do {if (net_ratelimit()) EFX_INFO(efx, f
 #define EFX_LOG_RL(efx, fmt, args...) \
 do {if (net_ratelimit()) EFX_LOG(efx, fmt, ##args); } while (0)
 
-/* Kernel headers may redefine inline anyway */
-#ifndef inline
-#define inline inline __attribute__ ((always_inline))
-#endif
