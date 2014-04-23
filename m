From: akpm@linux-foundation.org
Subject: + printk-remove-outdated-comment.patch added to -mm tree
Date: Wed, 23 Apr 2014 13:58:49 -0700
Message-ID: <53582989.yEOxj4dvBBvwL+sH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbaDWU6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Apr 2014 16:58:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz

Subject: + printk-remove-outdated-comment.patch added to -mm tree
To: jack@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 23 Apr 2014 13:58:49 -0700


The patch titled
     Subject: printk: remove outdated comment
has been added to the -mm tree.  Its filename is
     printk-remove-outdated-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-remove-outdated-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-remove-outdated-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: printk: remove outdated comment

Comment about interesting interlocking between lockbuf_lock and
console_sem is outdated.

It was added in 2002 by commit a880f45a48be2956d2c78a839c472287d54435c1
during conversion of console_lock to console_sem + lockbuf_lock.

At that time release_console_sem() (today's equivalent is
console_unlock()) was indeed using lockbuf_lock to avoid races between
trylock on console_sem in printk() and unlock of console_sem.  However
these days the interlocking is gone and the races are avoided by
rechecking logbuf state after releasing console_sem.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/printk/printk.c~printk-remove-outdated-comment kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-remove-outdated-comment
+++ a/kernel/printk/printk.c
@@ -206,8 +206,7 @@ struct printk_log {
 };
 
 /*
- * The logbuf_lock protects kmsg buffer, indices, counters. It is also
- * used in interesting ways to provide interlocking in console_unlock();
+ * The logbuf_lock protects kmsg buffer, indices, counters.
  */
 static DEFINE_RAW_SPINLOCK(logbuf_lock);
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path.patch
fanotify-create-fan_access-event-for-readdir.patch
fs-notify-markc-trivial-cleanup.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
printk-split-code-for-making-free-space-in-the-log-buffer.patch
printk-ignore-too-long-messages.patch
printk-split-message-size-computation.patch
printk-shrink-too-long-messages.patch
printk-return-really-stored-message-length.patch
printk-remove-outdated-comment.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
printk-enable-interrupts-before-calling-console_trylock_for_printk.patch
printk-remove-separate-printk_sched-buffers-and-use-printk-buf-instead.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

