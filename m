From: akpm@linux-foundation.org
Subject: +
 lib-spinlock_debugc-prevent-an-infinite-recursive-cycle-in-spin_dump.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 16:12:52 -0800
Message-ID: <56a80b84.OHhjyfz52dk/E3qw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbcA0AMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 19:12:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: byungchul.park@lge.com, akinobu.mita@gmail.com, jack@suse.cz, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/spinlock_debug.c: prevent an infinite recursive cycle in spin_dump()
has been added to the -mm tree.  Its filename is
     lib-spinlock_debugc-prevent-an-infinite-recursive-cycle-in-spin_dump.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-spinlock_debugc-prevent-an-infinite-recursive-cycle-in-spin_dump.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-spinlock_debugc-prevent-an-infinite-recursive-cycle-in-spin_dump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Byungchul Park <byungchul.park@lge.com>
Subject: lib/spinlock_debug.c: prevent an infinite recursive cycle in spin_dump()

There is an infinite recursive cycle when using CONFIG_DEBUG_SPINLOCK, in
spin_dump().  Backtrace prints printk() -> console_trylock() ->
do_raw_spin_lock() -> spin_bug() -> spin_dump() -> printk()... 
infinitely.

If the spin_bug() is called from a function like printk() which is trying
to obtain the console lock, we should prevent the debug spinlock code from
calling printk() again in that context.

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/locking/spinlock_debug.c |   11 +++++++++++
 kernel/printk/printk.c          |    5 +++++
 2 files changed, 16 insertions(+)

diff -puN kernel/locking/spinlock_debug.c~lib-spinlock_debugc-prevent-an-infinite-recursive-cycle-in-spin_dump kernel/locking/spinlock_debug.c
--- a/kernel/locking/spinlock_debug.c~lib-spinlock_debugc-prevent-an-infinite-recursive-cycle-in-spin_dump
+++ a/kernel/locking/spinlock_debug.c
@@ -67,11 +67,22 @@ static void spin_dump(raw_spinlock_t *lo
 	dump_stack();
 }
 
+extern int is_console_lock(raw_spinlock_t *lock);
+
 static void spin_bug(raw_spinlock_t *lock, const char *msg)
 {
 	if (!debug_locks_off())
 		return;
 
+	/*
+	 * If this function is called from a function like printk()
+	 * which is trying to obtain the console lock, then we should
+	 * not call printk() any more. Or it will cause an infinite
+	 * recursive cycle!
+	 */
+	if (unlikely(is_console_lock(lock)))
+		return;
+
 	spin_dump(lock, msg);
 }
 
diff -puN kernel/printk/printk.c~lib-spinlock_debugc-prevent-an-infinite-recursive-cycle-in-spin_dump kernel/printk/printk.c
--- a/kernel/printk/printk.c~lib-spinlock_debugc-prevent-an-infinite-recursive-cycle-in-spin_dump
+++ a/kernel/printk/printk.c
@@ -120,6 +120,11 @@ static int __down_trylock_console_sem(un
 	up(&console_sem);\
 } while (0)
 
+int is_console_lock(raw_spinlock_t *lock)
+{
+	return &console_sem.lock == lock;
+}
+
 /*
  * This is used for debugging the mess that is the VT code by
  * keeping track if we have the console semaphore held. It's
_

Patches currently in -mm which might be from byungchul.park@lge.com are

lib-spinlock_debugc-prevent-an-infinite-recursive-cycle-in-spin_dump.patch

