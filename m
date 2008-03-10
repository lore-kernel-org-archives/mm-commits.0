From: akpm@linux-foundation.org
Subject: - jbd-only-create-debugfs-entries-if-cache-initialisation-is-successful.patch removed from -mm tree
Date: Mon, 10 Mar 2008 12:44:07 -0700
Message-ID: <200803101944.m2AJi7R5002224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859AbYCJToM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:44:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: duaneg@dghda.com, mm-commits@vger.kernel.org


The patch titled
     jbd: only create debugfs entries if cache initialisation is successful
has been removed from the -mm tree.  Its filename was
     jbd-only-create-debugfs-entries-if-cache-initialisation-is-successful.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: only create debugfs entries if cache initialisation is successful
From: "Duane Griffin" <duaneg@dghda.com>

JBD debugfs entries should only be created if cache initialisation is
successful.  At the moment they are being created unconditionally which will
leave them dangling if cache (and hence module) initialisation fails.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/jbd/journal.c~jbd-only-create-debugfs-entries-if-cache-initialisation-is-successful fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-only-create-debugfs-entries-if-cache-initialisation-is-successful
+++ a/fs/jbd/journal.c
@@ -1942,9 +1942,10 @@ static int __init journal_init(void)
 	BUILD_BUG_ON(sizeof(struct journal_superblock_s) != 1024);
 
 	ret = journal_init_caches();
-	if (ret != 0)
+	if (ret == 0)
+		jbd_create_debugfs_entry();
+	else
 		journal_destroy_caches();
-	jbd_create_debugfs_entry();
 	return ret;
 }
 
_

Patches currently in -mm which might be from duaneg@dghda.com are

jbd-only-create-debugfs-entries-if-cache-initialisation-is-successful.patch
jbd2-only-create-debugfs-and-stats-entries-if-cache-initialisation-is-successful.patch

