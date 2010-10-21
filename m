From: akpm@linux-foundation.org
Subject: + drivers-char-synclink_gtc-fix-information-leak-to-userland.patch added to -mm tree
Date: Thu, 21 Oct 2010 14:12:15 -0700
Message-ID: <201010212112.o9LLCFnU003955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757954Ab0JUVM4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 17:12:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, paulkf@microgate.com


The patch titled
     drivers/char/synclink_gt.c: fix information leak to userland
has been added to the -mm tree.  Its filename is
     drivers-char-synclink_gtc-fix-information-leak-to-userland.patch

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
Subject: drivers/char/synclink_gt.c: fix information leak to userland
From: Vasiliy Kulikov <segooon@gmail.com>

Structures tmp_params and new_line are copied to userland with some
padding fields unitialized.  It leads to leaking of stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Acked-by: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/char/synclink_gt.c~drivers-char-synclink_gtc-fix-information-leak-to-userland drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~drivers-char-synclink_gtc-fix-information-leak-to-userland
+++ a/drivers/char/synclink_gt.c
@@ -1132,6 +1132,7 @@ static long get_params32(struct slgt_inf
 	struct MGSL_PARAMS32 tmp_params;
 
 	DBGINFO(("%s get_params32\n", info->device_name));
+	memset(&tmp_params, 0, sizeof(tmp_params));
 	tmp_params.mode            = (compat_ulong_t)info->params.mode;
 	tmp_params.loopback        = info->params.loopback;
 	tmp_params.flags           = info->params.flags;
@@ -1617,6 +1618,8 @@ static int hdlcdev_ioctl(struct net_devi
 	if (cmd != SIOCWANDEV)
 		return hdlc_ioctl(dev, ifr, cmd);
 
+	memset(&new_line, 0, sizeof(new_line));
+
 	switch(ifr->ifr_settings.type) {
 	case IF_GET_IFACE: /* return current sync_serial_settings */
 
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
mm-mempolicy-check-return-code-of-check_range.patch
drivers-rtc-classc-fix-device_register-error-handling.patch
drivers-char-applicomc-fix-information-leak-to-userland.patch
drivers-char-hpetc-fix-information-leak-to-userland.patch
drivers-char-hpetc-fix-information-leak-to-userland-fix.patch
drivers-char-ppdevc-fix-information-leak-to-userland.patch
drivers-char-synclink_gtc-fix-information-leak-to-userland.patch
memstick-core-fix-device_register-error-handling.patch

