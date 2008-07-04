From: akpm@linux-foundation.org
Subject: - dm-crypt-add-cond_resched-to-crypt_convert.patch removed from -mm tree
Date: Fri, 04 Jul 2008 00:27:05 -0700
Message-ID: <200807040727.m647R59D019332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755548AbYGDH2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 03:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mbroz@redhat.com, agk@redhat.com, elliot.li.tech@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     dm-crypt: add cond_resched() to crypt_convert()
has been removed from the -mm tree.  Its filename was
     dm-crypt-add-cond_resched-to-crypt_convert.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

