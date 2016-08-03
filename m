From: akpm@linux-foundation.org
Subject: [merged] nilfs2-do-not-use-yield.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:13:10 -0700
Message-ID: <57a23436.i6sZLmzrBByRvrPf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbcHCSNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: do not use yield()
has been removed from the -mm tree.  Its filename was
     nilfs2-do-not-use-yield.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: do not use yield()

Use cond_resched() instead of yield() in the loop of
nilfs_transaction_lock() since the usage corresponds to the "be nice for
others" case that the comment of yield() says.

This removes the following checkpatch.pl warning:

 "WARNING: Using yield() is generally wrong. See yield() kernel-doc
  (sched/core.c)"

Link: http://lkml.kernel.org/r/1464875891-5443-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/segment.c~nilfs2-do-not-use-yield fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-do-not-use-yield
+++ a/fs/nilfs2/segment.c
@@ -373,7 +373,7 @@ static void nilfs_transaction_lock(struc
 		nilfs_segctor_do_immediate_flush(sci);
 
 		up_write(&nilfs->ns_segctor_sem);
-		yield();
+		cond_resched();
 	}
 	if (gcflag)
 		ti->ti_flags |= NILFS_TI_GC;
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


