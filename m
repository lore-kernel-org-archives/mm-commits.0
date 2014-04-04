From: akpm@linux-foundation.org
Subject: [merged] printk-use-also-the-last-bytes-in-the-ring-buffer.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:32:52 -0700
Message-ID: <533f08e4.ztcCJksJhX4gJW21%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbaDDTcx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, mhocko@suse.cz, kay@vrfy.org, jack@suse.cz, fweisbec@gmail.com, pmladek@suse.cz

Subject: [merged] printk-use-also-the-last-bytes-in-the-ring-buffer.patch removed from -mm tree
To: pmladek@suse.cz,fweisbec@gmail.com,jack@suse.cz,kay@vrfy.org,mhocko@suse.cz,rostedt@goodmis.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:52 -0700


The patch titled
     Subject: printk: use also the last bytes in the ring buffer
has been removed from the -mm tree.  Its filename was
     printk-use-also-the-last-bytes-in-the-ring-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

