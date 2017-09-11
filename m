From: akpm@linux-foundation.org
Subject: [merged]
 lib-rhashtable-fix-comment-on-locks_mul-default-value.patch removed from
 -mm tree
Date: Mon, 11 Sep 2017 12:42:31 -0700
Message-ID: <20170911194231.Oh6G0NPi5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50234 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbdIKTmc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:42:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, fw@strlen.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/rhashtable: fix comment on locks_mul default value
has been removed from the -mm tree.  Its filename was
     lib-rhashtable-fix-comment-on-locks_mul-default-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: lib/rhashtable: fix comment on locks_mul default value

As of 4cf0b354d92 ("rhashtable: avoid large lock-array allocations"), the
default value for the locks multiplier was reduced from 128 to 32.  Update
the header file to reflect this.

Link: http://lkml.kernel.org/r/20170815215401.30745-1-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rhashtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/rhashtable.h~lib-rhashtable-fix-comment-on-locks_mul-default-value include/linux/rhashtable.h
--- a/include/linux/rhashtable.h~lib-rhashtable-fix-comment-on-locks_mul-default-value
+++ a/include/linux/rhashtable.h
@@ -127,7 +127,7 @@ struct rhashtable;
  * @head_offset: Offset of rhash_head in struct to be hashed
  * @max_size: Maximum size while expanding
  * @min_size: Minimum size while shrinking
- * @locks_mul: Number of bucket locks to allocate per cpu (default: 128)
+ * @locks_mul: Number of bucket locks to allocate per cpu (default: 32)
  * @automatic_shrinking: Enable automatic shrinking of tables
  * @nulls_base: Base value to generate nulls marker
  * @hashfn: Hash function (default: jhash2 if !(key_len % 4), or jhash)
_

Patches currently in -mm which might be from dave@stgolabs.net are


