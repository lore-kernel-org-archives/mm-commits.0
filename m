From: akpm@linux-foundation.org
Subject: + dev-zero-avoid-repeated-access_ok-checks.patch added to -mm tree
Date: Tue, 21 Jul 2009 14:53:01 -0700
Message-ID: <200907212153.n6LLr1L0020647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517AbZGUVxY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 17:53:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@suse.de


The patch titled
     /dev/zero: avoid repeated access_ok() checks
has been added to the -mm tree.  Its filename is
     dev-zero-avoid-repeated-access_ok-checks.patch

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
Subject: /dev/zero: avoid repeated access_ok() checks
From: Nikanth Karthikesan <knikanth@suse.de>

In read_zero, we check for access_ok() once for the count bytes.  It is
unnecessarily checked again in clear_user.  Use __clear_user, which does
not check for access_ok().

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mem.c~dev-zero-avoid-repeated-access_ok-checks drivers/char/mem.c
--- a/drivers/char/mem.c~dev-zero-avoid-repeated-access_ok-checks
+++ a/drivers/char/mem.c
@@ -690,7 +690,7 @@ static ssize_t read_zero(struct file * f
 
 		if (chunk > PAGE_SIZE)
 			chunk = PAGE_SIZE;	/* Just for latency reasons */
-		unwritten = clear_user(buf, chunk);
+		unwritten = __clear_user(buf, chunk);
 		written += chunk - unwritten;
 		if (unwritten)
 			break;
_

Patches currently in -mm which might be from knikanth@suse.de are

dev-zero-avoid-repeated-access_ok-checks.patch

