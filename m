From: akpm@linux-foundation.org
Subject: + romfs-printk-format-warnings.patch added to -mm tree
Date: Mon, 19 Mar 2007 15:43:33 -0700
Message-ID: <200703192243.l2JMhXZn019678@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60107 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965150AbXCSWno (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 18:43:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     ROMFS: printk format warnings
has been added to the -mm tree.  Its filename is
     romfs-printk-format-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ROMFS: printk format warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Field width and precision must be of type int.
fs/romfs/super.c:513: warning: field width should have type 'int', but argument 2 has type 'size_t'
fs/romfs/super.c:513: warning: field precision should have type 'int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/super.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/romfs/super.c~romfs-printk-format-warnings fs/romfs/super.c
--- a/fs/romfs/super.c~romfs-printk-format-warnings
+++ a/fs/romfs/super.c
@@ -510,7 +510,7 @@ static int romfs_fill_super(struct super
 	len = strnlen(rsb->name, ROMFS_MAXFN);
 	if (!silent)
 		printk("ROMFS: Mounting image '%*.*s' through %s\n",
-		       len, len, rsb->name, storage);
+		       (int)len, (int)len, rsb->name, storage);
 
 	kfree(rsb);
 	rsb = NULL;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

romfs-printk-format-warnings.patch
git-drm.patch
git-libata-all.patch
git-netdev-all.patch
fusion-kernel-doc-warning-fixes.patch
unionfs-sioq-not-__exit.patch
i386-fix-gdts-number-of-quadwords-in.patch
scripts-kernel-doc-whitespace-cleanup.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
