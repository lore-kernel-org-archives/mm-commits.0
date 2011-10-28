From: akpm@linux-foundation.org
Subject: [merged] iov_iter-have-iov_iter_advance-decrement-nr_segs-appropriately.patch removed from -mm tree
Date: Fri, 28 Oct 2011 15:10:10 -0700
Message-ID: <201110282210.p9SMAAZL000387@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:6867 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab1J1WKW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2011 18:10:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: iov_iter: have iov_iter_advance() decrement nr_segs appropriately
has been removed from the -mm tree.  Its filename was
     iov_iter-have-iov_iter_advance-decrement-nr_segs-appropriately.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: mm: iov_iter: have iov_iter_advance() decrement nr_segs appropriately

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
@@ -2115,6 +2115,7 @@ void iov_iter_advance(struct iov_iter *i
 	} else {
 		const struct iovec *iov = i->iov;
 		size_t base = i->iov_offset;
+		unsigned long nr_segs = i->nr_segs;
 
 		/*
 		 * The !iov->iov_len check ensures we skip over unlikely
@@ -2130,11 +2131,13 @@ void iov_iter_advance(struct iov_iter *i
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

origin.patch
linux-next.patch

