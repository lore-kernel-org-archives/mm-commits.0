From: akpm@linux-foundation.org
Subject: + printk-use-also-the-last-bytes-in-the-ring-buffer.patch added
 to -mm tree
Date: Tue, 18 Feb 2014 13:03:45 -0800
Message-ID: <5303cab1.Ym3Yw38hi9r6E6nu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaBRVDq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 16:03:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, mhocko@suse.cz, kay@vrfy.org, jack@suse.cz, fweisbec@gmail.com, pmladek@suse.cz

Subject: + printk-use-also-the-last-bytes-in-the-ring-buffer.patch added to -mm tree
To: pmladek@suse.cz,fweisbec@gmail.com,jack@suse.cz,kay@vrfy.org,mhocko@suse.cz,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 13:03:45 -0800


The patch titled
     Subject: printk: use also the last bytes in the ring buffer
has been added to the -mm tree.  Its filename is
     printk-use-also-the-last-bytes-in-the-ring-buffer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-use-also-the-last-bytes-in-the-ring-buffer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-use-also-the-last-bytes-in-the-ring-buffer.patch

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
Subject: printk: use also the last bytes in the ring buffer

It seems that we have newer used the last byte in the ring buffer.  In
fact, we have newer used the last 4 bytes because of padding.

First problem is in the check for free space.  The exact number of free
bytes is enough to store the length of data.

Second problem is in the check where the ring buffer is rotated.  The left
side counts the first unused index.  It is unused, so it might be the same
as the size of the buffer.

Note that the first problem has to be fixed together with the second one. 
Otherwise, the buffer is rotated even when there is enough space on the
end of the buffer.  Then the beginning of the buffer is rewritten and
valid entries get corrupted.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/printk/printk.c~printk-use-also-the-last-bytes-in-the-ring-buffer kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-use-also-the-last-bytes-in-the-ring-buffer
+++ a/kernel/printk/printk.c
@@ -319,7 +319,7 @@ static void log_store(int facility, int
 		else
 			free = log_first_idx - log_next_idx;
 
-		if (free > size + sizeof(struct printk_log))
+		if (free >= size + sizeof(struct printk_log))
 			break;
 
 		/* drop old messages until we have enough contiuous space */
@@ -327,7 +327,7 @@ static void log_store(int facility, int
 		log_first_seq++;
 	}
 
-	if (log_next_idx + size + sizeof(struct printk_log) >= log_buf_len) {
+	if (log_next_idx + size + sizeof(struct printk_log) > log_buf_len) {
 		/*
 		 * This message + an additional empty header does not fit
 		 * at the end of the buffer. Add an empty header with len == 0
_

Patches currently in -mm which might be from pmladek@suse.cz are

printk-remove-duplicated-check-for-log-level.patch
printk-remove-obsolete-check-for-log-level-c.patch
printk-add-comment-about-tricky-check-for-text-buffer-size.patch
printk-use-also-the-last-bytes-in-the-ring-buffer.patch
printk-do-not-compute-the-size-of-the-message-twice.patch

