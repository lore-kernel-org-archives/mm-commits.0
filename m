From: akpm@linux-foundation.org
Subject: [merged] vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:38:13 -0700
Message-ID: <200909241938.n8OJcDN7006156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753250AbZIXTsY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:48:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, hannes@cmpxchg.org, hch@lst.de, msb@google.com, rlove@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: explicitly cast s_maxbytes in fiemap_check_ranges
has been removed from the -mm tree.  Its filename was
     vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

