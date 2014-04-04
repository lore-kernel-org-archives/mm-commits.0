From: akpm@linux-foundation.org
Subject: [merged]
 printk-do-not-compute-the-size-of-the-message-twice.patch removed from -mm
 tree
Date: Fri, 04 Apr 2014 12:32:54 -0700
Message-ID: <533f08e6.evIRpxyB4MemVlmh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbaDDTcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, mhocko@suse.cz, kay@vrfy.org, jack@suse.cz, fweisbec@gmail.com, pmladek@suse.cz

Subject: [merged] printk-do-not-compute-the-size-of-the-message-twice.patch removed from -mm tree
To: pmladek@suse.cz,fweisbec@gmail.com,jack@suse.cz,kay@vrfy.org,mhocko@suse.cz,rostedt@goodmis.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:54 -0700


The patch titled
     Subject: printk: do not compute the size of the message twice
has been removed from the -mm tree.  Its filename was
     printk-do-not-compute-the-size-of-the-message-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

