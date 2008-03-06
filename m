From: akpm@linux-foundation.org
Subject: + jbd-only-create-debugfs-entries-if-cache-initialisation-is-successful.patch added to -mm tree
Date: Wed, 05 Mar 2008 20:31:55 -0800
Message-ID: <200803060431.m264Vtsf008689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755723AbYCFEb7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 23:31:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: duaneg@dghda.com


The patch titled
     jbd: only create debugfs entries if cache initialisation is successful
has been added to the -mm tree.  Its filename is
     jbd-only-create-debugfs-entries-if-cache-initialisation-is-successful.patch

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

jbd-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
jbd-replace-potentially-false-assertion-with-if-block.patch
jbd-only-create-debugfs-entries-if-cache-initialisation-is-successful.patch

