From: akpm@linux-foundation.org
Subject: + iov_iter-have-iov_iter_advance-decrement-nr_segs-appropriately.patch added to -mm tree
Date: Thu, 25 Aug 2011 13:40:02 -0700
Message-ID: <201108252040.p7PKe33E006791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754310Ab1HYUkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 16:40:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, npiggin@suse.de


The patch titled
     mm: iov_iter: have iov_iter_advance() decrement nr_segs appropriately
has been added to the -mm tree.  Its filename is
     iov_iter-have-iov_iter_advance-decrement-nr_segs-appropriately.patch

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
Subject: mm: iov_iter: have iov_iter_advance() decrement nr_segs appropriately
From: Jeff Layton <jlayton@redhat.com>

Currently, when you call iov_iter_advance, then the pointer to the iovec
array can be incremented, but it does not decrement the nr_segs value in
the iov_iter struct.  The result is a iov_iter struct with a nr_segs value
that goes beyond the end of the array.

While I'm not aware of anything that's specifically broken by this, it
seems odd and a bit dangerous not to decrement that value.  If someone
were to trust the nr_segs value to be correct, then they could end up
walking off the end of the array.

Changing this might also provide some micro-optimization when dealing with
the last iovec in an array.  Many of the other routines that deal with
iov_iter have optimized codepaths when nr_segs == 1.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/filemap.c~iov_iter-have-iov_iter_advance-decrement-nr_segs-appropriately mm/filemap.c
--- a/mm/filemap.c~iov_iter-have-iov_iter_advance-decrement-nr_segs-appropriately
+++ a/mm/filemap.c
@@ -2113,6 +2113,7 @@ void iov_iter_advance(struct iov_iter *i
 	} else {
 		const struct iovec *iov = i->iov;
 		size_t base = i->iov_offset;
+		unsigned long nr_segs = i->nr_segs;
 
 		/*
 		 * The !iov->iov_len check ensures we skip over unlikely
@@ -2128,11 +2129,13 @@ void iov_iter_advance(struct iov_iter *i
 			base += copy;
 			if (iov->iov_len == base) {
 				iov++;
+				nr_segs--;
 				base = 0;
 			}
 		}
 		i->iov = iov;
 		i->iov_offset = base;
+		i->nr_segs = nr_segs;
 	}
 }
 EXPORT_SYMBOL(iov_iter_advance);
_

Patches currently in -mm which might be from jlayton@redhat.com are

linux-next.patch
iov_iter-have-iov_iter_advance-decrement-nr_segs-appropriately.patch

