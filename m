From: akpm@linux-foundation.org
Subject: + reiserfs-fix-key-decrementing.patch added to -mm tree
Date: Tue, 10 Apr 2007 15:24:39 -0700
Message-ID: <200704102224.l3AMOdh5019556@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49599 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030412AbXDJWYn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 18:24:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vs@namesys.com, reiserfs-dev@namesys.com


The patch titled
     reiserfs: fix key decrementing
has been added to the -mm tree.  Its filename is
     reiserfs-fix-key-decrementing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs: fix key decrementing
From: Vladimir Saveliev <vs@namesys.com>

This patch fixes a bug in function decrementing a key of stat data item.

Offset of reiserfs keys are compared as signed values.  To set key offset
to maximal possible value maximal signed value has to be used.

This bug is responsible for severe reiserfs filesystem corruption which
shows itself as warning vs-13060.  reiserfsck fixes this corruption by
filesystem tree rebuilding.

Signed-off-by: Vladimir Saveliev <vs@namesys.com>
Cc: <reiserfs-dev@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/item_ops.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/item_ops.c~reiserfs-fix-key-decrementing fs/reiserfs/item_ops.c
--- a/fs/reiserfs/item_ops.c~reiserfs-fix-key-decrementing
+++ a/fs/reiserfs/item_ops.c
@@ -23,7 +23,7 @@ static void sd_decrement_key(struct cpu_
 {
 	key->on_disk_key.k_objectid--;
 	set_cpu_key_k_type(key, TYPE_ANY);
-	set_cpu_key_k_offset(key, (loff_t) (-1));
+	set_cpu_key_k_offset(key, (loff_t)(~0ULL >> 1));
 }
 
 static int sd_is_left_mergeable(struct reiserfs_key *key, unsigned long bsize)
_

Patches currently in -mm which might be from vs@namesys.com are

reiserfs-fix-key-decrementing.patch
reiser4.patch
reiser4-use-simple_prepare_write-to-zero-page-data.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
