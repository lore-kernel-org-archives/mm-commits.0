From: akpm@linux-foundation.org
Subject: [merged] power-wakeup-remove-use-of-seq_printf-return-value.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:55:13 -0700
Message-ID: <552fe971.KvDqF6LS6MirOeJO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbDPQto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregkh@linuxfoundation.org, len.brown@intel.com, pavel@ucw.cz, rjw@rjwysocki.net, mm-commits@vger.kernel.org


The patch titled
     Subject: power: wakeup: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     power-wakeup-remove-use-of-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: power: wakeup: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <len.brown@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/wakeup.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/base/power/wakeup.c~power-wakeup-remove-use-of-seq_printf-return-value drivers/base/power/wakeup.c
--- a/drivers/base/power/wakeup.c~power-wakeup-remove-use-of-seq_printf-return-value
+++ a/drivers/base/power/wakeup.c
@@ -843,7 +843,6 @@ static int print_wakeup_source_stats(str
 	unsigned long active_count;
 	ktime_t active_time;
 	ktime_t prevent_sleep_time;
-	int ret;
 
 	spin_lock_irqsave(&ws->lock, flags);
 
@@ -866,17 +865,16 @@ static int print_wakeup_source_stats(str
 		active_time = ktime_set(0, 0);
 	}
 
-	ret = seq_printf(m, "%-12s\t%lu\t\t%lu\t\t%lu\t\t%lu\t\t"
-			"%lld\t\t%lld\t\t%lld\t\t%lld\t\t%lld\n",
-			ws->name, active_count, ws->event_count,
-			ws->wakeup_count, ws->expire_count,
-			ktime_to_ms(active_time), ktime_to_ms(total_time),
-			ktime_to_ms(max_time), ktime_to_ms(ws->last_time),
-			ktime_to_ms(prevent_sleep_time));
+	seq_printf(m, "%-12s\t%lu\t\t%lu\t\t%lu\t\t%lu\t\t%lld\t\t%lld\t\t%lld\t\t%lld\t\t%lld\n",
+		   ws->name, active_count, ws->event_count,
+		   ws->wakeup_count, ws->expire_count,
+		   ktime_to_ms(active_time), ktime_to_ms(total_time),
+		   ktime_to_ms(max_time), ktime_to_ms(ws->last_time),
+		   ktime_to_ms(prevent_sleep_time));
 
 	spin_unlock_irqrestore(&ws->lock, flags);
 
-	return ret;
+	return 0;
 }
 
 /**
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
checkpatch-add-define-foo-string-long-line-exception.patch
checkpatch-add-uart_ops-to-normally-const-structs.patch
checkpatch-add-prefer-array_size-test.patch
checkpatch-improve-operator-spacing-check.patch
checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
checkpatchpl-new-instances-of-enosys-are-errors.patch
errnoh-improve-enosyss-comment.patch
checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch
checkpatch-avoid-spaces-required-around-that-false-positive.patch
rtc-use-more-standard-kernel-logging-styles.patch
adfs-returning-correct-return-values.patch
linux-next.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

