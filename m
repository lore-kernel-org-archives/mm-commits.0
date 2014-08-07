From: akpm@linux-foundation.org
Subject: [merged] printk-tweak-do_syslog-to-match-comments.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:07:17 -0700
Message-ID: <53e3dc75.fzisakfQfxyDrQ7h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:62454 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbaHGUHS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:18 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1176774pab.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elder@linaro.org, jack@suse.cz, joe@perches.com, john.stultz@linaro.org, pmladek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: tweak do_syslog() to match comments
has been removed from the -mm tree.  Its filename was
     printk-tweak-do_syslog-to-match-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Elder <elder@linaro.org>
Subject: printk: tweak do_syslog() to match comments

In do_syslog() there's a path used by kmsg_poll() and kmsg_read() that
only needs to know whether there's any data available to read (and not its
size).  These callers only check for non-zero return.  As a shortcut,
do_syslog() returns the difference between what has been logged and what
has been "seen."

The comments say that the "count of records" should be returned but it's
not.  Instead it returns (log_next_idx - syslog_idx), which is a
difference between buffer offsets--and the result could be negative.

The behavior is the same (it'll be zero or not in the same cases), but the
count of records is more meaningful and it matches what the comments say. 
So change the code to return that.

Signed-off-by: Alex Elder <elder@linaro.org>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk/printk.c~printk-tweak-do_syslog-to-match-comments kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-tweak-do_syslog-to-match-comments
+++ a/kernel/printk/printk.c
@@ -1351,7 +1351,7 @@ int do_syslog(int type, char __user *buf
 			 * for pending data, not the size; return the count of
 			 * records, not the length.
 			 */
-			error = log_next_idx - syslog_idx;
+			error = log_next_seq - syslog_seq;
 		} else {
 			u64 seq = syslog_seq;
 			u32 idx = syslog_idx;
_

Patches currently in -mm which might be from elder@linaro.org are

origin.patch
linux-next.patch

