From: akpm@linux-foundation.org
Subject: [merged] libfs-make-simple_read_from_buffer-conventional.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:37:56 -0700
Message-ID: <200909241937.n8OJbuPK005619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516AbZIXTic (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:38:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, hpa@zytor.com, mingo@elte.hu, srostedt@redhat.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     libfs: make simple_read_from_buffer conventional
has been removed from the -mm tree.  Its filename was
     libfs-make-simple_read_from_buffer-conventional.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libfs: make simple_read_from_buffer conventional
From: Steven Rostedt <rostedt@goodmis.org>

Impact: have simple_read_from_buffer conform to standards

It was brought to my attention by Andrew Morton, Theodore Tso, and H. 
Peter Anvin that a read from userspace should only return -EFAULT if
nothing was actually read.

Looking at the simple_read_from_buffer I noticed that this function does
not conform to that rule.  This patch fixes that function.

[akpm@linux-foundation.org: simplification suggested by hpa]
[hpa@zytor.com: fix count==0 handling]
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/libfs.c~libfs-make-simple_read_from_buffer-conventional fs/libfs.c
--- a/fs/libfs.c~libfs-make-simple_read_from_buffer-conventional
+++ a/fs/libfs.c
@@ -527,14 +527,18 @@ ssize_t simple_read_from_buffer(void __u
 				const void *from, size_t available)
 {
 	loff_t pos = *ppos;
+	size_t ret;
+
 	if (pos < 0)
 		return -EINVAL;
-	if (pos >= available)
+	if (pos >= available || !count)
 		return 0;
 	if (count > available - pos)
 		count = available - pos;
-	if (copy_to_user(to, from + pos, count))
+	ret = copy_to_user(to, from + pos, count);
+	if (ret == count)
 		return -EFAULT;
+	count -= ret;
 	*ppos = pos + count;
 	return count;
 }
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
linux-next.patch

