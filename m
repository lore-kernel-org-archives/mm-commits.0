From: akpm@linux-foundation.org
Subject: - iov_iter_advance-fix.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:22:37 -0700
Message-ID: <200803110322.m2B3MbQt019825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309AbYCKDW4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, adobriyan@gmail.com, kwc@citi.umich.edu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     iov_iter_advance() fix
has been removed from the -mm tree.  Its filename was
     iov_iter_advance-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iov_iter_advance() fix
From: Nick Piggin <npiggin@suse.de>

iov_iter_advance() skips over zero-length iovecs, however it does not properly
terminate at the end of the iovec array.  Fix this by checking against
i->count before we skip a zero-length iov.

The bug was reproduced with a test program that continually randomly creates
iovs to writev.  The fix was also verified with the same program and also it
could verify that the correct data was contained in the file after each
writev.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Tested-by: "Kevin Coffman" <kwc@citi.umich.edu>
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN mm/filemap.c~iov_iter_advance-fix mm/filemap.c
--- a/mm/filemap.c~iov_iter_advance-fix
+++ a/mm/filemap.c
@@ -1742,21 +1742,27 @@ size_t iov_iter_copy_from_user(struct pa
 }
 EXPORT_SYMBOL(iov_iter_copy_from_user);
 
-static void __iov_iter_advance_iov(struct iov_iter *i, size_t bytes)
+void iov_iter_advance(struct iov_iter *i, size_t bytes)
 {
+	BUG_ON(i->count < bytes);
+
 	if (likely(i->nr_segs == 1)) {
 		i->iov_offset += bytes;
+		i->count -= bytes;
 	} else {
 		const struct iovec *iov = i->iov;
 		size_t base = i->iov_offset;
 
 		/*
 		 * The !iov->iov_len check ensures we skip over unlikely
-		 * zero-length segments.
+		 * zero-length segments (without overruning the iovec).
 		 */
-		while (bytes || !iov->iov_len) {
-			int copy = min(bytes, iov->iov_len - base);
+		while (bytes || unlikely(!iov->iov_len && i->count)) {
+			int copy;
 
+			copy = min(bytes, iov->iov_len - base);
+			BUG_ON(!i->count || i->count < copy);
+			i->count -= copy;
 			bytes -= copy;
 			base += copy;
 			if (iov->iov_len == base) {
@@ -1768,14 +1774,6 @@ static void __iov_iter_advance_iov(struc
 		i->iov_offset = base;
 	}
 }
-
-void iov_iter_advance(struct iov_iter *i, size_t bytes)
-{
-	BUG_ON(i->count < bytes);
