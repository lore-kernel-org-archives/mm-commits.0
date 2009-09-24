From: akpm@linux-foundation.org
Subject: [merged] dev-zero-avoid-repeated-access_ok-checks.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:36:08 -0700
Message-ID: <200909241936.n8OJa880001862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999AbZIXTg2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:36:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: knikanth@suse.de, mm-commits@vger.kernel.org


The patch titled
     /dev/zero: avoid repeated access_ok() checks
has been removed from the -mm tree.  Its filename was
     dev-zero-avoid-repeated-access_ok-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

