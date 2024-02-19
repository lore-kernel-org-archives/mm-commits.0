Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184F45472A
	for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 21:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708379945; cv=none; b=H/3gLpGClNqXbTCxoX3gG/OjRuwpGPq2vmqtYD05WS8nJps1RTDBmBMx0nrRSkqMTlD8yb/caaHsUzbAl5mKhrxCGK30gB4Wv1GrjfBNgT7Uyd+dug7RTsZskzl29SRfcqWwI4272bKklMllrLWiC9cK4a92Y+m368Vb54yMNDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708379945; c=relaxed/simple;
	bh=7RNlyXCLwqbzhSp7u2g8w2ut/kQwRBZmpX5BxVZzyzk=;
	h=Date:To:From:Subject:Message-Id; b=qCp58lTg61z374fen67PBU0YpbeEp8IJavwOpfaDcBg7fR4wRzO4kxsbFrHzNs1FkdthNa0GKwpldxrW403ruo2OnUM3hv8qXYGFEnASLJzjWLquV1Ow698byhvBl7MwRx7vOZwQWZzxVX6gvold9d7V6xTaTjyRcsqb4lVAo14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Iiw4GJT2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Iiw4GJT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AD5C433F1;
	Mon, 19 Feb 2024 21:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708379944;
	bh=7RNlyXCLwqbzhSp7u2g8w2ut/kQwRBZmpX5BxVZzyzk=;
	h=Date:To:From:Subject:From;
	b=Iiw4GJT2usKZV1vIhmSpmHKom4i8Zqq6gcK+frAAMSMoANhayK7qwAc8dacrEQP4g
	 yoWG6TENIK2vZuhPEUDIuUV4sLchqUs2bFz3dPDGVCFMuigEQ6Ul0rfV2PS/CcNOt8
	 n4D2rs8Q9rgnZUPEiPCIIP6pP4K126d2TzIXLrhs=
Date: Mon, 19 Feb 2024 13:59:03 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,rdunlap@infradead.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] seq_buf-fix-kernel-documentation.patch removed from -mm tree
Message-Id: <20240219215904.72AD5C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: seq_buf: fix kernel documentation
has been removed from the -mm tree.  Its filename was
     seq_buf-fix-kernel-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: seq_buf: fix kernel documentation
Date: Thu, 15 Feb 2024 17:25:06 +0200

There are plenty of issues with the kernel documentation here:
  - misspelled word "sequence"
  - different style of returned value descriptions
  - missed Return sections
  - unaligned style of ASCII / NUL-terminated / etc
  - wrong function references

Fix all these.

Link: https://lkml.kernel.org/r/20240215152506.598340-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/seq_buf.h |   12 ++++++------
 lib/seq_buf.c           |   35 ++++++++++++++++++-----------------
 2 files changed, 24 insertions(+), 23 deletions(-)

--- a/include/linux/seq_buf.h~seq_buf-fix-kernel-documentation
+++ a/include/linux/seq_buf.h
@@ -10,7 +10,7 @@
  */
 
 /**
- * seq_buf - seq buffer structure
+ * struct seq_buf - seq buffer structure
  * @buffer:	pointer to the buffer
  * @size:	size of the buffer
  * @len:	the amount of data inside the buffer
@@ -77,10 +77,10 @@ static inline unsigned int seq_buf_used(
 }
 
 /**
- * seq_buf_str - get %NUL-terminated C string from seq_buf
+ * seq_buf_str - get NUL-terminated C string from seq_buf
  * @s: the seq_buf handle
  *
- * This makes sure that the buffer in @s is nul terminated and
+ * This makes sure that the buffer in @s is NUL-terminated and
  * safe to read as a string.
  *
  * Note, if this is called when the buffer has overflowed, then
@@ -90,7 +90,7 @@ static inline unsigned int seq_buf_used(
  * After this function is called, s->buffer is safe to use
  * in string operations.
  *
- * Returns @s->buf after making sure it is terminated.
+ * Returns: @s->buf after making sure it is terminated.
  */
 static inline const char *seq_buf_str(struct seq_buf *s)
 {
@@ -110,7 +110,7 @@ static inline const char *seq_buf_str(st
  * @s: the seq_buf handle
  * @bufp: the beginning of the buffer is stored here
  *
- * Return the number of bytes available in the buffer, or zero if
+ * Returns: the number of bytes available in the buffer, or zero if
  * there's no space.
  */
 static inline size_t seq_buf_get_buf(struct seq_buf *s, char **bufp)
@@ -132,7 +132,7 @@ static inline size_t seq_buf_get_buf(str
  * @num: the number of bytes to commit
  *
  * Commit @num bytes of data written to a buffer previously acquired
- * by seq_buf_get.  To signal an error condition, or that the data
+ * by seq_buf_get_buf(). To signal an error condition, or that the data
  * didn't fit in the available space, pass a negative @num value.
  */
 static inline void seq_buf_commit(struct seq_buf *s, int num)
--- a/lib/seq_buf.c~seq_buf-fix-kernel-documentation
+++ a/lib/seq_buf.c
@@ -22,7 +22,7 @@
  * @s: the seq_buf descriptor
  * @len: The length to see if it can fit in the current buffer
  *
- * Returns true if there's enough unused space in the seq_buf buffer
+ * Returns: true if there's enough unused space in the seq_buf buffer
  * to fit the amount of new data according to @len.
  */
 static bool seq_buf_can_fit(struct seq_buf *s, size_t len)
@@ -35,7 +35,7 @@ static bool seq_buf_can_fit(struct seq_b
  * @m: the seq_file descriptor that is the destination
  * @s: the seq_buf descriptor that is the source.
  *
- * Returns zero on success, non zero otherwise
+ * Returns: zero on success, non-zero otherwise.
  */
 int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s)
 {
@@ -50,9 +50,9 @@ int seq_buf_print_seq(struct seq_file *m
  * @fmt: printf format string
  * @args: va_list of arguments from a printf() type function
  *
- * Writes a vnprintf() format into the sequencce buffer.
+ * Writes a vnprintf() format into the sequence buffer.
  *
- * Returns zero on success, -1 on overflow.
+ * Returns: zero on success, -1 on overflow.
  */
 int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args)
 {
@@ -78,7 +78,7 @@ int seq_buf_vprintf(struct seq_buf *s, c
  *
  * Writes a printf() format into the sequence buffer.
  *
- * Returns zero on success, -1 on overflow.
+ * Returns: zero on success, -1 on overflow.
  */
 int seq_buf_printf(struct seq_buf *s, const char *fmt, ...)
 {
@@ -94,12 +94,12 @@ int seq_buf_printf(struct seq_buf *s, co
 EXPORT_SYMBOL_GPL(seq_buf_printf);
 
 /**
- * seq_buf_do_printk - printk seq_buf line by line
+ * seq_buf_do_printk - printk() seq_buf line by line
  * @s: seq_buf descriptor
  * @lvl: printk level
  *
  * printk()-s a multi-line sequential buffer line by line. The function
- * makes sure that the buffer in @s is nul terminated and safe to read
+ * makes sure that the buffer in @s is NUL-terminated and safe to read
  * as a string.
  */
 void seq_buf_do_printk(struct seq_buf *s, const char *lvl)
@@ -139,7 +139,7 @@ EXPORT_SYMBOL_GPL(seq_buf_do_printk);
  * This function will take the format and the binary array and finish
  * the conversion into the ASCII string within the buffer.
  *
- * Returns zero on success, -1 on overflow.
+ * Returns: zero on success, -1 on overflow.
  */
 int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
 {
@@ -167,7 +167,7 @@ int seq_buf_bprintf(struct seq_buf *s, c
  *
  * Copy a simple string into the sequence buffer.
  *
- * Returns zero on success, -1 on overflow
+ * Returns: zero on success, -1 on overflow.
  */
 int seq_buf_puts(struct seq_buf *s, const char *str)
 {
@@ -196,7 +196,7 @@ EXPORT_SYMBOL_GPL(seq_buf_puts);
  *
  * Copy a single character into the sequence buffer.
  *
- * Returns zero on success, -1 on overflow
+ * Returns: zero on success, -1 on overflow.
  */
 int seq_buf_putc(struct seq_buf *s, unsigned char c)
 {
@@ -212,7 +212,7 @@ int seq_buf_putc(struct seq_buf *s, unsi
 EXPORT_SYMBOL_GPL(seq_buf_putc);
 
 /**
- * seq_buf_putmem - write raw data into the sequenc buffer
+ * seq_buf_putmem - write raw data into the sequence buffer
  * @s: seq_buf descriptor
  * @mem: The raw memory to copy into the buffer
  * @len: The length of the raw memory to copy (in bytes)
@@ -221,7 +221,7 @@ EXPORT_SYMBOL_GPL(seq_buf_putc);
  * buffer and a strcpy() would not work. Using this function allows
  * for such cases.
  *
- * Returns zero on success, -1 on overflow
+ * Returns: zero on success, -1 on overflow.
  */
 int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
 {
@@ -249,7 +249,7 @@ int seq_buf_putmem(struct seq_buf *s, co
  * raw memory into the buffer it writes its ASCII representation of it
  * in hex characters.
  *
- * Returns zero on success, -1 on overflow
+ * Returns: zero on success, -1 on overflow.
  */
 int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
 		       unsigned int len)
@@ -297,7 +297,7 @@ int seq_buf_putmem_hex(struct seq_buf *s
  *
  * Write a path name into the sequence buffer.
  *
- * Returns the number of written bytes on success, -1 on overflow
+ * Returns: the number of written bytes on success, -1 on overflow.
  */
 int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc)
 {
@@ -332,6 +332,7 @@ int seq_buf_path(struct seq_buf *s, cons
  * or until it reaches the end of the content in the buffer (@s->len),
  * whichever comes first.
  *
+ * Returns:
  * On success, it returns a positive number of the number of bytes
  * it copied.
  *
@@ -382,11 +383,11 @@ int seq_buf_to_user(struct seq_buf *s, c
  * linebuf size is maximal length for one line.
  * 32 * 3 - maximum bytes per line, each printed into 2 chars + 1 for
  *	separating space
- * 2 - spaces separating hex dump and ascii representation
- * 32 - ascii representation
+ * 2 - spaces separating hex dump and ASCII representation
+ * 32 - ASCII representation
  * 1 - terminating '\0'
  *
- * Returns zero on success, -1 on overflow
+ * Returns: zero on success, -1 on overflow.
  */
 int seq_buf_hex_dump(struct seq_buf *s, const char *prefix_str, int prefix_type,
 		     int rowsize, int groupsize,
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

dyndbg-replace-kstrdup-strchr-with-kstrdup_and_replace.patch

