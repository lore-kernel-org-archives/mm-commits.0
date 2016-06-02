From: akpm@linux-foundation.org
Subject: + nilfs2-do-not-use-yield.patch added to -mm tree
Date: Thu, 02 Jun 2016 13:20:02 -0700
Message-ID: <575094f2.TDYl9P7Cb6TSnCl9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbcFBUUD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 16:20:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: do not use yield()
has been added to the -mm tree.  Its filename is
     nilfs2-do-not-use-yield.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-do-not-use-yield.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-do-not-use-yield.patch

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

nilfs2-hide-function-name-argument-from-nilfs_error.patch
nilfs2-add-nilfs_msg-message-interface.patch
nilfs2-embed-a-back-pointer-to-super-block-instance-in-nilfs-object.patch
nilfs2-reduce-bare-use-of-printk-with-nilfs_msg.patch
nilfs2-replace-nilfs_warning-with-nilfs_msg.patch
nilfs2-emit-error-message-when-i-o-error-is-detected.patch
nilfs2-do-not-use-yield.patch
nilfs2-refactor-parser-of-snapshot-mount-option.patch

