From: akpm@linux-foundation.org
Subject: + ansi_cprng-zero-out-key-data-on-exit.patch added to -mm tree
Date: Tue, 18 Nov 2008 15:04:45 -0800
Message-ID: <200811182304.mAIN4jOX012171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035AbYKRXF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 18:05:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com


The patch titled
     ansi_cprng: zero out key data on exit
has been added to the -mm tree.  Its filename is
     ansi_cprng-zero-out-key-data-on-exit.patch

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
Subject: ansi_cprng: zero out key data on exit
From: Neil Horman <nhorman@tuxdriver.com>

Its been mentioned to me a few times that the ansi_cprng doesn't zero out
its data when a context is freed.  Given that we store key, and other seed
data in that structure, I think its probably a good idea that we zero it
out.  This patch does that.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/ansi_cprng.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN crypto/ansi_cprng.c~ansi_cprng-zero-out-key-data-on-exit crypto/ansi_cprng.c
--- a/crypto/ansi_cprng.c~ansi_cprng-zero-out-key-data-on-exit
+++ a/crypto/ansi_cprng.c
@@ -271,6 +271,7 @@ done:
 static void free_prng_context(struct prng_context *ctx)
 {
 	crypto_free_cipher(ctx->tfm);
+	memset(ctx, 0, sizeof(struct prng_context));
 }
 
 static int reset_prng_context(struct prng_context *ctx,
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

linux-next.patch
ansi_cprng-zero-out-key-data-on-exit.patch

