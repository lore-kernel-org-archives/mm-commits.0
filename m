From: akpm@linux-foundation.org
Subject: +
 nilfs2-fix-sanity-check-of-btree-level-in-nilfs_btree_root_broken.patch
 added to -mm tree
Date: Wed, 29 Apr 2015 16:31:47 -0700
Message-ID: <554169e3.7MO5ajMgK3QJaGOJ%akpm__13580.6832848631$1430350326$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbbD2Xbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 19:31:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix sanity check of btree level in nilfs_btree_root_broken()
has been added to the -mm tree.  Its filename is
     nilfs2-fix-sanity-check-of-btree-level-in-nilfs_btree_root_broken.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-fix-sanity-check-of-btree-level-in-nilfs_btree_root_broken.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-fix-sanity-check-of-btree-level-in-nilfs_btree_root_broken.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: fix sanity check of btree level in nilfs_btree_root_broken()

The range check for b-tree level parameter in nilfs_btree_root_broken() is
wrong; it accepts the case of "level == NILFS_BTREE_LEVEL_MAX" even though
the level is limited to values in the range of 0 to (NILFS_BTREE_LEVEL_MAX
- 1).

Since the level parameter is read from storage device and used to index
nilfs_btree_path array whose element count is NILFS_BTREE_LEVEL_MAX, it
can cause memory overrun during btree operations if the boundary value is
set to the level parameter on device.

This fixes the broken sanity check and adds a comment to clarify that the
upper bound NILFS_BTREE_LEVEL_MAX is exclusive.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c         |    2 +-
 include/linux/nilfs2_fs.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/nilfs2/btree.c~nilfs2-fix-sanity-check-of-btree-level-in-nilfs_btree_root_broken fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-fix-sanity-check-of-btree-level-in-nilfs_btree_root_broken
+++ a/fs/nilfs2/btree.c
@@ -388,7 +388,7 @@ static int nilfs_btree_root_broken(const
 	nchildren = nilfs_btree_node_get_nchildren(node);
 
 	if (unlikely(level < NILFS_BTREE_LEVEL_NODE_MIN ||
-		     level > NILFS_BTREE_LEVEL_MAX ||
+		     level >= NILFS_BTREE_LEVEL_MAX ||
 		     nchildren < 0 ||
 		     nchildren > NILFS_BTREE_ROOT_NCHILDREN_MAX)) {
 		pr_crit("NILFS: bad btree root (inode number=%lu): level = %d, flags = 0x%x, nchildren = %d\n",
diff -puN include/linux/nilfs2_fs.h~nilfs2-fix-sanity-check-of-btree-level-in-nilfs_btree_root_broken include/linux/nilfs2_fs.h
--- a/include/linux/nilfs2_fs.h~nilfs2-fix-sanity-check-of-btree-level-in-nilfs_btree_root_broken
+++ a/include/linux/nilfs2_fs.h
@@ -460,7 +460,7 @@ struct nilfs_btree_node {
 /* level */
 #define NILFS_BTREE_LEVEL_DATA          0
 #define NILFS_BTREE_LEVEL_NODE_MIN      (NILFS_BTREE_LEVEL_DATA + 1)
-#define NILFS_BTREE_LEVEL_MAX           14
+#define NILFS_BTREE_LEVEL_MAX           14	/* Max level (exclusive) */
 
 /**
  * struct nilfs_palloc_group_desc - block group descriptor
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-fix-sanity-check-of-btree-level-in-nilfs_btree_root_broken.patch

