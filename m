From: akpm@linux-foundation.org
Subject: +
 fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
 added to -mm tree
Date: Thu, 21 May 2015 15:47:36 -0700
Message-ID: <555e6088.dxEYWMCdqxLiltr6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbbEUWrh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 May 2015 18:47:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, rostedt@goodmis.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/seq_file: convert int seq_vprint/seq_printf/etc... returns to void
has been added to the -mm tree.  Its filename is
     fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

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
Subject: fs/seq_file: convert int seq_vprint/seq_printf/etc... returns to void

The seq_<foo> function return values were frequently misused.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

All uses of these return values have been removed, so convert the
return types to void.

Miscellanea:

o Move seq_put_decimal_<type> and seq_escape prototypes closer the
  other seq_vprintf prototypes
o Reorder seq_putc and seq_puts to return early on overflow
o Add argument names to seq_vprintf and seq_printf
o Update the seq_escape kernel-doc
o Convert a couple of leading spaces to tabs in seq_escape

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |   70 ++++++++++++++++---------------------
 include/linux/seq_file.h |   19 +++++-----
 2 files changed, 41 insertions(+), 48 deletions(-)

diff -puN fs/seq_file.c~fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void fs/seq_file.c
--- a/fs/seq_file.c~fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void
+++ a/fs/seq_file.c
@@ -368,16 +368,16 @@ EXPORT_SYMBOL(seq_release);
  *	@esc:	set of characters that need escaping
  *
  *	Puts string into buffer, replacing each occurrence of character from
- *	@esc with usual octal escape.  Returns 0 in case of success, -1 - in
- *	case of overflow.
+ *	@esc with usual octal escape.
+ *	Use seq_has_overflowed() to check for errors.
  */
-int seq_escape(struct seq_file *m, const char *s, const char *esc)
+void seq_escape(struct seq_file *m, const char *s, const char *esc)
 {
 	char *end = m->buf + m->size;
-        char *p;
+	char *p;
 	char c;
 
-        for (p = m->buf + m->count; (c = *s) != '\0' && p < end; s++) {
+	for (p = m->buf + m->count; (c = *s) != '\0' && p < end; s++) {
 		if (!strchr(esc, c)) {
 			*p++ = c;
 			continue;
@@ -390,14 +390,13 @@ int seq_escape(struct seq_file *m, const
 			continue;
 		}
 		seq_set_overflow(m);
-		return -1;
-        }
+		return;
+	}
 	m->count = p - m->buf;
-        return 0;
 }
 EXPORT_SYMBOL(seq_escape);
 
-int seq_vprintf(struct seq_file *m, const char *f, va_list args)
+void seq_vprintf(struct seq_file *m, const char *f, va_list args)
 {
 	int len;
 
@@ -405,24 +404,20 @@ int seq_vprintf(struct seq_file *m, cons
 		len = vsnprintf(m->buf + m->count, m->size - m->count, f, args);
 		if (m->count + len < m->size) {
 			m->count += len;
-			return 0;
+			return;
 		}
 	}
 	seq_set_overflow(m);
-	return -1;
 }
 EXPORT_SYMBOL(seq_vprintf);
 
-int seq_printf(struct seq_file *m, const char *f, ...)
+void seq_printf(struct seq_file *m, const char *f, ...)
 {
-	int ret;
 	va_list args;
 
 	va_start(args, f);
-	ret = seq_vprintf(m, f, args);
+	seq_vprintf(m, f, args);
 	va_end(args);
-
-	return ret;
 }
 EXPORT_SYMBOL(seq_printf);
 
@@ -645,26 +640,25 @@ int seq_open_private(struct file *filp,
 }
 EXPORT_SYMBOL(seq_open_private);
 
-int seq_putc(struct seq_file *m, char c)
+void seq_putc(struct seq_file *m, char c)
 {
-	if (m->count < m->size) {
-		m->buf[m->count++] = c;
-		return 0;
-	}
-	return -1;
+	if (m->count >= m->size)
+		return;
+
+	m->buf[m->count++] = c;
 }
 EXPORT_SYMBOL(seq_putc);
 
-int seq_puts(struct seq_file *m, const char *s)
+void seq_puts(struct seq_file *m, const char *s)
 {
 	int len = strlen(s);
-	if (m->count + len < m->size) {
-		memcpy(m->buf + m->count, s, len);
-		m->count += len;
-		return 0;
+
+	if (m->count + len >= m->size) {
+		seq_set_overflow(m);
+		return;
 	}
-	seq_set_overflow(m);
-	return -1;
+	memcpy(m->buf + m->count, s, len);
+	m->count += len;
 }
 EXPORT_SYMBOL(seq_puts);
 
@@ -675,8 +669,8 @@ EXPORT_SYMBOL(seq_puts);
  * This routine is very quick when you show lots of numbers.
  * In usual cases, it will be better to use seq_printf(). It's easier to read.
  */
-int seq_put_decimal_ull(struct seq_file *m, char delimiter,
-			unsigned long long num)
+void seq_put_decimal_ull(struct seq_file *m, char delimiter,
+			 unsigned long long num)
 {
 	int len;
 
@@ -688,35 +682,33 @@ int seq_put_decimal_ull(struct seq_file
 
 	if (num < 10) {
 		m->buf[m->count++] = num + '0';
-		return 0;
+		return;
 	}
 
 	len = num_to_str(m->buf + m->count, m->size - m->count, num);
 	if (!len)
 		goto overflow;
 	m->count += len;
-	return 0;
+	return;
+
 overflow:
 	seq_set_overflow(m);
-	return -1;
 }
 EXPORT_SYMBOL(seq_put_decimal_ull);
 
-int seq_put_decimal_ll(struct seq_file *m, char delimiter,
-			long long num)
+void seq_put_decimal_ll(struct seq_file *m, char delimiter, long long num)
 {
 	if (num < 0) {
 		if (m->count + 3 >= m->size) {
 			seq_set_overflow(m);
-			return -1;
+			return;
 		}
 		if (delimiter)
 			m->buf[m->count++] = delimiter;
 		num = -num;
 		delimiter = '-';
 	}
-	return seq_put_decimal_ull(m, delimiter, num);
-
+	seq_put_decimal_ull(m, delimiter, num);
 }
 EXPORT_SYMBOL(seq_put_decimal_ll);
 
diff -puN include/linux/seq_file.h~fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void include/linux/seq_file.h
--- a/include/linux/seq_file.h~fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void
+++ a/include/linux/seq_file.h
@@ -114,13 +114,18 @@ int seq_open(struct file *, const struct
 ssize_t seq_read(struct file *, char __user *, size_t, loff_t *);
 loff_t seq_lseek(struct file *, loff_t, int);
 int seq_release(struct inode *, struct file *);
-int seq_escape(struct seq_file *, const char *, const char *);
-int seq_putc(struct seq_file *m, char c);
-int seq_puts(struct seq_file *m, const char *s);
 int seq_write(struct seq_file *seq, const void *data, size_t len);
 
-__printf(2, 3) int seq_printf(struct seq_file *, const char *, ...);
-__printf(2, 0) int seq_vprintf(struct seq_file *, const char *, va_list args);
+__printf(2, 0)
+void seq_vprintf(struct seq_file *m, const char *fmt, va_list args);
+__printf(2, 3)
+void seq_printf(struct seq_file *m, const char *fmt, ...);
+void seq_putc(struct seq_file *m, char c);
+void seq_puts(struct seq_file *m, const char *s);
+void seq_put_decimal_ull(struct seq_file *m, char delimiter,
+			 unsigned long long num);
+void seq_put_decimal_ll(struct seq_file *m, char delimiter, long long num);
+void seq_escape(struct seq_file *m, const char *s, const char *esc);
 
 int seq_path(struct seq_file *, const struct path *, const char *);
 int seq_dentry(struct seq_file *, struct dentry *, const char *);
@@ -133,10 +138,6 @@ int single_release(struct inode *, struc
 void *__seq_open_private(struct file *, const struct seq_operations *, int);
 int seq_open_private(struct file *, const struct seq_operations *, int);
 int seq_release_private(struct inode *, struct file *);
-int seq_put_decimal_ull(struct seq_file *m, char delimiter,
-			unsigned long long num);
-int seq_put_decimal_ll(struct seq_file *m, char delimiter,
-			long long num);
 
 static inline struct user_namespace *seq_user_ns(struct seq_file *seq)
 {
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-update-capabilities-pattern.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch
mm-utilc-add-kstrimdup.patch
checkpatch-check-for-uncommented-waitqueue_active.patch
checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch
checkpatch-make-types-found-in-a-source-file-patch-local.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

