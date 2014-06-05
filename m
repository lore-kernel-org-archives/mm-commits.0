From: akpm@linux-foundation.org
Subject: [merged] printk-report-dropping-of-messages-from-logbuf.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 13:05:01 -0700
Message-ID: <5390cd6d.7AojNsDMHhtasAIf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaFEUFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:05:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, kay@vrfy.org, jack@suse.cz, will.deacon@arm.com

Subject: [merged] printk-report-dropping-of-messages-from-logbuf.patch removed from -mm tree
To: will.deacon@arm.com,jack@suse.cz,kay@vrfy.org,peterz@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:05:01 -0700


The patch titled
     Subject: printk: report dropping of messages from logbuf
has been removed from the -mm tree.  Its filename was
     printk-report-dropping-of-messages-from-logbuf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: printk: report dropping of messages from logbuf

If the log ring buffer becomes full, we silently overwrite old messages
with new data.  console_unlock will detect this case and fast-forward the
console_* pointers to skip over the corrupted data, but nothing will be
reported to the user.

This patch hijacks the first valid log message after detecting that we
dropped messages and prefixes it with a note detailing how many messages
were dropped.  For long (~1000 char) messages, this will result in some
truncation of the real message, but given that we're dropping things
anyway, that doesn't seem to be the end of the world.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN kernel/printk/printk.c~printk-report-dropping-of-messages-from-logbuf kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-report-dropping-of-messages-from-logbuf
+++ a/kernel/printk/printk.c
@@ -2157,10 +2157,15 @@ again:
 		}
 
 		if (console_seq < log_first_seq) {
+			len = sprintf(text, "** %u printk messages dropped ** ",
+				      (unsigned)(log_first_seq - console_seq));
+
 			/* messages are gone, move to first one */
 			console_seq = log_first_seq;
 			console_idx = log_first_idx;
 			console_prev = 0;
+		} else {
+			len = 0;
 		}
 skip:
 		if (console_seq == log_next_seq)
@@ -2185,8 +2190,8 @@ skip:
 		}
 
 		level = msg->level;
-		len = msg_print_text(msg, console_prev, false,
-				     text, sizeof(text));
+		len += msg_print_text(msg, console_prev, false,
+				      text + len, sizeof(text) - len);
 		console_idx = log_next(console_idx);
 		console_seq++;
 		console_prev = msg->flags;
_

Patches currently in -mm which might be from will.deacon@arm.com are

origin.patch
documentation-devicetree-bindings-add-documentation-for-the-apm-x-gene-soc-rtc-dts-binding.patch
drivers-rtc-add-apm-x-gene-soc-rtc-driver.patch
arm64-add-apm-x-gene-soc-rtc-dts-entry.patch
linux-next.patch

