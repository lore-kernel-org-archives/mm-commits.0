From: akpm@linux-foundation.org
Subject: + sendfile-several-fixes.patch added to -mm tree
Date: Tue, 30 Jun 2009 13:55:00 -0700
Message-ID: <200906302055.n5UKt0uQ017763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800AbZF3UzC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 16:55:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msb@google.com, rlove@google.com, viro@zeniv.linux.org.uk


The patch titled
     sendfile: several fixes
has been added to the -mm tree.  Its filename is
     sendfile-several-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sendfile: several fixes
From: Mandeep Singh Baines <msb@google.com>

Three fixes for sendfile, mostly related to sending large files from pseudo
filesystems:

- Fix sendfile for offsets > 300G. This can happen with pseudo filesystems.
  This happens because the overflow check is using inode->i_sb->s_maxbytes
  and not the superblock of the backing device's s_maxbytes. For a regular file
  these are interchangible but for a special file these are different and you
  want the latter.

- Don't compare against the max of the out_inode's superblock. Doesn't make
  sense.

- For pseudo and other filesystems with s_maxbytes set to ~0ULL, max ends up
  holding a negative number as it is signed. Check for and correct that.

Signed-off-by: Robert Love <rlove@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN fs/read_write.c~sendfile-several-fixes fs/read_write.c
--- a/fs/read_write.c~sendfile-several-fixes
+++ a/fs/read_write.c
@@ -835,8 +835,15 @@ static ssize_t do_sendfile(int out_fd, i
 		goto fput_out;
 	count = retval;
 
-	if (!max)
-		max = min(in_inode->i_sb->s_maxbytes, out_inode->i_sb->s_maxbytes);
+	if (!max) {
+		max = in_inode->i_mapping->host->i_sb->s_maxbytes;
+		/*
+		 * For psuedo filesystems, s_maxbytes is ~0ULL. When converted
+		 * to loff_t, it can go negative. So we check for and fix that.
+		 */
+		if (max < 0)
+			max = LLONG_MAX;
+	}
 
 	pos = *ppos;
 	retval = -EINVAL;
_

Patches currently in -mm which might be from msb@google.com are

sendfile-several-fixes.patch

