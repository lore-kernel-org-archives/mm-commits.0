From: akpm@linux-foundation.org
Subject: [merged] mm-make-sendfile2-killable.patch removed from -mm tree
Date: Fri, 30 Oct 2015 12:44:43 -0700
Message-ID: <5633c8ab.ql0ZBw7Pymq0+Zl6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760457AbbJ3Too (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Oct 2015 15:44:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.com, dvyukov@google.com, stable@vger.kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make sendfile(2) killable
has been removed from the -mm tree.  Its filename was
     mm-make-sendfile2-killable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.com>
Subject: mm: make sendfile(2) killable

Currently a simple program below issues a sendfile(2) system call which
takes about 62 days to complete in my test KVM instance.

        int fd;
        off_t off = 0;

        fd = open("file", O_RDWR | O_TRUNC | O_SYNC | O_CREAT, 0644);
        ftruncate(fd, 2);
        lseek(fd, 0, SEEK_END);
        sendfile(fd, fd, &off, 0xfffffff);

Now you should not ask kernel to do a stupid stuff like copying 256MB in
2-byte chunks and call fsync(2) after each chunk but if you do, sysadmin
should have a way to stop you.

We actually do have a check for fatal_signal_pending() in
generic_perform_write() which triggers in this path however because we
always succeed in writing something before the check is done, we return
value > 0 from generic_perform_write() and thus the information about
signal gets lost.

Fix the problem by doing the signal check before writing anything.  That
way generic_perform_write() returns -EINTR, the error gets propagated up
and the sendfile loop terminates early.

Signed-off-by: Jan Kara <jack@suse.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/filemap.c~mm-make-sendfile2-killable mm/filemap.c
--- a/mm/filemap.c~mm-make-sendfile2-killable
+++ a/mm/filemap.c
@@ -2488,6 +2488,11 @@ again:
 			break;
 		}
 
+		if (fatal_signal_pending(current)) {
+			status = -EINTR;
+			break;
+		}
+
 		status = a_ops->write_begin(file, mapping, pos, bytes, flags,
 						&page, &fsdata);
 		if (unlikely(status < 0))
@@ -2525,10 +2530,6 @@ again:
 		written += copied;
 
 		balance_dirty_pages_ratelimited(mapping);
-		if (fatal_signal_pending(current)) {
-			status = -EINTR;
-			break;
-		}
 	} while (iov_iter_count(i));
 
 	return written ? written : status;
_

Patches currently in -mm which might be from jack@suse.com are


