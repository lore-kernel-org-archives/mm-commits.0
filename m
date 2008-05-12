From: akpm@linux-foundation.org
Subject: + isdn-capi-return-proper-errnos-on-module-init.patch added to -mm tree
Date: Mon, 12 May 2008 16:40:03 -0700
Message-ID: <200805122340.m4CNe3wL014984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754488AbYELXki (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:40:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, kkeil@suse.de


The patch titled
     isdn/capi: return proper errnos on module init
has been added to the -mm tree.  Its filename is
     isdn-capi-return-proper-errnos-on-module-init.patch

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
Subject: isdn/capi: return proper errnos on module init
From: Marcin Slusarz <marcin.slusarz@gmail.com>

cdebug_init() is called from kcapi_init() which is module initialization
function, so it must return negative values on errors.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
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

ntfs-le_add_cpu-conversion.patch
drm-radeon-radeon_enable_vblank-should-return-negative-error.patch
cifs-cifssmbposixlock-should-return-einval-on-error.patch
dlm-tcp_connect_to_sock-should-check-for-einval-not-einval.patch
isdn-capi-return-proper-errnos-on-module-init.patch
net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch
s390-char-vmlogrdr-module-initialization-function-should-return-negative-errors.patch

