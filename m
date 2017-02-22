From: akpm@linux-foundation.org
Subject: [patch 098/142] nfs: no PG_private waiters remain, remove waker
Date: Wed, 22 Feb 2017 15:44:39 -0800
Message-ID: <58ae2267.O+bmTAXFP/Y7MUcH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49096 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933134AbdBVXok (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:44:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, npiggin@gmail.com, anna.schumaker@netapp.com, trond.myklebust@primarydata.com

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
