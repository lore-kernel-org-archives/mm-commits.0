From: akpm@linux-foundation.org
Subject: [merged] printk-fix-some-comments.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:07:21 -0700
Message-ID: <53e3dc79.BegZLwAQTtXSAX+/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:50209 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbaHGUHW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:22 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so844227obc.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elder@linaro.org, ak@linux.intel.com, bp@suse.de, jack@suse.cz, john.stultz@linaro.org, pmladek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: fix some comments
has been removed from the -mm tree.  Its filename was
     printk-fix-some-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Elder <elder@linaro.org>
Subject: printk: fix some comments

Fix a few comments that don't accurately describe their corresponding
code.  It also fixes some minor typographical errors.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Jan Kara <jack@suse.cz>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN kernel/printk/printk.c~printk-fix-some-comments kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-fix-some-comments
+++ a/kernel/printk/printk.c
@@ -113,9 +113,9 @@ static int __down_trylock_console_sem(un
  * This is used for debugging the mess that is the VT code by
  * keeping track if we have the console semaphore held. It's
  * definitely not the perfect debug tool (we don't know if _WE_
- * hold it are racing, but it helps tracking those weird code
- * path in the console code where we end up in places I want
- * locked without the console sempahore held
+ * hold it and are racing, but it helps tracking those weird code
+ * paths in the console code where we end up in places I want
+ * locked without the console sempahore held).
  */
 static int console_locked, console_suspended;
 
@@ -146,8 +146,8 @@ static int console_may_schedule;
  * the overall length of the record.
  *
  * The heads to the first and last entry in the buffer, as well as the
- * sequence numbers of these both entries are maintained when messages
- * are stored..
+ * sequence numbers of these entries are maintained when messages are
+ * stored.
  *
  * If the heads indicate available messages, the length in the header
  * tells the start next message. A length == 0 for the next message
@@ -345,7 +345,7 @@ static int log_make_free_space(u32 msg_s
 	while (log_first_seq < log_next_seq) {
 		if (logbuf_has_space(msg_size, false))
 			return 0;
-		/* drop old messages until we have enough continuous space */
+		/* drop old messages until we have enough contiguous space */
 		log_first_idx = log_next(log_first_idx);
 		log_first_seq++;
 	}
@@ -1517,7 +1517,7 @@ static struct cont {
 	struct task_struct *owner;	/* task of first print*/
 	u64 ts_nsec;			/* time of first print */
 	u8 level;			/* log level of first message */
-	u8 facility;			/* log level of first message */
+	u8 facility;			/* log facility of first message */
 	enum log_flags flags;		/* prefix, newline flags */
 	bool flushed:1;			/* buffer sealed and committed */
 } cont;
@@ -1922,11 +1922,12 @@ static int __add_preferred_console(char
 	return 0;
 }
 /*
- * Set up a list of consoles.  Called from init/main.c
+ * Set up a console.  Called via do_early_param() in init/main.c
+ * for each "console=" parameter in the boot command line.
  */
 static int __init console_setup(char *str)
 {
-	char buf[sizeof(console_cmdline[0].name) + 4]; /* 4 for index */
+	char buf[sizeof(console_cmdline[0].name) + 4]; /* 4 for "ttyS" */
 	char *s, *options, *brl_options = NULL;
 	int idx;
 
@@ -2086,8 +2087,8 @@ EXPORT_SYMBOL(console_lock);
 /**
  * console_trylock - try to lock the console system for exclusive use.
  *
- * Tried to acquire a lock which guarantees that the caller has
- * exclusive access to the console system and the console_drivers list.
+ * Try to acquire a lock which guarantees that the caller has exclusive
+ * access to the console system and the console_drivers list.
  *
  * returns 1 on success, and 0 on failure to acquire the lock.
  */
_

Patches currently in -mm which might be from elder@linaro.org are

origin.patch
linux-next.patch

