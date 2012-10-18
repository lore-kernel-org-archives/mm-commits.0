From: akpm@linux-foundation.org
Subject: + printk-rename-log_buf-and-__log_buf_len.patch added to -mm tree
Date: Thu, 18 Oct 2012 16:16:37 -0700
Message-ID: <20121018231638.1C2D5100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:49121 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2JRXQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 19:16:39 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so1150412ggm.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 16:16:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, kay@vrfy.org


The patch titled
     Subject: printk: rename log_buf and __LOG_BUF_LEN
has been added to the -mm tree.  Its filename is
     printk-rename-log_buf-and-__log_buf_len.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: rename log_buf and __LOG_BUF_LEN

Make these generic names more specific to the printk
subsystem and allow these variables to become non-static.

Rename log_buf to printk_log_buf.
Rename __LOG_BUF_LEN define to __PRINTK_LOG_BUF_LEN.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   76 +++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff -puN kernel/printk/printk.c~printk-rename-log_buf-and-__log_buf_len kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-rename-log_buf-and-__log_buf_len
+++ a/kernel/printk/printk.c
@@ -243,10 +243,10 @@ static u32 clear_idx;
 #else
 #define LOG_ALIGN __alignof__(struct printk_log)
 #endif
-#define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
-static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
-static char *log_buf = __log_buf;
-static u32 log_buf_len = __LOG_BUF_LEN;
+#define __PRINTK_LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
+static char __printk_log_buf[__PRINTK_LOG_BUF_LEN] __aligned(LOG_ALIGN);
+static char *printk_log_buf = __printk_log_buf;
+static u32 printk_log_buf_len = __PRINTK_LOG_BUF_LEN;
 
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int logbuf_cpu = UINT_MAX;
@@ -266,21 +266,21 @@ static char *log_dict(const struct print
 /* get record by index; idx must point to valid msg */
 static struct printk_log *log_from_idx(u32 idx)
 {
-	struct printk_log *msg = (struct printk_log *)(log_buf + idx);
+	struct printk_log *msg = (struct printk_log *)(printk_log_buf + idx);
 
 	/*
 	 * A length == 0 record is the end of buffer marker. Wrap around and
 	 * read the message at the start of the buffer.
 	 */
 	if (!msg->len)
-		return (struct printk_log *)log_buf;
+		return (struct printk_log *)printk_log_buf;
 	return msg;
 }
 
 /* get next record; idx must point to valid msg */
 static u32 log_next(u32 idx)
 {
-	struct printk_log *msg = (struct printk_log *)(log_buf + idx);
+	struct printk_log *msg = (struct printk_log *)(printk_log_buf + idx);
 
 	/* length == 0 indicates the end of the buffer; wrap */
 	/*
@@ -289,7 +289,7 @@ static u32 log_next(u32 idx)
 	 * return the one after that.
 	 */
 	if (!msg->len) {
-		msg = (struct printk_log *)log_buf;
+		msg = (struct printk_log *)printk_log_buf;
 		return msg->len;
 	}
 	return idx + msg->len;
@@ -313,7 +313,7 @@ static void log_store(int facility, int 
 		u32 free;
 
 		if (log_next_idx > log_first_idx)
-			free = max(log_buf_len - log_next_idx, log_first_idx);
+			free = max(printk_log_buf_len - log_next_idx, log_first_idx);
 		else
 			free = log_first_idx - log_next_idx;
 
@@ -325,18 +325,18 @@ static void log_store(int facility, int 
 		log_first_seq++;
 	}
 
-	if (log_next_idx + size + sizeof(struct printk_log) >= log_buf_len) {
+	if (log_next_idx + size + sizeof(struct printk_log) >= printk_log_buf_len) {
 		/*
 		 * This message + an additional empty header does not fit
 		 * at the end of the buffer. Add an empty header with len == 0
 		 * to signify a wrap around.
 		 */
-		memset(log_buf + log_next_idx, 0, sizeof(struct printk_log));
+		memset(printk_log_buf + log_next_idx, 0, sizeof(struct printk_log));
 		log_next_idx = 0;
 	}
 
 	/* fill message */
-	msg = (struct printk_log *)(log_buf + log_next_idx);
+	msg = (struct printk_log *)(printk_log_buf + log_next_idx);
 	memcpy(log_text(msg), text, text_len);
 	msg->text_len = text_len;
 	memcpy(log_dict(msg), dict, dict_len);
@@ -663,8 +663,8 @@ const struct file_operations kmsg_fops =
  */
 void log_buf_kexec_setup(void)
 {
-	VMCOREINFO_SYMBOL(log_buf);
-	VMCOREINFO_SYMBOL(log_buf_len);
+	VMCOREINFO_SYMBOL(printk_log_buf);
+	VMCOREINFO_SYMBOL(printk_log_buf_len);
 	VMCOREINFO_SYMBOL(log_first_idx);
 	VMCOREINFO_SYMBOL(log_next_idx);
 	/*
@@ -679,60 +679,60 @@ void log_buf_kexec_setup(void)
 }
 #endif
 
-/* requested log_buf_len from kernel cmdline */
-static unsigned long __initdata new_log_buf_len;
+/* requested printk_log_buf_len from kernel cmdline */
+static unsigned long __initdata new_printk_log_buf_len;
 
-/* save requested log_buf_len since it's too early to process it */
-static int __init log_buf_len_setup(char *str)
+/* save requested printk_log_buf_len since it's too early to process it */
+static int __init printk_log_buf_len_setup(char *str)
 {
 	unsigned size = memparse(str, &str);
 
 	if (size)
 		size = roundup_pow_of_two(size);
-	if (size > log_buf_len)
-		new_log_buf_len = size;
+	if (size > printk_log_buf_len)
+		new_printk_log_buf_len = size;
 
 	return 0;
 }
-early_param("log_buf_len", log_buf_len_setup);
+early_param("log_buf_len", printk_log_buf_len_setup);
 
 void __init setup_log_buf(int early)
 {
 	unsigned long flags;
-	char *new_log_buf;
+	char *new_printk_log_buf;
 	int free;
 
-	if (!new_log_buf_len)
+	if (!new_printk_log_buf_len)
 		return;
 
 	if (early) {
 		unsigned long mem;
 
-		mem = memblock_alloc(new_log_buf_len, PAGE_SIZE);
+		mem = memblock_alloc(new_printk_log_buf_len, PAGE_SIZE);
 		if (!mem)
 			return;
-		new_log_buf = __va(mem);
+		new_printk_log_buf = __va(mem);
 	} else {
-		new_log_buf = alloc_bootmem_nopanic(new_log_buf_len);
+		new_printk_log_buf = alloc_bootmem_nopanic(new_printk_log_buf_len);
 	}
 
-	if (unlikely(!new_log_buf)) {
-		pr_err("log_buf_len: %ld bytes not available\n",
-			new_log_buf_len);
+	if (unlikely(!new_printk_log_buf)) {
+		pr_err("printk_log_buf_len: %ld bytes not available\n",
+			new_printk_log_buf_len);
 		return;
 	}
 
 	raw_spin_lock_irqsave(&logbuf_lock, flags);
-	log_buf_len = new_log_buf_len;
-	log_buf = new_log_buf;
-	new_log_buf_len = 0;
-	free = __LOG_BUF_LEN - log_next_idx;
-	memcpy(log_buf, __log_buf, __LOG_BUF_LEN);
+	printk_log_buf_len = new_printk_log_buf_len;
+	printk_log_buf = new_printk_log_buf;
+	new_printk_log_buf_len = 0;
+	free = __PRINTK_LOG_BUF_LEN - log_next_idx;
+	memcpy(printk_log_buf, __printk_log_buf, __PRINTK_LOG_BUF_LEN);
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	pr_info("log_buf_len: %d\n", log_buf_len);
+	pr_info("printk_log_buf_len: %d\n", printk_log_buf_len);
 	pr_info("early log buf free: %d(%d%%)\n",
-		free, (free * 100) / __LOG_BUF_LEN);
+		free, (free * 100) / __PRINTK_LOG_BUF_LEN);
 }
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
@@ -1211,7 +1211,7 @@ int do_syslog(int type, char __user *buf
 		break;
 	/* Size of the log buffer */
 	case SYSLOG_ACTION_SIZE_BUFFER:
-		error = log_buf_len;
+		error = printk_log_buf_len;
 		break;
 	default:
 		error = -EINVAL;
@@ -1243,7 +1243,7 @@ MODULE_PARM_DESC(ignore_loglevel, "ignor
 
 /*
  * Call the console drivers, asking them to write out
- * log_buf[start] to log_buf[end - 1].
+ * printk_log_buf[start] to printk_log_buf[end - 1].
  * The console_lock must be held.
  */
 static void call_console_drivers(int level, const char *text, size_t len)
_

Patches currently in -mm which might be from joe@perches.com are

printk-move-to-separate-directory-for-easier-modification.patch
printk-add-console_cmdlineh.patch
printk-move-braille-console-support-into-separate-braille-files.patch
printk-use-pointer-for-console_cmdline-indexing.patch
printk-rename-struct-log-to-struct-printk_log.patch
printk-rename-log_buf-and-__log_buf_len.patch
printk-rename-log_first-and-log_next-variables.patch
printk-rename-log_foo-variables-and-functions.patch
printk-rename-enum-log_flags-to-printk_log_flags.patch
printk-rename-log_wait-to-printk_log_wait.patch
printk-rename-logbuf_lock-to-printk_logbuf_lock.patch
printk-rename-clear_seq-and-clear_idx-variables.patch
printk-remove-static-from-printk_-variables.patch
printk-rename-log_align-to-printk_log_align.patch
printk-add-and-use-printk_logh.patch
printk-add-printk_logc.patch
printk-make-wait_queue_head_t-printk_log_wait-extern.patch
printk-rename-and-move-2-defines-to-printk_logh.patch
printk-move-devkmsg-bits-to-separate-file.patch
printk-prefix-print_time-and-msg_print_text-with-printk_.patch
printk-move-functions-printk_print_time-and-printk_msg_print_text.patch
printk-add-printk_syslogc-and-h.patch
printk-move-kmsg_dump-functions-to-separate-file.patch
maintainers-networking-drivers-matches-too-much.patch
checkpatch-improve-network-block-comment-style-checking.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

