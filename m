From: akpm@linux-foundation.org
Subject: + sync_file_range_write-may-and-will-block-document-that.patch added to -mm tree
Date: Tue, 03 Jun 2008 14:04:41 -0700
Message-ID: <200806032104.m53L4f3w019764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbYFCVFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 17:05:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz


The patch titled
     SYNC_FILE_RANGE_WRITE may and will block. Document that.
has been added to the -mm tree.  Its filename is
     sync_file_range_write-may-and-will-block-document-that.patch

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
Subject: SYNC_FILE_RANGE_WRITE may and will block. Document that.
From: Pavel Machek <pavel@suse.cz>

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sync.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/sync.c~sync_file_range_write-may-and-will-block-document-that fs/sync.c
--- a/fs/sync.c~sync_file_range_write-may-and-will-block-document-that
+++ a/fs/sync.c
@@ -139,7 +139,8 @@ asmlinkage long sys_fdatasync(unsigned i
  * before performing the write.
  *
  * SYNC_FILE_RANGE_WRITE: initiate writeout of all those dirty pages in the
- * range which are not presently under writeback.
+ * range which are not presently under writeback. Notice that even this this
+ *  may and will block if you attempt to write more than request queue size.
  *
  * SYNC_FILE_RANGE_WAIT_AFTER: wait upon writeout of all pages in the range
  * after performing the write.
_

Patches currently in -mm which might be from pavel@suse.cz are

linux-next.patch
aperture_64c-corner-case-wrong.patch
sync_file_range_write-may-and-will-block-document-that.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
pm-boot-time-suspend-selftest.patch

