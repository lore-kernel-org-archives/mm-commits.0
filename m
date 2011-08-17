From: akpm@linux-foundation.org
Subject: + w1-fix-for-loop-in-w1_f29_remove_slave.patch added to -mm tree
Date: Wed, 17 Aug 2011 11:59:13 -0700
Message-ID: <201108171859.p7HIxDOs021603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919Ab1HQS7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 14:59:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, dagenaisj@sonatest.com, prtvar.b@gmail.com, zbr@ioremap.net


The patch titled
     w1: fix for loop in w1_f29_remove_slave()
has been added to the -mm tree.  Its filename is
     w1-fix-for-loop-in-w1_f29_remove_slave.patch

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

w1-fix-for-loop-in-w1_f29_remove_slave.patch
linux-next.patch

