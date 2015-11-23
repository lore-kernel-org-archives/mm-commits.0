From: akpm@linux-foundation.org
Subject: + vfs-make-sendfile2-killable-even-better.patch added to -mm tree
Date: Mon, 23 Nov 2015 15:07:38 -0800
Message-ID: <56539c3a.NexrV3l6vxA/byBD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbbKWXHj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 18:07:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dvyukov@google.com, stable@vger.kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: make sendfile(2) killable even better
has been added to the -mm tree.  Its filename is
     vfs-make-sendfile2-killable-even-better.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-make-sendfile2-killable-even-better.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-make-sendfile2-killable-even-better.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: vfs: make sendfile(2) killable even better

Commit 296291cdd162 ("mm: make sendfile(2) killable") fixed an issue where
sendfile(2) was doing a lot of tiny writes into a filesystem and thus was
unkillable for a long time.  However sendfile(2) can be (mis)used to issue
lots of writes into arbitrary file descriptor such as eventfd or similar
special file descriptors which never hit the standard filesystem write
path and thus are still unkillable.  E.g.  the following example from
Dmitry burns CPU for ~16s on my test system without possibility to be
killed:

        int r1 = eventfd(0, 0);
        int r2 = memfd_create("", 0);
        unsigned long n = 1<<30;
        fallocate(r2, 0, 0, n);
        sendfile(r1, r2, 0, n);

There are actually quite a few tests for pending signals in sendfile code
however when data to write is always available none of them seems to
trigger.  So fix the problem by adding a test for pending signal into
splice_from_pipe_next() also before the loop waiting for pipe buffers to
be available.  This should fix all the lockup issues with sendfile of the
do-ton-of-tiny-writes nature.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/splice.c~vfs-make-sendfile2-killable-even-better fs/splice.c
--- a/fs/splice.c~vfs-make-sendfile2-killable-even-better
+++ a/fs/splice.c
@@ -809,6 +809,13 @@ static int splice_from_pipe_feed(struct
  */
 static int splice_from_pipe_next(struct pipe_inode_info *pipe, struct splice_desc *sd)
 {
+	/*
+	 * Check for signal early to make process killable when there are
+	 * always buffers available
+	 */
+	if (signal_pending(current))
+		return -ERESTARTSYS;
+
 	while (!pipe->nrbufs) {
 		if (!pipe->writers)
 			return 0;
_

Patches currently in -mm which might be from jack@suse.cz are

vfs-make-sendfile2-killable-even-better.patch
vfs-avoid-softlockups-with-sendfile2.patch

