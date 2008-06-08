From: akpm@linux-foundation.org
Subject: + dm-crypt-add-cond_resched-to-crypt_convert.patch added to -mm tree
Date: Sun, 08 Jun 2008 13:30:21 -0700
Message-ID: <200806082030.m58KULPG019175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137AbYFHUbT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 16:31:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mbroz@redhat.com, agk@redhat.com, elliot.li.tech@gmail.com, stable@kernel.org


The patch titled
     dm-crypt: add cond_resched() to crypt_convert()
has been added to the -mm tree.  Its filename is
     dm-crypt-add-cond_resched-to-crypt_convert.patch

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
Subject: dm-crypt: add cond_resched() to crypt_convert()
From: Milan Broz <mbroz@redhat.com>

Add cond_resched() to prevent monopolising CPU when processing large bios.

dm-crypt processes encryption of bios in sector units.  If the bio request
is big it can spend a long time in the encryption call.

(akpm: needed in 2.6.26 and, given that it fixes soft-lockup warnings,
needed in -stable too)

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Tested-by: Yan Li <elliot.li.tech@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/md/dm-crypt.c~dm-crypt-add-cond_resched-to-crypt_convert drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-crypt-add-cond_resched-to-crypt_convert
+++ a/drivers/md/dm-crypt.c
@@ -432,6 +432,7 @@ static int crypt_convert(struct crypt_co
 		case 0:
 			atomic_dec(&ctx->pending);
 			ctx->sector++;
+			cond_resched();
 			continue;
 
 		/* error */
_

Patches currently in -mm which might be from mbroz@redhat.com are

dm-crypt-add-cond_resched-to-crypt_convert.patch

