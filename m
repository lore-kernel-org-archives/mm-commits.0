From: akpm@linux-foundation.org
Subject: [merged] kdb-remove-unused-kdb_event-handling.patch removed from
 -mm tree
Date: Thu, 15 Dec 2016 10:46:22 -0800
Message-ID: <5852e4fe.ailDcKYaoQDcayTq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48820 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752381AbcLOSqv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:46:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, daniel.thompson@linaro.org, jason.wessel@windriver.com, peterz@infradead.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdb: remove unused kdb_event handling
has been removed from the -mm tree.  Its filename was
     kdb-remove-unused-kdb_event-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: kdb: remove unused kdb_event handling

kdb_event state variable is only set but never checked in the kernel code.

http://www.spinics.net/lists/kdb/msg01733.html suggests that this variable
affected WARN_CONSOLE_UNLOCKED() in the original implementation.  But this
check never went upstream.

The semantic is unclear and racy.  The value is updated after the
kdb_printf_lock is acquired and after it is released.  It should be
symmetric at minimum.  The value should be manipulated either inside or
outside the locked area.

Fortunately, it seems that the original function is gone and we could
simply remove the state variable.

Link: http://lkml.kernel.org/r/1480412276-16690-2-git-send-email-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kdb.h         |    1 -
 kernel/debug/kdb/kdb_io.c   |    2 --
 kernel/debug/kdb/kdb_main.c |    1 -
 3 files changed, 4 deletions(-)

diff -puN include/linux/kdb.h~kdb-remove-unused-kdb_event-handling include/linux/kdb.h
--- a/include/linux/kdb.h~kdb-remove-unused-kdb_event-handling
+++ a/include/linux/kdb.h
@@ -77,7 +77,6 @@ extern int kdb_poll_idx;
  * number whenever the kernel debugger is entered.
  */
 extern int kdb_initial_cpu;
-extern atomic_t kdb_event;
 
 /* Types and messages used for dynamically added kdb shell commands */
 
diff -puN kernel/debug/kdb/kdb_io.c~kdb-remove-unused-kdb_event-handling kernel/debug/kdb/kdb_io.c
--- a/kernel/debug/kdb/kdb_io.c~kdb-remove-unused-kdb_event-handling
+++ a/kernel/debug/kdb/kdb_io.c
@@ -576,7 +576,6 @@ int vkdb_printf(enum kdb_msgsrc src, con
 		KDB_STATE_SET(PRINTF_LOCK);
 		spin_lock_irqsave(&kdb_printf_lock, flags);
 		got_printf_lock = 1;
-		atomic_inc(&kdb_event);
 	} else {
 		__acquire(kdb_printf_lock);
 	}
@@ -851,7 +850,6 @@ kdb_print_out:
 		got_printf_lock = 0;
 		spin_unlock_irqrestore(&kdb_printf_lock, flags);
 		KDB_STATE_CLEAR(PRINTF_LOCK);
-		atomic_dec(&kdb_event);
 	} else {
 		__release(kdb_printf_lock);
 	}
diff -puN kernel/debug/kdb/kdb_main.c~kdb-remove-unused-kdb_event-handling kernel/debug/kdb/kdb_main.c
--- a/kernel/debug/kdb/kdb_main.c~kdb-remove-unused-kdb_event-handling
+++ a/kernel/debug/kdb/kdb_main.c
@@ -60,7 +60,6 @@ int kdb_grep_trailing;
  * Kernel debugger state flags
  */
 int kdb_flags;
-atomic_t kdb_event;
 
 /*
  * kdb_lock protects updates to kdb_initial_cpu.  Used to
_

Patches currently in -mm which might be from pmladek@suse.com are


