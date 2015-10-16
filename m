From: akpm@linux-foundation.org
Subject: + mm-make-sendfile2-killable.patch added to -mm tree
Date: Fri, 16 Oct 2015 14:05:22 -0700
Message-ID: <56216692.fMXn+SOItQvi5RA9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbbJPVFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Oct 2015 17:05:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.com, dvyukov@google.com, stable@vger.kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make sendfile(2) killable
has been added to the -mm tree.  Its filename is
     mm-make-sendfile2-killable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-sendfile2-killable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-sendfile2-killable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-make-sendfile2-killable.patch

