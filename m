From: akpm@linux-foundation.org
Subject: - coda-update-module-information.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:30 -0700
Message-ID: <200707192003.l6JK3UjI019869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40556 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760960AbXGSUQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     coda: update module information
has been removed from the -mm tree.  Its filename was
     coda-update-module-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: coda: update module information
From: Jan Harkes <jaharkes@cs.cmu.edu>

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/psdev.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN fs/coda/psdev.c~coda-update-module-information fs/coda/psdev.c
--- a/fs/coda/psdev.c~coda-update-module-information
+++ a/fs/coda/psdev.c
@@ -373,21 +373,20 @@ out:
 	return err;
 }
 
-
-MODULE_AUTHOR("Peter J. Braam <braam@cs.cmu.edu>");
+MODULE_AUTHOR("Jan Harkes, Peter J. Braam");
+MODULE_DESCRIPTION("Coda Distributed File System VFS interface");
+MODULE_ALIAS_CHARDEV_MAJOR(CODA_PSDEV_MAJOR);
 MODULE_LICENSE("GPL");
+#ifdef CONFIG_CODA_FS_OLD_API
+MODULE_VERSION("5.3.21");
+#else
+MODULE_VERSION("6.6");
+#endif
 
 static int __init init_coda(void)
 {
 	int status;
 	int i;
-	printk(KERN_INFO "Coda Kernel/Venus communications, "
-#ifdef CONFIG_CODA_FS_OLD_API
-	       "v5.3.20"
-#else
-	       "v6.0.0"
-#endif
-	       ", coda@cs.cmu.edu\n");
 
 	status = coda_init_inodecache();
 	if (status)
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

origin.patch
