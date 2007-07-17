From: akpm@linux-foundation.org
Subject: - unregister_blkdev-do-warn_on-on-failure.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:07 -0700
Message-ID: <200707172302.l6HN27ix011536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57438 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932300AbXGQXP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     unregister_blkdev(): do WARN_ON on failure
has been removed from the -mm tree.  Its filename was
     unregister_blkdev-do-warn_on-on-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: unregister_blkdev(): do WARN_ON on failure
From: Akinobu Mita <akinobu.mita@gmail.com>

When unregister_blkdev() has failed, something wrong happened.  This patch
adds WARN_ON to notify of such badness.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN block/genhd.c~unregister_blkdev-do-warn_on-on-failure block/genhd.c
--- a/block/genhd.c~unregister_blkdev-do-warn_on-on-failure
+++ a/block/genhd.c
@@ -120,9 +120,10 @@ int unregister_blkdev(unsigned int major
 	for (n = &major_names[index]; *n; n = &(*n)->next)
 		if ((*n)->major == major)
 			break;
-	if (!*n || strcmp((*n)->name, name))
+	if (!*n || strcmp((*n)->name, name)) {
+		WARN_ON(1);
 		ret = -EINVAL;
-	else {
+	} else {
 		p = *n;
 		*n = p->next;
 	}
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-dvb.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
unregister_chrdev-ignore-the-return-value.patch
unregister_chrdev-return-void.patch
