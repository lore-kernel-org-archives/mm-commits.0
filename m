From: akpm@linux-foundation.org
Subject: + seq_file-fix-bug-when-seq_read-reads-nothing.patch added to -mm tree
Date: Wed, 25 Jun 2008 15:16:20 -0700
Message-ID: <200806252216.m5PMGKJ5029497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234AbYFYWRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 18:17:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: biannm@cn.fujitsu.com, viro@zeniv.linux.org.uk


The patch titled
     seq_file(): fix bug when seq_read() reads nothing
has been added to the -mm tree.  Its filename is
     seq_file-fix-bug-when-seq_read-reads-nothing.patch

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
Subject: seq_file(): fix bug when seq_read() reads nothing
From: Bian Naimeng <biannm@cn.fujitsu.com>

When I used seq_file to read a proc file, I got a bug in seq_read().  If
show() skips the first element or the size of first element is 0, and the
size of second element is larger than the seq_file->size at the same time,
seq_read will return 0, so nothing can be read from the proc file.

So, if seq_read() returns because it finds the element is bigger than the
m->buf, it must make sure that either some date was filled to m->buf by
show(), or some data was flushed to the user buf beforehand.  If not, it
should increase the m->buf until it can read this element.

Signed-off-by: Bian Naimeng <biannm@cn.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN fs/seq_file.c~seq_file-fix-bug-when-seq_read-reads-nothing fs/seq_file.c
--- a/fs/seq_file.c~seq_file-fix-bug-when-seq_read-reads-nothing
+++ a/fs/seq_file.c
@@ -107,6 +107,7 @@ ssize_t seq_read(struct file *file, char
 		if (!size)
 			goto Done;
 	}
+First_record:
 	/* we need at least one record in buffer */
 	while (1) {
 		pos = m->index;
@@ -145,8 +146,17 @@ Fill:
 		err = m->op->show(m, p);
 		if (m->count == m->size || err) {
 			m->count = offs;
-			if (likely(err <= 0))
+			if (err < 0)
 				break;
+			/* If no data flush to the user buf and nothing was read
+			 * by show() before,it should increase the m->buf until
+			 * it can read this element.
+			*/
+			if (err == 0 && m->count == 0 && copied == 0) {
+				m->index = next;
+				m->op->stop(m, p);
+				goto First_record;
+			}
 		}
 		pos = next;
 	}
_

Patches currently in -mm which might be from biannm@cn.fujitsu.com are

seq_file-fix-bug-when-seq_read-reads-nothing.patch

