From: akpm@linux-foundation.org
Subject: + pipe-fix-pipe-buffer-resizing.patch added to -mm tree
Date: Wed, 09 Jun 2010 14:00:44 -0700
Message-ID: <201006092100.o59L0imA021300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758289Ab0FIVAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jun 2010 17:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     pipe: fix pipe buffer resizing
has been added to the -mm tree.  Its filename is
     pipe-fix-pipe-buffer-resizing.patch

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
Subject: pipe: fix pipe buffer resizing
From: Miklos Szeredi <mszeredi@suse.cz>

pipe_set_size() needs to copy pipe bufs from the old circular buffer to
the new.

The current code gets this wrong in multiple ways, resulting in oops.

Test program is available here:
  http://www.kernel.org/pub/linux/kernel/people/mszeredi/piperesize/

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN fs/pipe.c~pipe-fix-pipe-buffer-resizing fs/pipe.c
--- a/fs/pipe.c~pipe-fix-pipe-buffer-resizing
+++ a/fs/pipe.c
@@ -1145,13 +1145,20 @@ static long pipe_set_size(struct pipe_in
 	 * and adjust the indexes.
 	 */
 	if (pipe->nrbufs) {
-		const unsigned int tail = pipe->nrbufs & (pipe->buffers - 1);
-		const unsigned int head = pipe->nrbufs - tail;
+		unsigned int tail;
+		unsigned int head;
 
+		tail = pipe->curbuf + pipe->nrbufs;
+		if (tail < pipe->buffers)
+			tail = 0;
+		else
+			tail &= (pipe->buffers - 1);
+
+		head = pipe->nrbufs - tail;
 		if (head)
 			memcpy(bufs, pipe->bufs + pipe->curbuf, head * sizeof(struct pipe_buffer));
 		if (tail)
-			memcpy(bufs + head, pipe->bufs + pipe->curbuf, tail * sizeof(struct pipe_buffer));
+			memcpy(bufs + head, pipe->bufs, tail * sizeof(struct pipe_buffer));
 	}
 
 	pipe->curbuf = 0;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

pipe-fix-pipe-buffer-resizing.patch
pipe-remove-bogus-check-from-set-size-fcntl.patch

