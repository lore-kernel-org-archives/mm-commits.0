From: akpm@linux-foundation.org
Subject: [merged] printk-rename-struct-log-to-struct-printk_log.patch
 removed from -mm tree
Date: Mon, 05 Aug 2013 12:06:03 -0700
Message-ID: <51fff79b.qkEK7X3ogLHf65IC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab3HETGE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 15:06:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, samuel.thibault@ens-lyon.org, ming.lei@canonical.com, joe@perches.com

Subject: [merged] printk-rename-struct-log-to-struct-printk_log.patch removed from -mm tree
To: joe@perches.com,ming.lei@canonical.com,samuel.thibault@ens-lyon.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 12:06:03 -0700


The patch titled
     Subject: printk: rename struct log to struct printk_log
has been removed from the -mm tree.  Its filename was
     printk-rename-struct-log-to-struct-printk_log.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: rename struct log to struct printk_log

Rename the struct to enable moving portions of
printk.c to separate files.

The rename changes output of /proc/vmcoreinfo.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   80 +++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff -puN kernel/printk/printk.c~printk-rename-struct-log-to-struct-printk_log kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-rename-struct-log-to-struct-printk_log
+++ a/kernel/printk/printk.c
@@ -173,7 +173,7 @@ static int console_may_schedule;
  *         67                           "g"
  *   0032     00 00 00                  padding to next message header
  *
- * The 'struct log' buffer header must never be directly exported to
+ * The 'struct printk_log' buffer header must never be directly exported to
  * userspace, it is a kernel-private implementation detail that might
  * need to be changed in the future, when the requirements change.
  *
@@ -195,7 +195,7 @@ enum log_flags {
 	LOG_CONT	= 8,	/* text is a fragment of a continuation line */
 };
 
-struct log {
+struct printk_log {
 	u64 ts_nsec;		/* timestamp in nanoseconds */
 	u16 len;		/* length of entire record */
 	u16 text_len;		/* length of text buffer */
@@ -243,7 +243,7 @@ static u32 clear_idx;
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 #define LOG_ALIGN 4
 #else
-#define LOG_ALIGN __alignof__(struct log)
+#define LOG_ALIGN __alignof__(struct printk_log)
 #endif
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
@@ -254,35 +254,35 @@ static u32 log_buf_len = __LOG_BUF_LEN;
 static volatile unsigned int logbuf_cpu = UINT_MAX;
 
 /* human readable text of the record */
-static char *log_text(const struct log *msg)
+static char *log_text(const struct printk_log *msg)
 {
-	return (char *)msg + sizeof(struct log);
+	return (char *)msg + sizeof(struct printk_log);
 }
 
 /* optional key/value pair dictionary attached to the record */
-static char *log_dict(const struct log *msg)
+static char *log_dict(const struct printk_log *msg)
 {
-	return (char *)msg + sizeof(struct log) + msg->text_len;
+	return (char *)msg + sizeof(struct printk_log) + msg->text_len;
 }
 
 /* get record by index; idx must point to valid msg */
-static struct log *log_from_idx(u32 idx)
+static struct printk_log *log_from_idx(u32 idx)
 {
-	struct log *msg = (struct log *)(log_buf + idx);
+	struct printk_log *msg = (struct printk_log *)(log_buf + idx);
 
 	/*
 	 * A length == 0 record is the end of buffer marker. Wrap around and
 	 * read the message at the start of the buffer.
 	 */
 	if (!msg->len)
-		return (struct log *)log_buf;
+		return (struct printk_log *)log_buf;
 	return msg;
 }
 
 /* get next record; idx must point to valid msg */
 static u32 log_next(u32 idx)
 {
-	struct log *msg = (struct log *)(log_buf + idx);
+	struct printk_log *msg = (struct printk_log *)(log_buf + idx);
 
 	/* length == 0 indicates the end of the buffer; wrap */
 	/*
@@ -291,7 +291,7 @@ static u32 log_next(u32 idx)
 	 * return the one after that.
 	 */
 	if (!msg->len) {
-		msg = (struct log *)log_buf;
+		msg = (struct printk_log *)log_buf;
 		return msg->len;
 	}
 	return idx + msg->len;
@@ -303,11 +303,11 @@ static void log_store(int facility, int
 		      const char *dict, u16 dict_len,
 		      const char *text, u16 text_len)
 {
-	struct log *msg;
+	struct printk_log *msg;
 	u32 size, pad_len;
 
 	/* number of '\0' padding bytes to next message */
-	size = sizeof(struct log) + text_len + dict_len;
+	size = sizeof(struct printk_log) + text_len + dict_len;
 	pad_len = (-size) & (LOG_ALIGN - 1);
 	size += pad_len;
 
@@ -319,7 +319,7 @@ static void log_store(int facility, int
 		else
 			free = log_first_idx - log_next_idx;
 
-		if (free > size + sizeof(struct log))
+		if (free > size + sizeof(struct printk_log))
 			break;
 
 		/* drop old messages until we have enough contiuous space */
@@ -327,18 +327,18 @@ static void log_store(int facility, int
 		log_first_seq++;
 	}
 
-	if (log_next_idx + size + sizeof(struct log) >= log_buf_len) {
+	if (log_next_idx + size + sizeof(struct printk_log) >= log_buf_len) {
 		/*
 		 * This message + an additional empty header does not fit
 		 * at the end of the buffer. Add an empty header with len == 0
 		 * to signify a wrap around.
 		 */
-		memset(log_buf + log_next_idx, 0, sizeof(struct log));
+		memset(log_buf + log_next_idx, 0, sizeof(struct printk_log));
 		log_next_idx = 0;
 	}
 
 	/* fill message */
-	msg = (struct log *)(log_buf + log_next_idx);
+	msg = (struct printk_log *)(log_buf + log_next_idx);
 	memcpy(log_text(msg), text, text_len);
 	msg->text_len = text_len;
 	memcpy(log_dict(msg), dict, dict_len);
@@ -351,7 +351,7 @@ static void log_store(int facility, int
 	else
 		msg->ts_nsec = local_clock();
 	memset(log_dict(msg) + dict_len, 0, pad_len);
-	msg->len = sizeof(struct log) + text_len + dict_len + pad_len;
+	msg->len = sizeof(struct printk_log) + text_len + dict_len + pad_len;
 
 	/* insert message */
 	log_next_idx += msg->len;
@@ -474,7 +474,7 @@ static ssize_t devkmsg_read(struct file
 			    size_t count, loff_t *ppos)
 {
 	struct devkmsg_user *user = file->private_data;
-	struct log *msg;
+	struct printk_log *msg;
 	u64 ts_usec;
 	size_t i;
 	char cont = '-';
@@ -719,14 +719,14 @@ void log_buf_kexec_setup(void)
 	VMCOREINFO_SYMBOL(log_first_idx);
 	VMCOREINFO_SYMBOL(log_next_idx);
 	/*
-	 * Export struct log size and field offsets. User space tools can
+	 * Export struct printk_log size and field offsets. User space tools can
 	 * parse it and detect any changes to structure down the line.
 	 */
-	VMCOREINFO_STRUCT_SIZE(log);
-	VMCOREINFO_OFFSET(log, ts_nsec);
-	VMCOREINFO_OFFSET(log, len);
-	VMCOREINFO_OFFSET(log, text_len);
-	VMCOREINFO_OFFSET(log, dict_len);
+	VMCOREINFO_STRUCT_SIZE(printk_log);
+	VMCOREINFO_OFFSET(printk_log, ts_nsec);
+	VMCOREINFO_OFFSET(printk_log, len);
+	VMCOREINFO_OFFSET(printk_log, text_len);
+	VMCOREINFO_OFFSET(printk_log, dict_len);
 }
 #endif
 
@@ -879,7 +879,7 @@ static size_t print_time(u64 ts, char *b
 		       (unsigned long)ts, rem_nsec / 1000);
 }
 
-static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
+static size_t print_prefix(const struct printk_log *msg, bool syslog, char *buf)
 {
 	size_t len = 0;
 	unsigned int prefix = (msg->facility << 3) | msg->level;
@@ -902,7 +902,7 @@ static size_t print_prefix(const struct
 	return len;
 }
 
-static size_t msg_print_text(const struct log *msg, enum log_flags prev,
+static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 			     bool syslog, char *buf, size_t size)
 {
 	const char *text = log_text(msg);
@@ -964,7 +964,7 @@ static size_t msg_print_text(const struc
 static int syslog_print(char __user *buf, int size)
 {
 	char *text;
-	struct log *msg;
+	struct printk_log *msg;
 	int len = 0;
 
 	text = kmalloc(LOG_LINE_MAX + PREFIX_MAX, GFP_KERNEL);
@@ -1055,7 +1055,7 @@ static int syslog_print_all(char __user
 		idx = clear_idx;
 		prev = 0;
 		while (seq < log_next_seq) {
-			struct log *msg = log_from_idx(idx);
+			struct printk_log *msg = log_from_idx(idx);
 
 			len += msg_print_text(msg, prev, true, NULL, 0);
 			prev = msg->flags;
@@ -1068,7 +1068,7 @@ static int syslog_print_all(char __user
 		idx = clear_idx;
 		prev = 0;
 		while (len > size && seq < log_next_seq) {
-			struct log *msg = log_from_idx(idx);
+			struct printk_log *msg = log_from_idx(idx);
 
 			len -= msg_print_text(msg, prev, true, NULL, 0);
 			prev = msg->flags;
@@ -1082,7 +1082,7 @@ static int syslog_print_all(char __user
 		len = 0;
 		prev = 0;
 		while (len >= 0 && seq < next_seq) {
-			struct log *msg = log_from_idx(idx);
+			struct printk_log *msg = log_from_idx(idx);
 			int textlen;
 
 			textlen = msg_print_text(msg, prev, true, text,
@@ -1228,7 +1228,7 @@ int do_syslog(int type, char __user *buf
 
 			error = 0;
 			while (seq < log_next_seq) {
-				struct log *msg = log_from_idx(idx);
+				struct printk_log *msg = log_from_idx(idx);
 
 				error += msg_print_text(msg, prev, true, NULL, 0);
 				idx = log_next(idx);
@@ -1714,10 +1714,10 @@ static struct cont {
 	u8 level;
 	bool flushed:1;
 } cont;
-static struct log *log_from_idx(u32 idx) { return NULL; }
+static struct printk_log *log_from_idx(u32 idx) { return NULL; }
 static u32 log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
-static size_t msg_print_text(const struct log *msg, enum log_flags prev,
+static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 			     bool syslog, char *buf, size_t size) { return 0; }
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 
@@ -2029,7 +2029,7 @@ void console_unlock(void)
 	console_cont_flush(text, sizeof(text));
 again:
 	for (;;) {
-		struct log *msg;
+		struct printk_log *msg;
 		size_t len;
 		int level;
 
@@ -2645,7 +2645,7 @@ void kmsg_dump(enum kmsg_dump_reason rea
 bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
 			       char *line, size_t size, size_t *len)
 {
-	struct log *msg;
+	struct printk_log *msg;
 	size_t l = 0;
 	bool ret = false;
 
@@ -2757,7 +2757,7 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 	idx = dumper->cur_idx;
 	prev = 0;
 	while (seq < dumper->next_seq) {
-		struct log *msg = log_from_idx(idx);
+		struct printk_log *msg = log_from_idx(idx);
 
 		l += msg_print_text(msg, prev, true, NULL, 0);
 		idx = log_next(idx);
@@ -2770,7 +2770,7 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 	idx = dumper->cur_idx;
 	prev = 0;
 	while (l > size && seq < dumper->next_seq) {
-		struct log *msg = log_from_idx(idx);
+		struct printk_log *msg = log_from_idx(idx);
 
 		l -= msg_print_text(msg, prev, true, NULL, 0);
 		idx = log_next(idx);
@@ -2785,7 +2785,7 @@ bool kmsg_dump_get_buffer(struct kmsg_du
 	l = 0;
 	prev = 0;
 	while (seq < dumper->next_seq) {
-		struct log *msg = log_from_idx(idx);
+		struct printk_log *msg = log_from_idx(idx);
 
 		l += msg_print_text(msg, prev, syslog, buf + l, size - l);
 		idx = log_next(idx);
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-exynos-remove-board-files.patch
maintainers-arm-omap2-3-remove-unused-clockdomain-files.patch
maintainers-omap-powerdomain-update-patterns.patch
maintainers-arm-s3c2410-update-patterns.patch
maintainers-arm-spear-consolidate-sections.patch
maintainers-arm-plat-nomadik-update-patterns.patch
maintainers-arm-s3c24xx-remove-plat-s3c24xx.patch
maintainers-ghes_edac-update-pattern.patch
maintainers-update-siano-drivers.patch
maintainers-si4713-fix-file-pattern.patch
maintainers-update-it913x-patterns.patch
maintainers-update-sirf-patterns.patch
maintainers-update-ssbi-patterns.patch
maintainers-update-file-pattern-for-arc-uart.patch
maintainers-update-usb-ehci-platform-pattern.patch
maintainers-usb-phy-update-patterns.patch
maintainers-update-gre-demux-patterns.patch
checkpatch-add-a-few-more-fix-corrections.patch
checkpatch-check-camelcase-by-word-not-by-lval.patch
checkpatch-enforce-sane-perl-version.patch
checkpatch-check-for-duplicate-signatures.patch
checkpatch-warn-when-using-extern-with-function-prototypes-in-h-files.patch
checkpatch-fix-networking-kernel-doc-block-comment-defect.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch
pktcdvd-convert-zone-macro-to-static-function-get_zone.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-consolidate-dprintk-and-vprintk-macros.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg.patch
pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible.patch
pktcdvd-convert-pr_notice-to-pkt_notice.patch
pktcdvd-convert-pr_info-to-pkt_info.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense.patch
linux-next.patch

