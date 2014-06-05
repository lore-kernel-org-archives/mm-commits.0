From: akpm@linux-foundation.org
Subject: [merged]
 fs-mpagec-factor-clean_buffers-out-of-__mpage_writepage.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:50:30 -0700
Message-ID: <5390ca06.9WGNLfRSiH6IFxL6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaFETua (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, dheeraj.reddy@intel.com, david@fromorbit.com, matthew.r.wilcox@intel.com

Subject: [merged] fs-mpagec-factor-clean_buffers-out-of-__mpage_writepage.patch removed from -mm tree
To: matthew.r.wilcox@intel.com,david@fromorbit.com,dheeraj.reddy@intel.com,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:30 -0700


The patch titled
     Subject: fs/mpage.c: factor clean_buffers() out of __mpage_writepage()
has been removed from the -mm tree.  Its filename was
     fs-mpagec-factor-clean_buffers-out-of-__mpage_writepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: fs/mpage.c: factor clean_buffers() out of __mpage_writepage()

__mpage_writepage() is over 200 lines long, has 20 local variables, four
goto labels and could desperately use simplification.  Splitting
clean_buffers() into a helper function improves matters a little, removing
20+ lines from it.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dheeraj Reddy <dheeraj.reddy@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |   54 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff -puN fs/mpage.c~fs-mpagec-factor-clean_buffers-out-of-__mpage_writepage fs/mpage.c
--- a/fs/mpage.c~fs-mpagec-factor-clean_buffers-out-of-__mpage_writepage
+++ a/fs/mpage.c
@@ -439,6 +439,35 @@ struct mpage_data {
 	unsigned use_writepage;
 };
 
+/*
+ * We have our BIO, so we can now mark the buffers clean.  Make
+ * sure to only clean buffers which we know we'll be writing.
+ */
+static void clean_buffers(struct page *page, unsigned first_unmapped)
+{
+	unsigned buffer_counter = 0;
+	struct buffer_head *bh, *head;
+	if (!page_has_buffers(page))
+		return;
+	head = page_buffers(page);
+	bh = head;
+
+	do {
+		if (buffer_counter++ == first_unmapped)
+			break;
+		clear_buffer_dirty(bh);
+		bh = bh->b_this_page;
+	} while (bh != head);
+
+	/*
+	 * we cannot drop the bh if the page is not uptodate or a concurrent
+	 * readpage would fail to serialize with the bh and it would read from
+	 * disk before we reach the platter.
+	 */
+	if (buffer_heads_over_limit && PageUptodate(page))
+		try_to_free_buffers(page);
+}
+
 static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 		      void *data)
 {
@@ -591,30 +620,7 @@ alloc_new:
 		goto alloc_new;
 	}
 
-	/*
-	 * OK, we have our BIO, so we can now mark the buffers clean.  Make
-	 * sure to only clean buffers which we know we'll be writing.
-	 */
-	if (page_has_buffers(page)) {
-		struct buffer_head *head = page_buffers(page);
-		struct buffer_head *bh = head;
-		unsigned buffer_counter = 0;
-
-		do {
-			if (buffer_counter++ == first_unmapped)
-				break;
-			clear_buffer_dirty(bh);
-			bh = bh->b_this_page;
-		} while (bh != head);
