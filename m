From: akpm@linux-foundation.org
Subject: [merged] w1-fix-for-loop-in-w1_f29_remove_slave.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:06:18 -0700
Message-ID: <201108261903.p7QJ320D005648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626Ab1HZTDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, dagenaisj@sonatest.com, prtvar.b@gmail.com, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     w1: fix for loop in w1_f29_remove_slave()
has been removed from the -mm tree.  Its filename was
     w1-fix-for-loop-in-w1_f29_remove_slave.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: fix for loop in w1_f29_remove_slave()
From: Dan Carpenter <error27@gmail.com>

The for loop was looking for i <= 0 instead of i >= 0 so this function
never did anything.  Also we started with i = NB_SYSFS_BIN_FILES instead
of "NB_SYSFS_BIN_FILES - 1" which is an off by one bug.

Reported-by: Bojan Prtvar <prtvar.b@gmail.com>
Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Jean-Franois Dagenais <dagenaisj@sonatest.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_ds2408.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/w1/slaves/w1_ds2408.c~w1-fix-for-loop-in-w1_f29_remove_slave drivers/w1/slaves/w1_ds2408.c
--- a/drivers/w1/slaves/w1_ds2408.c~w1-fix-for-loop-in-w1_f29_remove_slave
+++ a/drivers/w1/slaves/w1_ds2408.c
@@ -373,7 +373,7 @@ static int w1_f29_add_slave(struct w1_sl
 static void w1_f29_remove_slave(struct w1_slave *sl)
 {
 	int i;
-	for (i = NB_SYSFS_BIN_FILES; i <= 0; --i)
+	for (i = NB_SYSFS_BIN_FILES - 1; i >= 0; --i)
 		sysfs_remove_bin_file(&sl->dev.kobj,
 			&(w1_f29_sysfs_bin_files[i]));
 }
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch

