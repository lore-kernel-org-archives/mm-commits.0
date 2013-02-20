From: akpm@linux-foundation.org
Subject: + configfs-move-the-dereference-below-the-null-test.patch added to -mm tree
Date: Wed, 20 Feb 2013 15:57:34 -0800
Message-ID: <20130220235734.C8B1C31C194@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:48235 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3BTX5g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 18:57:36 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so861842vbb.4
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 15:57:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, jlbec@evilplan.org


The patch titled
     Subject: configfs: move the dereference below the NULL test
has been added to the -mm tree.  Its filename is
     configfs-move-the-dereference-below-the-null-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: configfs: move the dereference below the NULL test

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/dir.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/configfs/dir.c~configfs-move-the-dereference-below-the-null-test fs/configfs/dir.c
--- a/fs/configfs/dir.c~configfs-move-the-dereference-below-the-null-test
+++ a/fs/configfs/dir.c
@@ -1037,10 +1037,11 @@ static int configfs_dump(struct configfs
 static int configfs_depend_prep(struct dentry *origin,
 				struct config_item *target)
 {
-	struct configfs_dirent *child_sd, *sd = origin->d_fsdata;
+	struct configfs_dirent *child_sd, *sd;
 	int ret = 0;
 
-	BUG_ON(!origin || !sd);
+	BUG_ON(!origin || !origin->d_fsdata);
+	sd = origin->d_fsdata;
 
 	if (sd->s_element == target)  /* Boo-yah */
 		goto out;
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

linux-next.patch
mn10300-use-for_each_pci_dev-to-simplify-the-code.patch
configfs-move-the-dereference-below-the-null-test.patch

