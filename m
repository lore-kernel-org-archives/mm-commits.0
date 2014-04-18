From: akpm@linux-foundation.org
Subject: + printk-split-code-for-making-free-space-in-the-log-buffer.patch added to -mm tree
Date: Fri, 18 Apr 2014 12:03:47 -0700
Message-ID: <53517713.ZEz/mRYk+obEcJZw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaDRTDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 15:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kay@vrfy.org, jkosina@suse.cz, jack@suse.cz, pmladek@suse.cz

Subject: + printk-split-code-for-making-free-space-in-the-log-buffer.patch added to -mm tree
To: pmladek@suse.cz,jack@suse.cz,jkosina@suse.cz,kay@vrfy.org
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 12:03:47 -0700


The patch titled
     Subject: printk: split code for making free space in the log buffer
has been added to the -mm tree.  Its filename is
     printk-split-code-for-making-free-space-in-the-log-buffer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-split-code-for-making-free-space-in-the-log-buffer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-split-code-for-making-free-space-in-the-log-buffer.patch

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
Subject: printk: split code for making free space in the log buffer

The check for free space in the log buffer always passes when "first_seq"
and "next_seq" are equal.  In theory, it might cause writing outside of
the log buffer.

Fortunately, the current usage looks safe because the used "text" and
"dict" buffers are quite limited.  See the second patch for more details.

Anyway, it is better to be on the safe side and add a check.  An easy
solution is done in the 2nd patch and it is improved in the 4th patch.

5th patch fixes the computation of the printed message length.

1st and 3rd patches just do some code refactoring to make the other
patches easier.



This patch (of 5):

There will be needed some fixes in the check for free space.  They will be
easier if the code is moved outside of the quite long log_store()
function.

This patch does not change the existing behavior.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   44 +++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff -puN kernel/printk/printk.c~printk-split-code-for-making-free-space-in-the-log-buffer kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-split-code-for-making-free-space-in-the-log-buffer
+++ a/kernel/printk/printk.c
@@ -297,6 +297,34 @@ static u32 log_next(u32 idx)
 	return idx + msg->len;
 }
 
+/* check whether there is enough free space for the given message */
+static int logbuf_has_space(u32 msg_size)
+{
+	u32 free;
+
+	if (log_next_idx > log_first_idx)
+		free = max(log_buf_len - log_next_idx, log_first_idx);
+	else
+		free = log_first_idx - log_next_idx;
+
+	/*
+	 * We need space also for an empty header that signalizes wrapping
+	 * of the buffer.
+	 */
+	return free >= msg_size + sizeof(struct printk_log);
+}
+
+static void log_make_free_space(u32 msg_size)
+{
+	while (log_first_seq < log_next_seq) {
+		if (logbuf_has_space(msg_size))
+			return;
+		/* drop old messages until we have enough continuous space */
+		log_first_idx = log_next(log_first_idx);
+		log_first_seq++;
+	}
+}
+
 /* insert record into the buffer, discard old ones, update heads */
 static void log_store(int facility, int level,
 		      enum log_flags flags, u64 ts_nsec,
@@ -311,21 +339,7 @@ static void log_store(int facility, int
 	pad_len = (-size) & (LOG_ALIGN - 1);
 	size += pad_len;
 
-	while (log_first_seq < log_next_seq) {
-		u32 free;
-
-		if (log_next_idx > log_first_idx)
-			free = max(log_buf_len - log_next_idx, log_first_idx);
-		else
-			free = log_first_idx - log_next_idx;
-
-		if (free >= size + sizeof(struct printk_log))
-			break;
