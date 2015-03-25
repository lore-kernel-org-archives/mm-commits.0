From: akpm@linux-foundation.org
Subject: + nilfs2-add-bmap-function-to-seek-a-valid-key-fix.patch added to -mm tree
Date: Wed, 25 Mar 2015 13:56:51 -0700
Message-ID: <55132113.Vxab1WYfHFQqPVQV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbbCYU4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 16:56:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2-add-bmap-function-to-seek-a-valid-key-fix
has been added to the -mm tree.  Its filename is
     nilfs2-add-bmap-function-to-seek-a-valid-key-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-add-bmap-function-to-seek-a-valid-key-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-add-bmap-function-to-seek-a-valid-key-fix.patch

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
Subject: nilfs2-add-bmap-function-to-seek-a-valid-key-fix


I've got a report from Dan Carpenter that this range check causes a
warning:

 fs/nilfs2/btree.c:1611 nilfs_btree_seek_key() warn: impossible condition '(start > (~0)) => (0-u64max > u64max)'

A range check was needed there in a wip patch, but we no longer need
it.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/nilfs2/btree.c~nilfs2-add-bmap-function-to-seek-a-valid-key-fix fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-add-bmap-function-to-seek-a-valid-key-fix
+++ a/fs/nilfs2/btree.c
@@ -1608,9 +1608,6 @@ static int nilfs_btree_seek_key(const st
 	const int minlevel = NILFS_BTREE_LEVEL_NODE_MIN;
 	int ret;
 
-	if (start > NILFS_BTREE_KEY_MAX)
-		return -ENOENT;
