From: akpm@linux-foundation.org
Subject: [patch 122/142] mm/backing-dev.c: use rb_entry()
Date: Wed, 22 Feb 2017 15:45:52 -0800
Message-ID: <58ae22b0.6bg/NZjnv0Vdytiy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49534 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934194AbdBVXpy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:45:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, geliangtang@gmail.com, axboe@fb.com, tj@kernel.org

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
