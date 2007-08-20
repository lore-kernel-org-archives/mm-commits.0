From: akpm@linux-foundation.org
Subject: + mm-add-end_buffer_read-helper-function.patch added to -mm tree
Date: Mon, 20 Aug 2007 13:51:29 -0700
Message-ID: <200708202051.l7KKpTqB022655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45522 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760317AbXHTUwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 16:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org, nickpiggin@yahoo.com.au


The patch titled
     mm: add end_buffer_read helper function
has been added to the -mm tree.  Its filename is
     mm-add-end_buffer_read-helper-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: add end_buffer_read helper function
From: Dmitry Monakhov <dmonakhov@openvz.org>

Move duplicated code from end_buffer_read_XXX methods to separate helper
function.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff -puN fs/buffer.c~mm-add-end_buffer_read-helper-function fs/buffer.c
--- a/fs/buffer.c~mm-add-end_buffer_read-helper-function
+++ a/fs/buffer.c
@@ -110,10 +110,14 @@ static void buffer_io_error(struct buffe
 }
 
 /*
- * Default synchronous end-of-IO handler..  Just mark it up-to-date and
- * unlock the buffer. This is what ll_rw_block uses too.
+ * End-of-IO handler helper function which does not touch the bh after
+ * unlocking it.
+ * Note: unlock_buffer() sort-of does touch the bh after unlocking it, but
+ * a race there is benign: unlock_buffer() only use the bh's address for
+ * hashing after unlocking the buffer, so it doesn't actually touch the bh
+ * itself.
  */
-void end_buffer_read_sync(struct buffer_head *bh, int uptodate)
+static void __end_buffer_read_notouch(struct buffer_head *bh, int uptodate)
 {
 	if (uptodate) {
 		set_buffer_uptodate(bh);
@@ -122,6 +126,15 @@ void end_buffer_read_sync(struct buffer_
 		clear_buffer_uptodate(bh);
 	}
 	unlock_buffer(bh);
+}
+
+/*
+ * Default synchronous end-of-IO handler..  Just mark it up-to-date and
+ * unlock the buffer. This is what ll_rw_block uses too.
+ */
+void end_buffer_read_sync(struct buffer_head *bh, int uptodate)
+{
+	__end_buffer_read_notouch(bh, uptodate);
 	put_bh(bh);
 }
 
@@ -2243,21 +2256,10 @@ out_unlock:
  * nobh_prepare_write()'s prereads are special: the buffer_heads are freed
  * immediately, while under the page lock.  So it needs a special end_io
  * handler which does not touch the bh after unlocking it.
- *
- * Note: unlock_buffer() sort-of does touch the bh after unlocking it, but
- * a race there is benign: unlock_buffer() only use the bh's address for
- * hashing after unlocking the buffer, so it doesn't actually touch the bh
- * itself.
  */
 static void end_buffer_read_nobh(struct buffer_head *bh, int uptodate)
 {
-	if (uptodate) {
-		set_buffer_uptodate(bh);
-	} else {
-		/* This happens, due to failed READA attempts. */
-		clear_buffer_uptodate(bh);
-	}
-	unlock_buffer(bh);
+	__end_buffer_read_notouch(bh, uptodate);
 }
 
 /*
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

git-md-accel.patch
mm-add-end_buffer_read-helper-function.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
deny-partial-write-for-loop-dev-fd.patch
