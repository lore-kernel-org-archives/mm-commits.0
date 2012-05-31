From: akpm@linux-foundation.org
Subject: [merged] mm-vmstatc-remov-debug-fs-entries-on-failure-of-file-creation-and-made-extfrag_debug_root-dentry-local.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:12 -0700
Message-ID: <20120531191412.81D98A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:62868 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840Ab2EaTOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:14 -0400
Received: by were53 with SMTP id e53so75802wer.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasikanth.v19@gmail.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat.c: remove debug fs entries on failure of file creation and made extfrag_debug_root dentry local
has been removed from the -mm tree.  Its filename was
     mm-vmstatc-remov-debug-fs-entries-on-failure-of-file-creation-and-made-extfrag_debug_root-dentry-local.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sasikantha babu <sasikanth.v19@gmail.com>
Subject: mm/vmstat.c: remove debug fs entries on failure of file creation and made extfrag_debug_root dentry local

Remove debug fs files and directory on failure.  Since no one is using
"extfrag_debug_root" dentry outside of extfrag_debug_init(), make it local
to the function.

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/vmstat.c~mm-vmstatc-remov-debug-fs-entries-on-failure-of-file-creation-and-made-extfrag_debug_root-dentry-local mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstatc-remov-debug-fs-entries-on-failure-of-file-creation-and-made-extfrag_debug_root-dentry-local
+++ a/mm/vmstat.c
@@ -1223,7 +1223,6 @@ module_init(setup_vmstat)
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_COMPACTION)
 #include <linux/debugfs.h>
 
-static struct dentry *extfrag_debug_root;
 
 /*
  * Return an index indicating how much of the available free memory is
@@ -1361,19 +1360,24 @@ static const struct file_operations extf
 
 static int __init extfrag_debug_init(void)
 {
+	struct dentry *extfrag_debug_root;
+
 	extfrag_debug_root = debugfs_create_dir("extfrag", NULL);
 	if (!extfrag_debug_root)
 		return -ENOMEM;
 
 	if (!debugfs_create_file("unusable_index", 0444,
 			extfrag_debug_root, NULL, &unusable_file_ops))
-		return -ENOMEM;
+		goto fail;
 
 	if (!debugfs_create_file("extfrag_index", 0444,
 			extfrag_debug_root, NULL, &extfrag_file_ops))
-		return -ENOMEM;
+		goto fail;
 
 	return 0;
+fail:
+	debugfs_remove_recursive(extfrag_debug_root);
+	return -ENOMEM;
 }
 
 module_init(extfrag_debug_init);
_

Patches currently in -mm which might be from sasikanth.v19@gmail.com are

origin.patch
sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table.patch

