From: akpm@linux-foundation.org
Subject: +
 fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix-fix.patch added to -mm tree
Date: Tue, 08 Sep 2015 11:31:17 -0700
Message-ID: <55ef2975.pCmLfL2GiATzCpf3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbbIHSbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:31:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix-fix
has been added to the -mm tree.  Its filename is
     fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix-fix

fix drivers/net/ieee802154/at86rf230.c

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ieee802154/at86rf230.c |   28 ++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff -puN drivers/net/ieee802154/at86rf230.c~fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix-fix drivers/net/ieee802154/at86rf230.c
--- a/drivers/net/ieee802154/at86rf230.c~fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix-fix
+++ a/drivers/net/ieee802154/at86rf230.c
@@ -1647,30 +1647,16 @@ static int at86rf230_stats_show(struct s
 	struct at86rf230_local *lp = file->private;
 	int ret;
 
-	ret = seq_printf(file, "SUCCESS:\t\t%8llu\n", lp->trac.success);
-	if (ret < 0)
-		return ret;
-
-	ret = seq_printf(file, "SUCCESS_DATA_PENDING:\t%8llu\n",
+	seq_printf(file, "SUCCESS:\t\t%8llu\n", lp->trac.success);
+	seq_printf(file, "SUCCESS_DATA_PENDING:\t%8llu\n",
 			 lp->trac.success_data_pending);
-	if (ret < 0)
-		return ret;
-
-	ret = seq_printf(file, "SUCCESS_WAIT_FOR_ACK:\t%8llu\n",
+	seq_printf(file, "SUCCESS_WAIT_FOR_ACK:\t%8llu\n",
 			 lp->trac.success_wait_for_ack);
-	if (ret < 0)
-		return ret;
-
-	ret = seq_printf(file, "CHANNEL_ACCESS_FAILURE:\t%8llu\n",
+	seq_printf(file, "CHANNEL_ACCESS_FAILURE:\t%8llu\n",
 			 lp->trac.channel_access_failure);
-	if (ret < 0)
-		return ret;
-
-	ret = seq_printf(file, "NO_ACK:\t\t\t%8llu\n", lp->trac.no_ack);
-	if (ret < 0)
-		return ret;
