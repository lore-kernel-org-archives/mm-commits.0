From: akpm@linux-foundation.org
Subject: + unregister_blkdev-do-warn_on-on-failure.patch added to -mm tree
Date: Tue, 03 Jul 2007 12:55:56 -0700
Message-ID: <200707031955.l63JtvKT012149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757663AbXGCT4L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 15:56:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, jens.axboe@oracle.com


The patch titled
     unregister_blkdev(): do WARN_ON on failure
has been added to the -mm tree.  Its filename is
     unregister_blkdev-do-warn_on-on-failure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 3 insertions(+), 2 deletions(-)

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

git-dvb.patch
git-netdev-all.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-add-min-order-parameter-to-fail_page_alloc.patch
fault-injection-fix-example-scripts-in-documentation.patch
unregister_chrdev-ignore-the-return-value.patch
unregister_chrdev-return-void.patch
unregister_blkdev-do-warn_on-on-failure.patch
unregister_blkdev-delete-redundant-messages-in-callers.patch
unregister_blkdev-delete-redundant-message.patch
unregister_blkdev-return-void.patch
