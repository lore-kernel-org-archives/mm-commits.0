From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lp5521c-fix-potential-buffer-overflow.patch added to -mm tree
Date: Mon, 22 Nov 2010 14:55:19 -0800
Message-ID: <201011222255.oAMMtJOX013906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932304Ab0KVW4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 17:56:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segoon@openwall.com, rpurdie@rpsys.net


The patch titled
     drivers/leds/leds-lp5521.c: fix potential buffer overflow
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lp5521c-fix-potential-buffer-overflow.patch

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

linux-next.patch
drivers-leds-leds-lp5521c-fix-potential-buffer-overflow.patch

