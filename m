From: akpm@linux-foundation.org
Subject: + reiser4-fix-handling-enospc-unix_file.patch added to -mm tree
Date: Tue, 06 May 2008 13:38:47 -0700
Message-ID: <200805062038.m46Kclto026123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758582AbYEFUit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:38:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com


The patch titled
     reiser4: fix handling ENOSPC unix_file
has been added to the -mm tree.  Its filename is
     reiser4-fix-handling-enospc-unix_file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: fix handling ENOSPC unix_file
From: Edward Shishkin <edward.shishkin@gmail.com>

Problem:
Processes fall into infinite loop
when running in no-space-left-on-device situation.

Fixups:
1. fixed leak of exclusive access in write_unix_file();
2. fixed leak of inode's flag REISER4_PART_IN_CONV in tail2extent();

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/file.c            |    8 ++++-
 fs/reiser4/plugin/file/tail_conversion.c |   29 ++++++++++++++-------
 2 files changed, 26 insertions(+), 11 deletions(-)

diff -puN fs/reiser4/plugin/file/file.c~reiser4-fix-handling-enospc-unix_file fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-fix-handling-enospc-unix_file
+++ a/fs/reiser4/plugin/file/file.c
@@ -2207,8 +2207,11 @@ ssize_t write_unix_file(struct file *fil
 					}
 					if (uf_info->container ==  UF_CONTAINER_TAILS) {
 						result = tail2extent(uf_info);
-						if (result)
+						if (result) {
+							drop_exclusive_access(uf_info);
+							context_set_commit_async(ctx);
 							break;
+						}
 					}
 				}
 				drop_exclusive_access(uf_info);
@@ -2250,7 +2253,7 @@ ssize_t write_unix_file(struct file *fil
 			current->backing_dev_info = NULL;
 			drop_access(uf_info);
 			context_set_commit_async(ctx);
-			return result;
+			break;
 		}
 		drop_access(uf_info);
 		ea = NEITHER_OBTAINED;
@@ -2321,6 +2324,7 @@ int release_unix_file(struct inode *inod
 		    !rofs_inode(inode)) {
 			result = extent2tail(file, uf_info);
 			if (result != 0) {
+				context_set_commit_async(ctx);
 				warning("nikita-3233",
 					"Failed (%d) to convert in %s (%llu)",
 					result, __FUNCTION__,
diff -puN fs/reiser4/plugin/file/tail_conversion.c~reiser4-fix-handling-enospc-unix_file fs/reiser4/plugin/file/tail_conversion.c
--- a/fs/reiser4/plugin/file/tail_conversion.c~reiser4-fix-handling-enospc-unix_file
+++ a/fs/reiser4/plugin/file/tail_conversion.c
@@ -133,9 +133,11 @@ static void release_all_pages(struct pag
 
 	for (i = 0; i < nr_pages; i++) {
 		if (pages[i] == NULL) {
+#if REISER4_DEBUG
 			unsigned j;
 			for (j = i + 1; j < nr_pages; j++)
 				assert("vs-1620", pages[j] == NULL);
+#endif
 			break;
 		}
 		page_cache_release(pages[i]);
@@ -348,8 +350,10 @@ int tail2extent(struct unix_file_info *u
 	while (done == 0) {
 		memset(pages, 0, sizeof(pages));
 		result = reserve_tail2extent_iteration(inode);
-		if (result != 0)
+		if (result != 0) {
+			reiser4_inode_clr_flag(inode, REISER4_PART_IN_CONV);
 			goto out;
+		}
 		if (first_iteration) {
 			reiser4_inode_set_flag(inode, REISER4_PART_MIXED);
 			reiser4_update_sd(inode);
@@ -494,11 +498,9 @@ int tail2extent(struct unix_file_info *u
 							  REISER4_PART_MIXED));
 		}
 	}
-
-	reiser4_inode_clr_flag(inode, REISER4_PART_IN_CONV);
-
 	if (result == 0) {
 		/* file is converted to extent items */
+		reiser4_inode_clr_flag(inode, REISER4_PART_IN_CONV);
 		assert("vs-1697", reiser4_inode_get_flag(inode,
 							 REISER4_PART_MIXED));
 
@@ -507,16 +509,21 @@ int tail2extent(struct unix_file_info *u
 	} else {
 		/*
 		 * conversion is not complete. Inode was already marked as
-		 * REISER4_PART_CONV and stat-data were updated at the first
+		 * REISER4_PART_MIXED and stat-data were updated at the first
 		 * iteration of the loop above.
 		 */
-	      error:
+	error:
 		release_all_pages(pages, sizeof_array(pages));
-		warning("nikita-2282", "Partial conversion of %llu: %i",
+		reiser4_inode_clr_flag(inode, REISER4_PART_IN_CONV);
+		warning("edward-1548", "Partial conversion of %llu: %i",
 			(unsigned long long)get_inode_oid(inode), result);
 	}
 
-      out:
+ out:
+	/* this flag should be cleared, otherwise get_exclusive_access_careful()
+	   will fall into infinite loop */
+	assert("edward-1549", !reiser4_inode_get_flag(inode,
+						      REISER4_PART_IN_CONV));
 	return result;
 }
 
@@ -703,7 +710,7 @@ int extent2tail(struct file * file, stru
 	}
 	/*
 	 * conversion is not complete. Inode was already marked as
-	 * REISER4_PART_MIXED and stat-data were updated at the first *
+	 * REISER4_PART_MIXED and stat-data were updated at the first
 	 * iteration of the loop above.
 	 */
 	warning("nikita-2282",
@@ -711,6 +718,10 @@ int extent2tail(struct file * file, stru
 		(unsigned long long)get_inode_oid(inode), i,
 		num_pages, result);
 
+	/* this flag should be cleared, otherwise get_exclusive_access_careful()
+	   will fall into infinite loop */
+	assert("edward-1550", !reiser4_inode_get_flag(inode,
+						      REISER4_PART_IN_CONV));
 	return result;
 }
 
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

reiser4.patch
reiser4-fix-handling-enospc-cryptcompress.patch
reiser4-fix-handling-enospc-unix_file.patch
reiser4-fix-kill_hook_internal.patch

