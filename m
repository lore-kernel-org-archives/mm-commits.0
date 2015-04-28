From: akpm@linux-foundation.org
Subject: + fs-befs-btreec-remove-unneeded-initializations.patch added to
 -mm tree
Date: Tue, 28 Apr 2015 13:51:00 -0700
Message-ID: <553ff2b4.ji46PtTvxADBslKl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965792AbbD1UvB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Apr 2015 16:51:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/btree.c: remove unneeded initializations
has been added to the -mm tree.  Its filename is
     fs-befs-btreec-remove-unneeded-initializations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-btreec-remove-unneeded-initializations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-btreec-remove-unneeded-initializations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/befs/btree.c: remove unneeded initializations

bh, od_sup and this_node are unconditionally initialized in
befs_bt_read_super() and befs_btree_find()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/btree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/befs/btree.c~fs-befs-btreec-remove-unneeded-initializations fs/befs/btree.c
--- a/fs/befs/btree.c~fs-befs-btreec-remove-unneeded-initializations
+++ a/fs/befs/btree.c
@@ -137,8 +137,8 @@ static int
 befs_bt_read_super(struct super_block *sb, befs_data_stream * ds,
 		   befs_btree_super * sup)
 {
-	struct buffer_head *bh = NULL;
-	befs_disk_btree_super *od_sup = NULL;
+	struct buffer_head *bh;
+	befs_disk_btree_super *od_sup;
 
 	befs_debug(sb, "---> %s", __func__);
 
@@ -250,7 +250,7 @@ int
 befs_btree_find(struct super_block *sb, befs_data_stream * ds,
 		const char *key, befs_off_t * value)
 {
-	struct befs_btree_node *this_node = NULL;
+	struct befs_btree_node *this_node;
 	befs_btree_super bt_super;
 	befs_off_t node_off;
 	int res;
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-affs-amigaffsc-remove-unneeded-initialization.patch
fs-affs-inodec-remove-unneeded-initialization.patch
fs-befs-btreec-remove-unneeded-initializations.patch

