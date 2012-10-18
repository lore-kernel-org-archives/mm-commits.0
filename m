From: akpm@linux-foundation.org
Subject: + printk-add-and-use-printk_logh.patch added to -mm tree
Date: Thu, 18 Oct 2012 16:17:07 -0700
Message-ID: <20121018231707.A2C45100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:64786 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab2JRXRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 19:17:09 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so287727qae.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 16:17:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, kay@vrfy.org


The patch titled
     Subject: printk: add and use printk_log.h
has been added to the -mm tree.  Its filename is
     printk-add-and-use-printk_logh.patch

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
Subject: printk: add and use printk_log.h

Create a header file for printk_log functions and variables.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c     |   91 ---------------------------
 kernel/printk/printk_log.h |  115 +++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+), 90 deletions(-)

diff -puN kernel/printk/printk.c~printk-add-and-use-printk_logh kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-add-and-use-printk_logh
+++ a/kernel/printk/printk.c
@@ -48,6 +48,7 @@
 
 #include "console_cmdline.h"
 #include "braille.h"
+#include "printk_log.h"
 
 /*
  * Architectures can override it:
@@ -121,90 +122,6 @@ EXPORT_SYMBOL(console_set_on_cmdline);
 static int console_may_schedule;
 
 /*
- * The printk log buffer consists of a chain of concatenated variable
- * length records. Every record starts with a record header, containing
- * the overall length of the record.
- *
- * The heads to the first and last entry in the buffer, as well as the
- * sequence numbers of these both entries are maintained when messages
- * are stored..
- *
- * If the heads indicate available messages, the length in the header
- * tells the start next message. A length == 0 for the next message
- * indicates a wrap-around to the beginning of the buffer.
- *
- * Every record carries the monotonic timestamp in microseconds, as well as
- * the standard userspace syslog level and syslog facility. The usual
- * kernel messages use LOG_KERN; userspace-injected messages always carry
- * a matching syslog facility, by default LOG_USER. The origin of every
- * message can be reliably determined that way.
- *
- * The human readable log message directly follows the message header. The
- * length of the message text is stored in the header, the stored message
- * is not terminated.
- *
- * Optionally, a message can carry a dictionary of properties (key/value pairs),
- * to provide userspace with a machine-readable message context.
- *
- * Examples for well-defined, commonly used property names are:
- *   DEVICE=b12:8               device identifier
- *                                b12:8         block dev_t
- *                                c127:3        char dev_t
- *                                n8            netdev ifindex
- *                                +sound:card0  subsystem:devname
- *   SUBSYSTEM=pci              driver-core subsystem name
- *
- * Valid characters in property names are [a-zA-Z0-9.-_]. The plain text value
- * follows directly after a '=' character. Every property is terminated by
- * a '\0' character. The last property is not terminated.
- *
- * Example of a message structure:
- *   0000  ff 8f 00 00 00 00 00 00      monotonic time in nsec
- *   0008  34 00                        record is 52 bytes long
- *   000a        0b 00                  text is 11 bytes long
- *   000c              1f 00            dictionary is 23 bytes long
- *   000e                    03 00      LOG_KERN (facility) LOG_ERR (level)
- *   0010  69 74 27 73 20 61 20 6c      "it's a l"
- *         69 6e 65                     "ine"
- *   001b           44 45 56 49 43      "DEVIC"
- *         45 3d 62 38 3a 32 00 44      "E=b8:2\0D"
- *         52 49 56 45 52 3d 62 75      "RIVER=bu"
- *         67                           "g"
- *   0032     00 00 00                  padding to next message header
- *
- * The 'struct printk_log' buffer header must never be directly exported to
- * userspace, it is a kernel-private implementation detail that might
- * need to be changed in the future, when the requirements change.
- *
- * /dev/kmsg exports the structured data in the following line format:
- *   "level,sequnum,timestamp;<message text>\n"
- *
- * The optional key/value pairs are attached as continuation lines starting
- * with a space character and terminated by a newline. All possible
- * non-prinatable characters are escaped in the "\xff" notation.
- *
- * Users of the export format should ignore possible additional values
- * separated by ',', and find the message after the ';' character.
- */
-
-enum printk_log_flags {
-	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
-	LOG_NEWLINE	= 2,	/* text ended with a newline */
-	LOG_PREFIX	= 4,	/* text started with a prefix */
-	LOG_CONT	= 8,	/* text is a fragment of a continuation line */
-};
-
-struct printk_log {
-	u64 ts_nsec;		/* timestamp in nanoseconds */
-	u16 len;		/* length of entire record */
-	u16 text_len;		/* length of text buffer */
-	u16 dict_len;		/* length of dictionary buffer */
-	u8 facility;		/* syslog facility */
-	u8 flags:5;		/* internal record flags */
-	u8 level:3;		/* syslog level */
-};
-
-/*
  * The printk_logbuf_lock protects kmsg buffer, indices, counters. It is also
  * used in interesting ways to provide interlocking in console_unlock();
  */
@@ -238,12 +155,6 @@ u32 printk_log_clear_idx;
 #define LOG_LINE_MAX		1024 - PREFIX_MAX
 
 /* record buffer */
-#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-#define PRINTK_LOG_ALIGN 4
-#else
-#define PRINTK_LOG_ALIGN __alignof__(struct printk_log)
-#endif
-#define __PRINTK_LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
 char __printk_log_buf[__PRINTK_LOG_BUF_LEN] __aligned(PRINTK_LOG_ALIGN);
 char *printk_log_buf = __printk_log_buf;
 u32 printk_log_buf_len = __PRINTK_LOG_BUF_LEN;
diff -puN /dev/null kernel/printk/printk_log.h
--- /dev/null
+++ a/kernel/printk/printk_log.h
@@ -0,0 +1,115 @@
+#ifndef _PRINTK_LOG_H
+#define _PRINTK_LOG_H
+
+/*
+ * The printk log buffer consists of a chain of concatenated variable
+ * length records. Every record starts with a record header, containing
+ * the overall length of the record.
+ *
+ * The heads to the first and last entry in the buffer, as well as the
+ * sequence numbers of these both entries are maintained when messages
+ * are stored..
+ *
+ * If the heads indicate available messages, the length in the header
+ * tells the start next message. A length == 0 for the next message
+ * indicates a wrap-around to the beginning of the buffer.
+ *
+ * Every record carries the monotonic timestamp in microseconds, as well as
+ * the standard userspace syslog level and syslog facility. The usual
+ * kernel messages use LOG_KERN; userspace-injected messages always carry
+ * a matching syslog facility, by default LOG_USER. The origin of every
+ * message can be reliably determined that way.
+ *
+ * The human readable log message directly follows the message header. The
+ * length of the message text is stored in the header, the stored message
+ * is not terminated.
+ *
+ * Optionally, a message can carry a dictionary of properties (key/value pairs),
+ * to provide userspace with a machine-readable message context.
+ *
+ * Examples for well-defined, commonly used property names are:
+ *   DEVICE=b12:8               device identifier
+ *                                b12:8         block dev_t
+ *                                c127:3        char dev_t
+ *                                n8            netdev ifindex
+ *                                +sound:card0  subsystem:devname
+ *   SUBSYSTEM=pci              driver-core subsystem name
+ *
+ * Valid characters in property names are [a-zA-Z0-9.-_]. The plain text value
+ * follows directly after a '=' character. Every property is terminated by
+ * a '\0' character. The last property is not terminated.
+ *
+ * Example of a message structure:
+ *   0000  ff 8f 00 00 00 00 00 00      monotonic time in nsec
+ *   0008  34 00                        record is 52 bytes long
+ *   000a        0b 00                  text is 11 bytes long
+ *   000c              1f 00            dictionary is 23 bytes long
+ *   000e                    03 00      LOG_KERN (facility) LOG_ERR (level)
+ *   0010  69 74 27 73 20 61 20 6c      "it's a l"
+ *         69 6e 65                     "ine"
+ *   001b           44 45 56 49 43      "DEVIC"
+ *         45 3d 62 38 3a 32 00 44      "E=b8:2\0D"
+ *         52 49 56 45 52 3d 62 75      "RIVER=bu"
+ *         67                           "g"
+ *   0032     00 00 00                  padding to next message header
+ *
+ * The 'struct printk_log' buffer header must never be directly exported to
+ * userspace, it is a kernel-private implementation detail that might
+ * need to be changed in the future, when the requirements change.
+ *
+ * /dev/kmsg exports the structured data in the following line format:
+ *   "level,sequnum,timestamp;<message text>\n"
+ *
+ * The optional key/value pairs are attached as continuation lines starting
+ * with a space character and terminated by a newline. All possible
+ * non-prinatable characters are escaped in the "\xff" notation.
+ *
+ * Users of the export format should ignore possible additional values
+ * separated by ',', and find the message after the ';' character.
+ */
+
+enum printk_log_flags {
+	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
+	LOG_NEWLINE	= 2,	/* text ended with a newline */
+	LOG_PREFIX	= 4,	/* text started with a prefix */
+	LOG_CONT	= 8,	/* text is a fragment of a continuation line */
+};
+
+struct printk_log {
+	u64 ts_nsec;		/* timestamp in nanoseconds */
+	u16 len;		/* length of entire record */
+	u16 text_len;		/* length of text buffer */
+	u16 dict_len;		/* length of dictionary buffer */
+	u8 facility;		/* syslog facility */
+	u8 flags:5;		/* internal record flags */
+	u8 level:3;		/* syslog level */
+};
+
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+#define PRINTK_LOG_ALIGN 4
+#else
+#define PRINTK_LOG_ALIGN __alignof__(struct printk_log)
+#endif
+#define __PRINTK_LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
+
+extern raw_spinlock_t printk_logbuf_lock;
+extern u64 printk_log_first_seq;
+extern u32 printk_log_first_idx;
+extern u64 printk_log_next_seq;
+extern u32 printk_log_next_idx;
+extern u64 printk_log_clear_seq;
+extern u32 printk_log_clear_idx;
+extern char __printk_log_buf[__PRINTK_LOG_BUF_LEN] __aligned(PRINTK_LOG_ALIGN);
+extern char *printk_log_buf;
+extern u32 printk_log_buf_len;
+
+char *printk_log_text(const struct printk_log *msg);
+char *printk_log_dict(const struct printk_log *msg);
+struct printk_log *printk_log_from_idx(u32 idx);
+u32 printk_log_next(u32 idx);
+void printk_log_store(int facility, int level,
+		      enum printk_log_flags flags, u64 ts_nsec,
+		      const char *dict, u16 dict_len,
+		      const char *text, u16 text_len);
+
+#endif
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

