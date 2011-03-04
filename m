From: akpm@linux-foundation.org
Subject: [merged] fs-locksc-remove-stale-fixme-left-over-from-bkl-conversion.patch removed from -mm tree
Date: Fri, 04 Mar 2011 15:16:10 -0800
Message-ID: <201103042316.p24NGLTB009549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587Ab1CDXQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 18:16:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@linux.intel.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     fs/locks.c: remove stale FIXME left over from BKL conversion
has been removed from the -mm tree.  Its filename was
     fs-locksc-remove-stale-fixme-left-over-from-bkl-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/locks.c: remove stale FIXME left over from BKL conversion
From: Matt Fleming <matt.fleming@linux.intel.com>

The comment is no longer true as (now that the BKL conversion is finished)
a spinlock _is_ now used to protect file_lock_list, blocked_list and
inode->i_flock.

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/locks.c~fs-locksc-remove-stale-fixme-left-over-from-bkl-conversion fs/locks.c
--- a/fs/locks.c~fs-locksc-remove-stale-fixme-left-over-from-bkl-conversion
+++ a/fs/locks.c
@@ -145,7 +145,6 @@ static DEFINE_SPINLOCK(file_lock_lock);
 
 /*
  * Protects the two list heads above, plus the inode->i_flock list
- * FIXME: should use a spinlock, once lockd and ceph are ready.
  */
 void lock_flocks(void)
 {
_

Patches currently in -mm which might be from matt.fleming@linux.intel.com are

linux-next.patch

