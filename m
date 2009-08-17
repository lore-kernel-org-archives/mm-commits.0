From: akpm@linux-foundation.org
Subject: + vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch added to -mm tree
Date: Mon, 17 Aug 2009 16:02:17 -0700
Message-ID: <200908172302.n7HN2H1l002863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758262AbZHQXDc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 19:03:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, hannes@cmpxchg.org, hch@lst.de, msb@google.com, rlove@google.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: explicitly cast s_maxbytes in fiemap_check_ranges
has been added to the -mm tree.  Its filename is
     vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch

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
Subject: vfs: explicitly cast s_maxbytes in fiemap_check_ranges
From: Jeff Layton <jlayton@redhat.com>

If fiemap_check_ranges is passed a large enough value, then it's
possible that the value would be cast to a signed value for comparison
against s_maxbytes when we change it to loff_t. Make sure that doesn't
happen by explicitly casting s_maxbytes to an unsigned value for the
purposes of comparison.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Robert Love <rlove@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mandeep Singh Baines <msb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioctl.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/ioctl.c~vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges fs/ioctl.c
--- a/fs/ioctl.c~vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges
+++ a/fs/ioctl.c
@@ -162,20 +162,21 @@ EXPORT_SYMBOL(fiemap_check_flags);
 static int fiemap_check_ranges(struct super_block *sb,
 			       u64 start, u64 len, u64 *new_len)
 {
+	u64 maxbytes = (u64) sb->s_maxbytes;
+
 	*new_len = len;
 
 	if (len == 0)
 		return -EINVAL;
 
-	if (start > sb->s_maxbytes)
+	if (start > maxbytes)
 		return -EFBIG;
 
 	/*
 	 * Shrink request scope to what the fs can actually handle.
 	 */
-	if ((len > sb->s_maxbytes) ||
-	    (sb->s_maxbytes - len) < start)
-		*new_len = sb->s_maxbytes - start;
+	if (len > maxbytes || (maxbytes - len) < start)
+		*new_len = maxbytes - start;
 
 	return 0;
 }
_

Patches currently in -mm which might be from jlayton@redhat.com are

vfs-make-get_sb_pseudo-set-s_maxbytes-to-value-that-can-be-cast-to-signed.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch

