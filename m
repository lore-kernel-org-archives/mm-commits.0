From: akpm@linux-foundation.org
Subject: - parport-remove-superfluous-local-variable.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:46 -0700
Message-ID: <200807262113.m6QLDkkg019625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757487AbYGZVNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre@bitwigglers.org, mm-commits@vger.kernel.org


The patch titled
     parport: remove superfluous local variable
has been removed from the -mm tree.  Its filename was
     parport-remove-superfluous-local-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
