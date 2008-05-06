From: akpm@linux-foundation.org
Subject: + reiser4-fix-handling-enospc-cryptcompress.patch added to -mm tree
Date: Tue, 06 May 2008 13:38:45 -0700
Message-ID: <200805062038.m46KcjgQ026120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757049AbYEFUis (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:38:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com


The patch titled
     reiser4: fix handling ENOSPC cryptcompress
has been added to the -mm tree.  Its filename is
     reiser4-fix-handling-enospc-cryptcompress.patch

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
Subject: reiser4: fix handling ENOSPC cryptcompress
From: Edward Shishkin <edward.shishkin@gmail.com>

Problem:
Processes fall into infinite loop
when running in no-space-left-on-device situation.

Fixup:
Fixed leak of checkin_mutex in do_write_cryptcompress();


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/cryptcompress.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-fix-handling-enospc-cryptcompress fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-fix-handling-enospc-cryptcompress
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -2707,7 +2707,8 @@ static loff_t do_write_cryptcompress(str
 		if (result)
 			goto out;
 		if (cont->state == PSCHED_ASSIGNED_NEW)
-			goto out_no_release;
+			/* done_lh was called in write_pschedule_hook */
+			goto out_no_longterm_lock;
 
 		result = prepare_logical_cluster(inode, pos, count, &clust,
 						 LC_APPOV);
@@ -2779,9 +2780,9 @@ static loff_t do_write_cryptcompress(str
 	} while (count);
  out:
 	done_lh(&hint->lh);
-	mutex_unlock(&info->checkin_mutex);
 	save_file_hint(file, hint);
- out_no_release:
+ out_no_longterm_lock:
+	mutex_unlock(&info->checkin_mutex);
 	kfree(hint);
 	put_cluster_handle(&clust);
 	assert("edward-195",
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

reiser4.patch
reiser4-fix-handling-enospc-cryptcompress.patch
reiser4-fix-handling-enospc-unix_file.patch
reiser4-fix-kill_hook_internal.patch

