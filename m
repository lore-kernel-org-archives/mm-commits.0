From: akpm@linux-foundation.org
Subject: + libfs-make-simple_read_from_buffer-conventional.patch added to -mm tree
Date: Wed, 04 Mar 2009 13:48:09 -0800
Message-ID: <200903042148.n24Lm94w006428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753711AbZCDVsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 16:48:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, hpa@zytor.com, mingo@elte.hu, srostedt@redhat.com, tytso@mit.edu, viro@zeniv.linux.org.uk


The patch titled
     libfs: make simple_read_from_buffer conventional
has been added to the -mm tree.  Its filename is
     libfs-make-simple_read_from_buffer-conventional.patch

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
Subject: libfs: make simple_read_from_buffer conventional
From: Steven Rostedt <rostedt@goodmis.org>

Impact: have simple_read_from_buffer conform to standards

It was brought to my attention by Andrew Morton, Theodore Tso, and H. 
Peter Anvin that a read from userspace should only return -EFAULT if
nothing was actually read.

Looking at the simple_read_from_buffer I noticed that this function does
not conform to that rule.  This patch fixes that function.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/libfs.c~libfs-make-simple_read_from_buffer-conventional fs/libfs.c
--- a/fs/libfs.c~libfs-make-simple_read_from_buffer-conventional
+++ a/fs/libfs.c
@@ -526,14 +526,20 @@ ssize_t simple_read_from_buffer(void __u
 				const void *from, size_t available)
 {
 	loff_t pos = *ppos;
+	size_t ret;
+
 	if (pos < 0)
 		return -EINVAL;
 	if (pos >= available)
 		return 0;
 	if (count > available - pos)
 		count = available - pos;
-	if (copy_to_user(to, from + pos, count))
-		return -EFAULT;
+	ret = copy_to_user(to, from + pos, count);
+	if (ret) {
+		if (ret == count)
+			return -EFAULT;
+		count -= ret;
+	}
 	*ppos = pos + count;
 	return count;
 }
_

Patches currently in -mm which might be from rostedt@goodmis.org are

linux-next.patch
libfs-make-simple_read_from_buffer-conventional.patch

