From: akpm@linux-foundation.org
Subject: + printk-remove-duplicated-check-for-log-level.patch added to -mm tree
Date: Tue, 18 Feb 2014 13:03:42 -0800
Message-ID: <5303caae.Mj7apr7af5gpAeAS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaBRVDn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 16:03:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, mhocko@suse.cz, kay@vrfy.org, jack@suse.cz, fweisbec@gmail.com, pmladek@suse.cz

Subject: + printk-remove-duplicated-check-for-log-level.patch added to -mm tree
To: pmladek@suse.cz,fweisbec@gmail.com,jack@suse.cz,kay@vrfy.org,mhocko@suse.cz,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 13:03:42 -0800


The patch titled
     Subject: printk: remove duplicated check for log level
has been added to the -mm tree.  Its filename is
     printk-remove-duplicated-check-for-log-level.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-remove-duplicated-check-for-log-level.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-remove-duplicated-check-for-log-level.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.cz>
Subject: printk: remove duplicated check for log level

The check for the exact log level is already done in printk_get_level.  We
do not need to duplicate it in printk_skip_level.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN include/linux/printk.h~printk-remove-duplicated-check-for-log-level include/linux/printk.h
--- a/include/linux/printk.h~printk-remove-duplicated-check-for-log-level
+++ a/include/linux/printk.h
@@ -24,13 +24,9 @@ static inline int printk_get_level(const
 
 static inline const char *printk_skip_level(const char *buffer)
 {
-	if (printk_get_level(buffer)) {
-		switch (buffer[1]) {
-		case '0' ... '7':
-		case 'd':	/* KERN_DEFAULT */
-			return buffer + 2;
-		}
-	}
+	if (printk_get_level(buffer))
+		return buffer + 2;
+
 	return buffer;
 }
 
_

Patches currently in -mm which might be from pmladek@suse.cz are

printk-remove-duplicated-check-for-log-level.patch
printk-remove-obsolete-check-for-log-level-c.patch
printk-add-comment-about-tricky-check-for-text-buffer-size.patch
printk-use-also-the-last-bytes-in-the-ring-buffer.patch
printk-do-not-compute-the-size-of-the-message-twice.patch

