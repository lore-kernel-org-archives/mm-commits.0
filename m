From: akpm@linux-foundation.org
Subject: + parport-remove-superfluous-local-variable.patch added to -mm tree
Date: Wed, 25 Jun 2008 16:46:00 -0700
Message-ID: <200806252346.m5PNk0Gi000451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754028AbYFYXqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 19:46:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre@bitwigglers.org


The patch titled
     parport: remove superfluous local variable
has been added to the -mm tree.  Its filename is
     parport-remove-superfluous-local-variable.patch

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
Subject: parport: remove superfluous local variable
From: Andre Haupt <andre@bitwigglers.org>

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/ieee1284.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/parport/ieee1284.c~parport-remove-superfluous-local-variable drivers/parport/ieee1284.c
--- a/drivers/parport/ieee1284.c~parport-remove-superfluous-local-variable
+++ a/drivers/parport/ieee1284.c
@@ -199,8 +199,6 @@ int parport_wait_peripheral(struct parpo
 	/* 40ms of slow polling. */
 	deadline = jiffies + msecs_to_jiffies(40);
 	while (time_before (jiffies, deadline)) {
-		int ret;
