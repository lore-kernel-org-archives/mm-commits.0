From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lp5521c-fix-potential-buffer-overflow.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:03:14 -0800
Message-ID: <201101132005.p0DK5tZ0029676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782Ab1AMUG7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:06:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-lp5521.c: fix potential buffer overflow
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lp5521c-fix-potential-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-lp5521.c: fix potential buffer overflow
From: Vasiliy Kulikov <segoon@openwall.com>

The code doesn't check first sscanf() return value.  If first sscanf()
failed then c contains some garbage.  It might lead to reading
uninitialised stack data in the second sscanf() call.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-fix-potential-buffer-overflow drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-fix-potential-buffer-overflow
+++ a/drivers/leds/leds-lp5521.c
@@ -373,6 +373,8 @@ static int lp5521_do_store_load(struct l
 	while ((offset < len - 1) && (i < LP5521_PROGRAM_LENGTH)) {
 		/* separate sscanfs because length is working only for %s */
 		ret = sscanf(buf + offset, "%2s%n ", c, &nrchars);
+		if (ret != 2)
+			goto fail;
 		ret = sscanf(c, "%2x", &cmd);
 		if (ret != 1)
 			goto fail;
_

Patches currently in -mm which might be from segoon@openwall.com are

origin.patch
linux-next.patch

