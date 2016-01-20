From: akpm@linux-foundation.org
Subject: [folded-merged]
 printk-nmi-generic-solution-for-safe-printk-in-nmi-v4.patch removed from
 -mm tree
Date: Wed, 20 Jan 2016 13:09:31 -0800
Message-ID: <569ff78b.3tXi82k90aFgUDQc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbcATVJc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 16:09:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-nmi-generic-solution-for-safe-printk-in-nmi-v4
has been removed from the -mm tree.  Its filename was
     printk-nmi-generic-solution-for-safe-printk-in-nmi-v4.patch

This patch was dropped because it was folded into printk-nmi-generic-solution-for-safe-printk-in-nmi.patch

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: printk-nmi-generic-solution-for-safe-printk-in-nmi-v4

rename from kernel/printk/printk.h
rename to kernel/printk/internal.h

Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/internal.h |   44 +++++++++++++++++++++++++++++++++++++
 kernel/printk/nmi.c      |   14 +++++++----
 kernel/printk/printk.c   |    2 -
 kernel/printk/printk.h   |   44 -------------------------------------
 4 files changed, 54 insertions(+), 50 deletions(-)

diff -puN /dev/null kernel/printk/internal.h
--- /dev/null
+++ a/kernel/printk/internal.h
@@ -0,0 +1,44 @@
+/*
+ * internal.h - printk internal definitions
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/percpu.h>
+
+typedef __printf(1, 0) int (*printk_func_t)(const char *fmt, va_list args);
+
+int __printf(1, 0) vprintk_default(const char *fmt, va_list args);
+
+#ifdef CONFIG_PRINTK_NMI
+
+/*
+ * printk() could not take logbuf_lock in NMI context. Instead,
+ * it temporary stores the strings into a per-CPU buffer.
+ * The alternative implementation is chosen transparently
+ * via per-CPU variable.
+ */
+DECLARE_PER_CPU(printk_func_t, printk_func);
+static inline __printf(1, 0) int vprintk_func(const char *fmt, va_list args)
+{
+	return this_cpu_read(printk_func)(fmt, args);
+}
+
+#else /* CONFIG_PRINTK_NMI */
+
+static inline __printf(1, 0) int vprintk_func(const char *fmt, va_list args)
+{
+	return vprintk_default(fmt, args);
+}
+
+#endif /* CONFIG_PRINTK_NMI */
diff -puN kernel/printk/nmi.c~printk-nmi-generic-solution-for-safe-printk-in-nmi-v4 kernel/printk/nmi.c
--- a/kernel/printk/nmi.c~printk-nmi-generic-solution-for-safe-printk-in-nmi-v4
+++ a/kernel/printk/nmi.c
@@ -22,7 +22,7 @@
 #include <linux/irq_work.h>
 #include <linux/printk.h>
 
-#include "printk.h"
+#include "internal.h"
 
 /*
  * printk() could not take logbuf_lock in NMI context. Instead,
@@ -57,12 +57,13 @@ static DEFINE_PER_CPU(struct nmi_seq_buf
 static int vprintk_nmi(const char *fmt, va_list args)
 {
 	struct nmi_seq_buf *s = this_cpu_ptr(&nmi_print_seq);
-	int add = 0, len;
+	int add = 0;
+	size_t len;
 
 again:
 	len = atomic_read(&s->len);
 
-	if (len >=  sizeof(s->buffer))
+	if (len >= sizeof(s->buffer))
 		return 0;
 
 	/*
@@ -109,7 +110,8 @@ static void __printk_nmi_flush(struct ir
 	static raw_spinlock_t read_lock =
 		__RAW_SPIN_LOCK_INITIALIZER(read_lock);
 	struct nmi_seq_buf *s = container_of(work, struct nmi_seq_buf, work);
-	int len, size, i, last_i;
+	size_t len, size;
+	int i, last_i;
 
 	/*
 	 * The lock has two functions. First, one reader has to flush all
@@ -129,7 +131,9 @@ more:
 	 * the buffer an unexpected way. If we printed something then
 	 * @len must only increase.
 	 */
-	WARN_ON(i && i >= len);
+	if (i && i >= len)
+		pr_err("printk_nmi_flush: internal error: i=%d >= len=%lu\n",
+		       i, len);
 
 	if (!len)
 		goto out; /* Someone else has already flushed the buffer. */
diff -puN kernel/printk/printk.c~printk-nmi-generic-solution-for-safe-printk-in-nmi-v4 kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-nmi-generic-solution-for-safe-printk-in-nmi-v4
+++ a/kernel/printk/printk.c
@@ -55,7 +55,7 @@
 
 #include "console_cmdline.h"
 #include "braille.h"
-#include "printk.h"
+#include "internal.h"
 
 int console_printk[4] = {
 	CONSOLE_LOGLEVEL_DEFAULT,	/* console_loglevel */
diff -puN kernel/printk/printk.h~printk-nmi-generic-solution-for-safe-printk-in-nmi-v4 /dev/null
--- a/kernel/printk/printk.h
+++ /dev/null
@@ -1,44 +0,0 @@
-/*
- * printk.h - printk internal definitions
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
- */
-#include <linux/percpu.h>
-
-typedef __printf(1, 0) int (*printk_func_t)(const char *fmt, va_list args);
-
-int __printf(1, 0) vprintk_default(const char *fmt, va_list args);
-
-#ifdef CONFIG_PRINTK_NMI
-
-/*
- * printk() could not take logbuf_lock in NMI context. Instead,
- * it temporary stores the strings into a per-CPU buffer.
- * The alternative implementation is chosen transparently
- * via per-CPU variable.
- */
-DECLARE_PER_CPU(printk_func_t, printk_func);
-static inline __printf(1, 0) int vprintk_func(const char *fmt, va_list args)
-{
-	return this_cpu_read(printk_func)(fmt, args);
-}
-
-#else /* CONFIG_PRINTK_NMI */
-
-static inline __printf(1, 0) int vprintk_func(const char *fmt, va_list args)
-{
-	return vprintk_default(fmt, args);
-}
