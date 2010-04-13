From: akpm@linux-foundation.org
Subject: + mmc-sd-clean-up-redundant-memset.patch added to -mm tree
Date: Tue, 13 Apr 2010 12:50:59 -0700
Message-ID: <201004131950.o3DJoxUP024066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752752Ab0DMTvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Apr 2010 15:51:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: asselsm@gmail.com, linux-mmc@vger.kernel.org


The patch titled
     mmc: sd: clean up redundant memset
has been added to the -mm tree.  Its filename is
     mmc-sd-clean-up-redundant-memset.patch

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
Subject: mmc: sd: clean up redundant memset
From: Mark Asselstine <asselsm@gmail.com>

The clearing of mrq via a memset at the top of the for loop in
mmc_wait_for_app_cmd() is not required as mrq is not used and there is
another clearing of mrq just below.  We remove the first memset since if
the initial tests in the for loop fail the memset is not required.

Signed-off-by: Mark Asselstine <asselsm@gmail.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sd_ops.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/mmc/core/sd_ops.c~mmc-sd-clean-up-redundant-memset drivers/mmc/core/sd_ops.c
--- a/drivers/mmc/core/sd_ops.c~mmc-sd-clean-up-redundant-memset
+++ a/drivers/mmc/core/sd_ops.c
@@ -79,8 +79,6 @@ int mmc_wait_for_app_cmd(struct mmc_host
 	 * we cannot use the retries field in mmc_command.
 	 */
 	for (i = 0;i <= retries;i++) {
-		memset(&mrq, 0, sizeof(struct mmc_request));
