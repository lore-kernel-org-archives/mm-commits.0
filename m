From: akpm@linux-foundation.org
Subject: - sfc-do-not-define-inline-macro.patch removed from -mm tree
Date: Fri, 23 May 2008 11:59:21 -0700
Message-ID: <200805231859.m4NIxLFt004229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327AbYEWS70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:59:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhutchings@solarflare.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sfc: do not define inline macro
has been removed from the -mm tree.  Its filename was
     sfc-do-not-define-inline-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
