From: akpm@linux-foundation.org
Subject: + reiserfs-use-designated-initializers.patch added to -mm tree
Date: Wed, 29 Mar 2017 14:13:06 -0700
Message-ID: <58dc2362./QYpaX2w8ZUxpRzK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57762 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932774AbdC2VNH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 17:13:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: reiserfs: use designated initializers
has been added to the -mm tree.  Its filename is
     reiserfs-use-designated-initializers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/reiserfs-use-designated-initializers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/reiserfs-use-designated-initializers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from keescook@chromium.org are

mm-fix-section-name-for-dataro_after_init.patch
mm-remove-rodata_test_data-export-add-pr_fmt.patch
reiserfs-use-designated-initializers.patch

