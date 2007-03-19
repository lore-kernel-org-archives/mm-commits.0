From: akpm@linux-foundation.org
Subject: + unionfs-sioq-not-__exit.patch added to -mm tree
Date: Mon, 19 Mar 2007 15:41:37 -0700
Message-ID: <200703192241.l2JMfbTd019634@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60033 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965055AbXCSWlw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 18:41:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     unionfs: sioq not __exit
has been added to the -mm tree.  Its filename is
     unionfs-sioq-not-__exit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unionfs: sioq not __exit
From: Randy Dunlap <randy.dunlap@oracle.com>

stop_sioq() is called from both __init and __exit functions, so it
shouldn't be marked __exit.

Reported on the kernelnewbies mailing list, but no patch offered there.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unionfs/sioq.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/unionfs/sioq.c~unionfs-sioq-not-__exit fs/unionfs/sioq.c
--- a/fs/unionfs/sioq.c~unionfs-sioq-not-__exit
+++ a/fs/unionfs/sioq.c
@@ -40,7 +40,7 @@ int __init init_sioq(void)
 	return err;
 }
 
-void __exit stop_sioq(void)
+void stop_sioq(void)
 {
 	if (superio_workqueue)
 		destroy_workqueue(superio_workqueue);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-drm.patch
git-libata-all.patch
git-netdev-all.patch
fusion-kernel-doc-warning-fixes.patch
unionfs-sioq-not-__exit.patch
i386-fix-gdts-number-of-quadwords-in.patch
scripts-kernel-doc-whitespace-cleanup.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
