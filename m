From: akpm@linux-foundation.org
Subject: + coda-update-module-information.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:29:48 -0700
Message-ID: <200707130529.l6D5TmTR030832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53859 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbXGMFf0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:35:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaharkes@cs.cmu.edu


The patch titled
     coda: update module information
has been added to the -mm tree.  Its filename is
     coda-update-module-information.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error.patch
coda-correctly-invalidate-cached-access-rights.patch
coda-fix-nlink-updates-for-directories.patch
coda-allow-removal-of-busy-directories.patch
coda-coda-doesnt-track-atime.patch
coda-use-ilookup5.patch
coda-cleanup-dev-cfs-open-and-close-handling.patch
coda-cleanup-for-upcall-handling-path.patch
coda-block-signals-during-upcall-processing.patch
coda-avoid-lockdep-warning-in-coda_readdir.patch
coda-replace-upc_alloc-upc_free-with-kmalloc-kfree.patch
coda-ignore-returned-values-when-upcalls-return-errors.patch
coda-cleanup-coda_lookup-use-dsplice_alias.patch
coda-cleanup-downcall-handler.patch
coda-remove-struct-coda_sb_info.patch
coda-remove-statistics-counters-from-proc-fs-coda.patch
coda-update-module-information.patch
