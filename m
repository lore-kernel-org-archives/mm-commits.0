From: akpm@linux-foundation.org
Subject: + mm-vmstatc-remov-debug-fs-entries-on-failure-of-file-creation-and-made-extfrag_debug_root-dentry-local.patch added to -mm tree
Date: Tue, 24 Apr 2012 15:55:44 -0700
Message-ID: <20120424225544.E9689A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:53584 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab2DXWzr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Apr 2012 18:55:47 -0400
Received: by wgbdt11 with SMTP id dt11so65138wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Apr 2012 15:55:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sasikanth.v19@gmail.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     Subject: mm/vmstat.c: remov debug fs entries on failure of file creation and made extfrag_debug_root dentry local
has been added to the -mm tree.  Its filename is
     mm-vmstatc-remov-debug-fs-entries-on-failure-of-file-creation-and-made-extfrag_debug_root-dentry-local.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasikantha babu <sasikanth.v19@gmail.com>
Subject: mm/vmstat.c: remov debug fs entries on failure of file creation and made extfrag_debug_root dentry local

Removed debug fs files and directory on failure.  Since no one using
"extfrag_debug_root" dentry outside of function extfrag_debug_init made it
local to the function.

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
Subject: Subject: mm/vmstat.c: remov debug fs entries on failure of file creation and made extfrag_debug_root dentry local

Patches currently in -mm which might be from sasikanth.v19@gmail.com are

mm-vmstatc-remov-debug-fs-entries-on-failure-of-file-creation-and-made-extfrag_debug_root-dentry-local.patch
sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table.patch

