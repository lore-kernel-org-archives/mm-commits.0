From: akpm@linux-foundation.org
Subject: - printkc-use-unsigned-ints-instead-of-longs-for-logbuf-index.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:44 -0800
Message-ID: <200802070022.m170MPqf006419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934128AbYBGAoW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     printk.c: use unsigned ints instead of longs for logbuf index
has been removed from the -mm tree.  Its filename was
     printkc-use-unsigned-ints-instead-of-longs-for-logbuf-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk.c: use unsigned ints instead of longs for logbuf index
From: Denys Vlasenko <vda.linux@googlemail.com>

Stop using unsigned _longs_ for printk buffer indexes.  Log buffer is way
smaller than 2 gigabytes and unsigned ints will work too .  Indeed, they do
work nicely on all 32-bit platforms where longs and ints are the same.

With this patch, we have following size savings on amd64:

   text    data     bss     dec     hex filename
   5997     313   17736   24046    5dee 2.6.23.1.t64/kernel/printk.o
   5858     313   17700   23871    5d3f 2.6.23.1.printk.t64/kernel/printk.o

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN kernel/printk.c~printkc-use-unsigned-ints-instead-of-longs-for-logbuf-index kernel/printk.c
--- a/kernel/printk.c~printkc-use-unsigned-ints-instead-of-longs-for-logbuf-index
+++ a/kernel/printk.c
@@ -93,16 +93,16 @@ static int console_locked, console_suspe
  */
 static DEFINE_SPINLOCK(logbuf_lock);
 
-#define LOG_BUF_MASK	(log_buf_len-1)
+#define LOG_BUF_MASK (log_buf_len-1)
 #define LOG_BUF(idx) (log_buf[(idx) & LOG_BUF_MASK])
 
 /*
  * The indices into log_buf are not constrained to log_buf_len - they
  * must be masked before subscripting
  */
-static unsigned long log_start;	/* Index into log_buf: next char to be read by syslog() */
-static unsigned long con_start;	/* Index into log_buf: next char to be sent to consoles */
-static unsigned long log_end;	/* Index into log_buf: most-recently-written-char + 1 */
+static unsigned log_start;	/* Index into log_buf: next char to be read by syslog() */
+static unsigned con_start;	/* Index into log_buf: next char to be sent to consoles */
+static unsigned log_end;	/* Index into log_buf: most-recently-written-char + 1 */
 
 /*
  *	Array of consoles built from command line options (console=)
@@ -128,17 +128,17 @@ static int console_may_schedule;
 static char __log_buf[__LOG_BUF_LEN];
 static char *log_buf = __log_buf;
 static int log_buf_len = __LOG_BUF_LEN;
-static unsigned long logged_chars; /* Number of chars produced since last read+clear operation */
+static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
 
 static int __init log_buf_len_setup(char *str)
 {
-	unsigned long size = memparse(str, &str);
+	unsigned size = memparse(str, &str);
 	unsigned long flags;
 
 	if (size)
 		size = roundup_pow_of_two(size);
 	if (size > log_buf_len) {
-		unsigned long start, dest_idx, offset;
+		unsigned start, dest_idx, offset;
 		char *new_log_buf;
 
 		new_log_buf = alloc_bootmem(size);
@@ -295,7 +295,7 @@ int log_buf_read(int idx)
  */
 int do_syslog(int type, char __user *buf, int len)
 {
-	unsigned long i, j, limit, count;
+	unsigned i, j, limit, count;
 	int do_clear = 0;
 	char c;
 	int error = 0;
@@ -436,7 +436,7 @@ asmlinkage long sys_syslog(int type, cha
 /*
  * Call the console drivers on a range of log_buf
  */
-static void __call_console_drivers(unsigned long start, unsigned long end)
+static void __call_console_drivers(unsigned start, unsigned end)
 {
 	struct console *con;
 
@@ -463,8 +463,8 @@ early_param("ignore_loglevel", ignore_lo
 /*
  * Write out chars from start to end - 1 inclusive
  */
-static void _call_console_drivers(unsigned long start,
-				unsigned long end, int msg_log_level)
+static void _call_console_drivers(unsigned start,
+				unsigned end, int msg_log_level)
 {
 	if ((msg_log_level < console_loglevel || ignore_loglevel) &&
 			console_drivers && start != end) {
@@ -484,12 +484,12 @@ static void _call_console_drivers(unsign
  * log_buf[start] to log_buf[end - 1].
  * The console_sem must be held.
  */
-static void call_console_drivers(unsigned long start, unsigned long end)
+static void call_console_drivers(unsigned start, unsigned end)
 {
-	unsigned long cur_index, start_print;
+	unsigned cur_index, start_print;
 	static int msg_level = -1;
 
-	BUG_ON(((long)(start - end)) > 0);
+	BUG_ON(((int)(start - end)) > 0);
 
 	cur_index = start;
 	start_print = start;
@@ -790,7 +790,7 @@ asmlinkage long sys_syslog(int type, cha
 	return -ENOSYS;
 }
 
-static void call_console_drivers(unsigned long start, unsigned long end)
+static void call_console_drivers(unsigned start, unsigned end)
 {
 }
 
@@ -983,8 +983,8 @@ void wake_up_klogd(void)
 void release_console_sem(void)
 {
 	unsigned long flags;
-	unsigned long _con_start, _log_end;
-	unsigned long wake_klogd = 0;
+	unsigned _con_start, _log_end;
+	unsigned wake_klogd = 0;
 
 	if (console_suspended) {
 		up(&secondary_console_sem);
@@ -1275,7 +1275,7 @@ void tty_write_message(struct tty_struct
 int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst)
 {
 	static DEFINE_SPINLOCK(ratelimit_lock);
-	static unsigned long toks = 10 * 5 * HZ;
+	static unsigned toks = 10 * 5 * HZ;
 	static unsigned long last_msg;
 	static int missed;
 	unsigned long flags;
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

origin.patch
git-x86.patch
