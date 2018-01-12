From: akpm@linux-foundation.org
Subject: + procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps.patch added to -mm tree
Date: Fri, 12 Jan 2018 15:33:19 -0800
Message-ID: <5a5945bf.pAlvCITuMHsTiVaq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57738 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965302AbeALXdU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 Jan 2018 18:33:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, adobriyan@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: add seq_put_hex_ll to speed up /proc/pid/maps
has been added to the -mm tree.  Its filename is
     procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrei Vagin <avagin@openvz.org>
Subject: procfs: add seq_put_hex_ll to speed up /proc/pid/maps

seq_put_hex_ll() prints a number in hexadecimal notation and works faster
than seq_printf().

== test.py
num = 0
with open("/proc/1/maps") as f:
        while num < 10000 :
                data = f.read()
                f.seek(0, 0)
                num = num + 1
==

== Before patch ==
$  time python test.py

real	0m1.561s
user	0m0.257s
sys	0m1.302s

== After patch ==
$ time python test.py

real	0m0.986s
user	0m0.279s
sys	0m0.707s

$ perf -g record python test.py:

== Before patch ==
-   67.42%     2.82%  python   [kernel.kallsyms] [k] show_map_vma.isra.22
   - 64.60% show_map_vma.isra.22
      - 44.98% seq_printf
         - seq_vprintf
            - vsnprintf
               + 14.85% number
               + 12.22% format_decode
                 5.56% memcpy_erms
      + 15.06% seq_path
      + 4.42% seq_pad
   + 2.45% __GI___libc_read

== After patch ==
-   47.35%     3.38%  python   [kernel.kallsyms] [k] show_map_vma.isra.23
   - 43.97% show_map_vma.isra.23
      + 20.84% seq_path
      - 15.73% show_vma_header_prefix
           10.55% seq_put_hex_ll
         + 2.65% seq_put_decimal_ull
           0.95% seq_putc
      + 6.96% seq_pad
   + 2.94% __GI___libc_read

Link: http://lkml.kernel.org/r/20180112185812.7710-1-avagin@openvz.org
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c       |   21 ++++++----
 fs/seq_file.c            |   74 +++++++++++++++++++++++++++++++------
 include/linux/seq_file.h |    3 +
 3 files changed, 77 insertions(+), 21 deletions(-)

diff -puN fs/proc/task_mmu.c~procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps
+++ a/fs/proc/task_mmu.c
@@ -287,15 +287,18 @@ static void show_vma_header_prefix(struc
 				   dev_t dev, unsigned long ino)
 {
 	seq_setwidth(m, 25 + sizeof(void *) * 6 - 1);
-	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu ",
-		   start,
-		   end,
-		   flags & VM_READ ? 'r' : '-',
-		   flags & VM_WRITE ? 'w' : '-',
-		   flags & VM_EXEC ? 'x' : '-',
-		   flags & VM_MAYSHARE ? 's' : 'p',
-		   pgoff,
-		   MAJOR(dev), MINOR(dev), ino);
+	seq_put_hex_ll(m, NULL, start, 8);
+	seq_put_hex_ll(m, "-", end, 8);
+	seq_putc(m, ' ');
+	seq_putc(m, flags & VM_READ ? 'r' : '-');
+	seq_putc(m, flags & VM_WRITE ? 'w' : '-');
+	seq_putc(m, flags & VM_EXEC ? 'x' : '-');
+	seq_putc(m, flags & VM_MAYSHARE ? 's' : 'p');
+	seq_put_hex_ll(m, " ", pgoff, 8);
+	seq_put_hex_ll(m, " ", MAJOR(dev), 2);
+	seq_put_hex_ll(m, ":", MINOR(dev), 2);
+	seq_put_decimal_ull(m, " ", ino);
+	seq_putc(m, ' ');
 }
 
 static void
diff -puN fs/seq_file.c~procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps fs/seq_file.c
--- a/fs/seq_file.c~procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps
+++ a/fs/seq_file.c
@@ -670,6 +670,26 @@ void seq_puts(struct seq_file *m, const
 }
 EXPORT_SYMBOL(seq_puts);
 
+static inline void seq_put_delimeter(struct seq_file *m, const char *delimiter)
+{
+	int len;
+
+	if (!delimiter || !delimiter[0])
+		return;
+
+	if (delimiter[1] == 0)
+		return seq_putc(m, delimiter[0]);
+
+	len = strlen(delimiter);
+	if (m->count + len >= m->size) {
+		seq_set_overflow(m);
+		return;
+	}
+
+	memcpy(m->buf + m->count, delimiter, len);
+	m->count += len;
+}
+
 /*
  * A helper routine for putting decimal numbers without rich format of printf().
  * only 'unsigned long long' is supported.
@@ -685,12 +705,7 @@ void seq_put_decimal_ull(struct seq_file
 	if (m->count + 2 >= m->size) /* we'll write 2 bytes at least */
 		goto overflow;
 
-	len = strlen(delimiter);
-	if (m->count + len >= m->size)
-		goto overflow;
-
-	memcpy(m->buf + m->count, delimiter, len);
-	m->count += len;
+	seq_put_delimeter(m, delimiter);
 
 	if (m->count + 1 >= m->size)
 		goto overflow;
@@ -712,6 +727,46 @@ overflow:
 }
 EXPORT_SYMBOL(seq_put_decimal_ull);
 
+/**
+ * seq_put_hex_ll - put a number in hexadecimal notation
+ * @m: seq_file identifying the buffer to which data should be written
+ * @delimiter: a string which is printed before the number
+ * @v: the number
+ * @width: a minimum field width
+ *
+ * seq_put_hex_ll(m, "", v, 8) is equal to seq_printf(m, "0x08llx", v)
+ *
+ * This routine is very quick when you show lots of numbers.
+ * In usual cases, it will be better to use seq_printf(). It's easier to read.
+ */
+void seq_put_hex_ll(struct seq_file *m, const char *delimiter,
+				unsigned long long v, int width)
+{
+	int i, len;
+
+	seq_put_delimeter(m, delimiter);
+
+	len = (sizeof(v) * 8 - __builtin_clzll(v) + 3) / 4;
+
+	if (unlikely(len == 0))
+		len = 1;
+
+	if (len < width)
+		len = width;
+
+	if (m->count + len > m->size)
+		goto overflow;
+
+	for (i = len - 1; i >= 0; i--) {
+		m->buf[m->count + i] = hex_asc[0xf & v];
+		v = v >> 4;
+	}
+	m->count += len;
+	return;
+overflow:
+	seq_set_overflow(m);
+}
+
 void seq_put_decimal_ll(struct seq_file *m, const char *delimiter, long long num)
 {
 	int len;
@@ -719,12 +774,7 @@ void seq_put_decimal_ll(struct seq_file
 	if (m->count + 3 >= m->size) /* we'll write 2 bytes at least */
 		goto overflow;
 
-	len = strlen(delimiter);
-	if (m->count + len >= m->size)
-		goto overflow;
-
-	memcpy(m->buf + m->count, delimiter, len);
-	m->count += len;
+	seq_put_delimeter(m, delimiter);
 
 	if (m->count + 2 >= m->size)
 		goto overflow;
diff -puN include/linux/seq_file.h~procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps include/linux/seq_file.h
--- a/include/linux/seq_file.h~procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps
+++ a/include/linux/seq_file.h
@@ -121,6 +121,9 @@ void seq_puts(struct seq_file *m, const
 void seq_put_decimal_ull(struct seq_file *m, const char *delimiter,
 			 unsigned long long num);
 void seq_put_decimal_ll(struct seq_file *m, const char *delimiter, long long num);
+void seq_put_hex_ll(struct seq_file *m, const char *delimiter,
+		    unsigned long long v, int width);
+
 void seq_escape(struct seq_file *m, const char *s, const char *esc);
 
 void seq_hex_dump(struct seq_file *m, const char *prefix_str, int prefix_type,
_

Patches currently in -mm which might be from avagin@openvz.org are

fs-elf-drop-map_fixed-usage-from-elf_map-fix.patch
procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps.patch
procfs-optimize-seq_pad-to-speed-up-proc-pid-maps.patch

