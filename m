From: akpm@linux-foundation.org
Subject: [patch 066/111] nilfs2: do not use yield()
Date: Tue, 02 Aug 2016 14:05:19 -0700
Message-ID: <57a10b0f.M6gyERb09zpkkEwK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbcHBVQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:16:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp

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
