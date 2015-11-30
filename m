From: akpm@linux-foundation.org
Subject: [merged] vfs-avoid-softlockups-with-sendfile2.patch removed from
 -mm tree
Date: Mon, 30 Nov 2015 12:34:50 -0800
Message-ID: <565cb2ea.PyspEKMQK8hfpQR7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbbK3Uev (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 15:34:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dvyukov@google.com, stable@vger.kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: avoid softlockups with sendfile(2)
has been removed from the -mm tree.  Its filename was
     vfs-avoid-softlockups-with-sendfile2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: vfs: avoid softlockups with sendfile(2)

The following test program from Dmitry can cause softlockups or RCU stalls
as it copies 1GB from tmpfs into eventfd and we don't have any scheduling
point at that path in sendfile(2) implementation:

        int r1 = eventfd(0, 0);
        int r2 = memfd_create("", 0);
        unsigned long n = 1<<30;
        fallocate(r2, 0, 0, n);
        sendfile(r1, r2, 0, n);

Add cond_resched() into __splice_from_pipe() to fix the problem.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/splice.c~vfs-avoid-softlockups-with-sendfile2 fs/splice.c
--- a/fs/splice.c~vfs-avoid-softlockups-with-sendfile2
+++ a/fs/splice.c
@@ -891,6 +891,7 @@ ssize_t __splice_from_pipe(struct pipe_i
 
 	splice_from_pipe_begin(sd);
 	do {
+		cond_resched();
 		ret = splice_from_pipe_next(pipe, sd);
 		if (ret > 0)
 			ret = splice_from_pipe_feed(pipe, sd, actor);
_

Patches currently in -mm which might be from jack@suse.cz are


