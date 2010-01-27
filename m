From: akpm@linux-foundation.org
Subject: + futex_lock_pi-key-refcnt-fix.patch added to -mm tree
Date: Wed, 27 Jan 2010 15:26:00 -0800
Message-ID: <201001272326.o0RNQ1kv006467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755195Ab0A0X1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 18:27:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikpe@it.uu.se, a.p.zijlstra@chello.nl, dvhltc@us.ibm.com, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de


The patch titled
     futex_lock_pi() key refcnt fix
has been added to the -mm tree.  Its filename is
     futex_lock_pi-key-refcnt-fix.patch

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
Subject: futex_lock_pi() key refcnt fix
From: Mikael Pettersson <mikpe@it.uu.se>

This fixes a futex key reference count bug in futex_lock_pi(), where a
key's reference count is incremented twice but decremented only once,
causing the backing object to not be released.

If the futex is created in a temporary file in an ext3 file system, this
bug causes the file's inode to become an "undead" orphan, which causes an
oops from a BUG_ON() in ext3_put_super() when the file system is
unmounted.  glibc's test suite is known to trigger this, see
<http://bugzilla.kernel.org/show_bug.cgi?id=14256>.

The bug is a regression from 2.6.28-git3, namely Peter Zijlstra's
38d47c1b7075bd7ec3881141bb3629da58f88dab "[PATCH] futex: rely on
get_user_pages() for shared futexes".  That commit made get_futex_key()
also increment the reference count of the futex key, and updated its
callers to decrement the key's reference count before returning. 
Unfortunately the normal exit path in futex_lock_pi() wasn't corrected:
the reference count is incremented by get_futex_key() and queue_lock(),
but the normal exit path only decrements once, via unqueue_me_pi().  The
fix is to put_futex_key() after unqueue_me_pi(), since 2.6.31 this is
easily done by 'goto out_put_key' rather than 'goto out'.

This patch also works for backports to 2.6.32 and 2.6.31, but 2.6.30 and
2.6.29 need a "put_futex_key(fshared, &q.key);" after "unqueue_me_pi(&q);"
instead.  I can supply patches for these older kernels if necessary.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Acked-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/futex.c~futex_lock_pi-key-refcnt-fix kernel/futex.c
--- a/kernel/futex.c~futex_lock_pi-key-refcnt-fix
+++ a/kernel/futex.c
@@ -1971,7 +1971,7 @@ retry_private:
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
 
-	goto out;
+	goto out_put_key;
 
 out_unlock_put_key:
 	queue_unlock(&q, hb);
_

Patches currently in -mm which might be from mikpe@it.uu.se are

futex_lock_pi-key-refcnt-fix.patch

