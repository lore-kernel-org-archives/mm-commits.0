From: akpm@linux-foundation.org
Subject: + printk-do-not-compute-the-size-of-the-message-twice.patch added to -mm tree
Date: Tue, 18 Feb 2014 13:03:46 -0800
Message-ID: <5303cab2.a08cne63dR4w9bJK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaBRVDr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 16:03:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, mhocko@suse.cz, kay@vrfy.org, jack@suse.cz, fweisbec@gmail.com, pmladek@suse.cz

Subject: + printk-do-not-compute-the-size-of-the-message-twice.patch added to -mm tree
To: pmladek@suse.cz,fweisbec@gmail.com,jack@suse.cz,kay@vrfy.org,mhocko@suse.cz,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 13:03:46 -0800


The patch titled
     Subject: printk: do not compute the size of the message twice
has been added to the -mm tree.  Its filename is
     printk-do-not-compute-the-size-of-the-message-twice.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-do-not-compute-the-size-of-the-message-twice.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-do-not-compute-the-size-of-the-message-twice.patch

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
Subject: printk: do not compute the size of the message twice

This is just a tiny optimization.  It removes duplicate computation of the
message size.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk/printk.c~printk-do-not-compute-the-size-of-the-message-twice kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-do-not-compute-the-size-of-the-message-twice
+++ a/kernel/printk/printk.c
@@ -351,7 +351,7 @@ static void log_store(int facility, int
 	else
 		msg->ts_nsec = local_clock();
 	memset(log_dict(msg) + dict_len, 0, pad_len);
-	msg->len = sizeof(struct printk_log) + text_len + dict_len + pad_len;
+	msg->len = size;
 
 	/* insert message */
 	log_next_idx += msg->len;
_

Patches currently in -mm which might be from pmladek@suse.cz are

printk-remove-duplicated-check-for-log-level.patch
printk-remove-obsolete-check-for-log-level-c.patch
printk-add-comment-about-tricky-check-for-text-buffer-size.patch
printk-use-also-the-last-bytes-in-the-ring-buffer.patch
printk-do-not-compute-the-size-of-the-message-twice.patch

