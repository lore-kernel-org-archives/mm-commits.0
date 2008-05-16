From: akpm@linux-foundation.org
Subject: - isdn-capi-return-proper-errnos-on-module-init.patch removed from -mm tree
Date: Fri, 16 May 2008 15:54:03 -0700
Message-ID: <200805162254.m4GMs3Va003203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757647AbYEPWyI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:54:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn/capi: return proper errnos on module init
has been removed from the -mm tree.  Its filename was
     isdn-capi-return-proper-errnos-on-module-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn/capi: return proper errnos on module init
From: Marcin Slusarz <marcin.slusarz@gmail.com>

cdebug_init() is called from kcapi_init() which is module initialization
function, so it must return negative values on errors.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capiutil.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/isdn/capi/capiutil.c~isdn-capi-return-proper-errnos-on-module-init drivers/isdn/capi/capiutil.c
--- a/drivers/isdn/capi/capiutil.c~isdn-capi-return-proper-errnos-on-module-init
+++ a/drivers/isdn/capi/capiutil.c
@@ -948,17 +948,17 @@ int __init cdebug_init(void)
 {
 	g_cmsg= kmalloc(sizeof(_cmsg), GFP_KERNEL);
 	if (!g_cmsg)
-		return ENOMEM;
+		return -ENOMEM;
 	g_debbuf = kmalloc(sizeof(_cdebbuf), GFP_KERNEL);
 	if (!g_debbuf) {
 		kfree(g_cmsg);
-		return ENOMEM;
+		return -ENOMEM;
 	}
 	g_debbuf->buf = kmalloc(CDEBUG_GSIZE, GFP_KERNEL);
 	if (!g_debbuf->buf) {
 		kfree(g_cmsg);
 		kfree(g_debbuf);
-		return ENOMEM;;
+		return -ENOMEM;;
 	}
 	g_debbuf->size = CDEBUG_GSIZE;
 	g_debbuf->buf[0] = 0;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
linux-next.patch
drm-radeon-radeon_enable_vblank-should-return-negative-error.patch
net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch
ntfs-le_add_cpu-conversion.patch

