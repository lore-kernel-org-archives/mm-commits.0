From: akpm@linux-foundation.org
Subject: + nfs-no-pg_private-waiters-remain-remove-waker.patch added to
 -mm tree
Date: Thu, 05 Jan 2017 16:32:53 -0800
Message-ID: <586ee5b5.Zuu1YRdP8q0EZS+/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35002 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932094AbdAFAbf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 19:31:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@gmail.com, anna.schumaker@netapp.com, trond.myklebust@primarydata.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nfs: no PG_private waiters remain, remove waker
has been added to the -mm tree.  Its filename is
     nfs-no-pg_private-waiters-remain-remove-waker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nfs-no-pg_private-waiters-remain-remove-waker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nfs-no-pg_private-waiters-remain-remove-waker.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: nfs: no PG_private waiters remain, remove waker

Since commit 4f52b6bb ("NFS: Don't call COMMIT in ->releasepage()"), no
tasks wait on PagePrivate, so the wake introduced in commit 95905446
("NFS: avoid deadlocks with loop-back mounted NFS filesystems.") can be
removed.

Link: http://lkml.kernel.org/r/20170103182234.30141-2-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/write.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/nfs/write.c~nfs-no-pg_private-waiters-remain-remove-waker fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-no-pg_private-waiters-remain-remove-waker
+++ a/fs/nfs/write.c
@@ -728,8 +728,6 @@ static void nfs_inode_remove_request(str
 		if (likely(head->wb_page && !PageSwapCache(head->wb_page))) {
 			set_page_private(head->wb_page, 0);
 			ClearPagePrivate(head->wb_page);
-			smp_mb__after_atomic();
-			wake_up_page(head->wb_page, PG_private);
 			clear_bit(PG_MAPPED, &head->wb_flags);
 		}
 		nfsi->nrequests--;
_

Patches currently in -mm which might be from npiggin@gmail.com are

nfs-no-pg_private-waiters-remain-remove-waker.patch
mm-un-export-wake_up_page-functions.patch

