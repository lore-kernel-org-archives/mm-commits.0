From: akpm@linux-foundation.org
Subject: [merged] writeback-use-rb_entry.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:16:49 -0800
Message-ID: <58af5141.k1d/x+vLs0zryoef%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40744 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751222AbdBWVRl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:17:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, axboe@fb.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/backing-dev.c: use rb_entry()
has been removed from the -mm tree.  Its filename was
     writeback-use-rb_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: mm/backing-dev.c: use rb_entry()

To make the code clearer, use rb_entry() instead of container_of() to
deal with rbtree.

Link: http://lkml.kernel.org/r/671275de093d93ddc7c6f77ddc0d357149691a39.1484306840.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/backing-dev.c~writeback-use-rb_entry mm/backing-dev.c
--- a/mm/backing-dev.c~writeback-use-rb_entry
+++ a/mm/backing-dev.c
@@ -411,8 +411,8 @@ retry:
 
 	while (*node != NULL) {
 		parent = *node;
-		congested = container_of(parent, struct bdi_writeback_congested,
-					 rb_node);
+		congested = rb_entry(parent, struct bdi_writeback_congested,
+				     rb_node);
 		if (congested->blkcg_id < blkcg_id)
 			node = &parent->rb_left;
 		else if (congested->blkcg_id > blkcg_id)
_

Patches currently in -mm which might be from geliangtang@gmail.com are

proc-use-rb_entry.patch
fs-add-i_blocksize-fix.patch
nilfs2-use-nilfs_btree_node_size.patch
nilfs2-use-i_blocksize.patch

