From: akpm@linux-foundation.org
Subject: [merged] scsi-fusion-fix-string-overflow-warning.patch
 removed from -mm tree
Date: Tue, 25 Jul 2017 10:40:30 -0700
Message-ID: <20170725174030.ukzwIOTjj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50528 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbdGYRkb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2017 13:40:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: fusion: fix string overflow warning
has been removed from the -mm tree.  Its filename was
     scsi-fusion-fix-string-overflow-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: scsi: fusion: fix string overflow warning

gcc points out a theorerical string overflow:

drivers/message/fusion/mptbase.c: In function 'mpt_detach':
drivers/message/fusion/mptbase.c:2103:17: error: '%s' directive writing up to 31 bytes into a region of size 28 [-Werror=format-overflow=]
sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s/summary", ioc->name);
               ^~~~~
drivers/message/fusion/mptbase.c:2103:2: note: 'sprintf' output between 13 and 44 bytes into a destination of size 32

We can simply double the size of the local buffer here to be on the
safe side.

Link: http://lkml.kernel.org/r/20170714120720.906842-5-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/message/fusion/mptbase.c~scsi-fusion-fix-string-overflow-warning drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~scsi-fusion-fix-string-overflow-warning
+++ a/drivers/message/fusion/mptbase.c
@@ -2079,7 +2079,7 @@ void
 mpt_detach(struct pci_dev *pdev)
 {
 	MPT_ADAPTER 	*ioc = pci_get_drvdata(pdev);
-	char pname[32];
+	char pname[64];
 	u8 cb_idx;
 	unsigned long flags;
 	struct workqueue_struct *wq;
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-avoid-wmaybe-uninitialized-warning.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

