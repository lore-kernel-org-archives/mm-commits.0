From: akpm@linux-foundation.org
Subject: + fs-locksc-remove-stale-fixme-left-over-from-bkl-conversion.patch added to -mm tree
Date: Tue, 01 Mar 2011 15:50:12 -0800
Message-ID: <201103012350.p21NoCC0006876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756534Ab1CAXut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2011 18:50:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matt.fleming@linux.intel.com, arnd@arndb.de


The patch titled
     fs/locks.c: remove stale FIXME left over from BKL conversion
has been added to the -mm tree.  Its filename is
     fs-locksc-remove-stale-fixme-left-over-from-bkl-conversion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/locks.c: remove stale FIXME left over from BKL conversion
From: Matt Fleming <matt.fleming@linux.intel.com>

The comment is no longer true as (now that the BKL conversion is finished)
a spinlock _is_ now used to protect file_lock_list, blocked_list and
inode->i_flock.

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
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

fs-locksc-remove-stale-fixme-left-over-from-bkl-conversion.patch

