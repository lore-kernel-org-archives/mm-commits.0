From: akpm@linux-foundation.org
Subject: [patch 033/114] reiserfs: use designated initializers
Date: Mon, 08 May 2017 15:56:08 -0700
Message-ID: <20170508225608.ZzDhghu1X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46060 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751850AbdEHW4K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:56:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, keescook@chromium.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Kees Cook <keescook@chromium.org>
Subject: reiserfs: use designated initializers

Prepare to mark sensitive kernel structures for randomization by making
sure they're using designated initializers.  These were identified during
allyesconfig builds of x86, arm, and arm64, with most initializer fixes
extracted from grsecurity.

Link: http://lkml.kernel.org/r/20170329210419.GA40066@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/item_ops.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/reiserfs/item_ops.c~reiserfs-use-designated-initializers fs/reiserfs/item_ops.c
--- a/fs/reiserfs/item_ops.c~reiserfs-use-designated-initializers
+++ a/fs/reiserfs/item_ops.c
@@ -724,18 +724,18 @@ static void errcatch_print_vi(struct vir
 }
 
 static struct item_operations errcatch_ops = {
-	errcatch_bytes_number,
-	errcatch_decrement_key,
-	errcatch_is_left_mergeable,
-	errcatch_print_item,
-	errcatch_check_item,
+	.bytes_number = errcatch_bytes_number,
+	.decrement_key = errcatch_decrement_key,
+	.is_left_mergeable = errcatch_is_left_mergeable,
+	.print_item = errcatch_print_item,
+	.check_item = errcatch_check_item,
 
-	errcatch_create_vi,
-	errcatch_check_left,
-	errcatch_check_right,
-	errcatch_part_size,
-	errcatch_unit_num,
-	errcatch_print_vi
+	.create_vi = errcatch_create_vi,
+	.check_left = errcatch_check_left,
+	.check_right = errcatch_check_right,
+	.part_size = errcatch_part_size,
+	.unit_num = errcatch_unit_num,
+	.print_vi = errcatch_print_vi
 };
 
 #if ! (TYPE_STAT_DATA == 0 && TYPE_INDIRECT == 1 && TYPE_DIRECT == 2 && TYPE_DIRENTRY == 3)
_
