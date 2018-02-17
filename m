From: akpm@linux-foundation.org
Subject: +
 proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps.patch added
 to -mm tree
Date: Fri, 16 Feb 2018 16:47:04 -0800
Message-ID: <5a877b88.TXOZCJ5aSSyCeMNj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51930 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbeBQArF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 19:47:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, adobriyan@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: add seq_put_decimal_ull_width to speed up /proc/pid/smaps
has been added to the -mm tree.  Its filename is
     proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps.patch

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
Subject: proc: add seq_put_decimal_ull_width to speed up /proc/pid/smaps

seq_put_decimal_ull_w(m, str, val, width) prints a decimal number with a
specified minimal field width.

It is equivalent of seq_printf(m, "%s%*d", str, width, val), but it
works much faster.

== test_smaps.py
num = 0
with open("/proc/1/smaps") as f:
        for x in xrange(10000):
                data = f.read()
                f.seek(0, 0)
==

== Before patch ==
$ time python test_smaps.py

real    0m4.593s
user    0m0.398s
sys     0m4.158s

== After patch ==
$ time python test_smaps.py

real    0m3.828s
user    0m0.413s
sys     0m3.408s

$ perf -g record python test_smaps.py
== Before patch ==
-   79.01%     3.36%  python   [kernel.kallsyms]    [k] show_smap.isra.33
   - 75.65% show_smap.isra.33
      + 48.85% seq_printf
      + 15.75% __walk_page_range
      + 9.70% show_map_vma.isra.23
        0.61% seq_puts

== After patch ==
-   75.51%     4.62%  python   [kernel.kallsyms]    [k] show_smap.isra.33
   - 70.88% show_smap.isra.33
      + 24.82% seq_put_decimal_ull_w
      + 19.78% __walk_page_range
      + 12.74% seq_printf
      + 11.08% show_map_vma.isra.23
      + 1.68% seq_puts

Link: http://lkml.kernel.org/r/20180212074931.7227-1-avagin@openvz.org
Signed-off-by: Andrei Vagin <avagin@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c        |   15 ----
 fs/proc/task_mmu.c       |  129 +++++++++++++++----------------------
 fs/seq_file.c            |   28 ++++++--
 include/linux/kernel.h   |    3 
 include/linux/seq_file.h |    2 
 lib/vsprintf.c           |   18 ++++-
 6 files changed, 93 insertions(+), 102 deletions(-)

diff -puN fs/proc/meminfo.c~proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps
+++ a/fs/proc/meminfo.c
@@ -26,20 +26,7 @@ void __attribute__((weak)) arch_report_m
 
 static void show_val_kb(struct seq_file *m, const char *s, unsigned long num)
 {
-	char v[32];
-	static const char blanks[7] = {' ', ' ', ' ', ' ',' ', ' ', ' '};
-	int len;
-
-	len = num_to_str(v, sizeof(v), num << (PAGE_SHIFT - 10));
-
-	seq_write(m, s, 16);
-
-	if (len > 0) {
-		if (len < 8)
-			seq_write(m, blanks, 8 - len);
-
-		seq_write(m, v, len);
-	}
+	seq_put_decimal_ull_width(m, s, num << (PAGE_SHIFT - 10), 8);
 	seq_write(m, " kB\n", 4);
 }
 
diff -puN fs/proc/task_mmu.c~proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps
+++ a/fs/proc/task_mmu.c
@@ -24,6 +24,8 @@
 #include <asm/tlbflush.h>
 #include "internal.h"
 
+#define SEQ_PUT_DEC(str, val) \
+		seq_put_decimal_ull_width(m, str, (val) << (PAGE_SHIFT-10), 8)
 void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
 	unsigned long text, lib, swap, anon, file, shmem;
@@ -53,39 +55,28 @@ void task_mem(struct seq_file *m, struct
 	lib = (mm->exec_vm << PAGE_SHIFT) - text;
 
 	swap = get_mm_counter(mm, MM_SWAPENTS);
-	seq_printf(m,
-		"VmPeak:\t%8lu kB\n"
-		"VmSize:\t%8lu kB\n"
-		"VmLck:\t%8lu kB\n"
-		"VmPin:\t%8lu kB\n"
-		"VmHWM:\t%8lu kB\n"
-		"VmRSS:\t%8lu kB\n"
-		"RssAnon:\t%8lu kB\n"
-		"RssFile:\t%8lu kB\n"
-		"RssShmem:\t%8lu kB\n"
-		"VmData:\t%8lu kB\n"
-		"VmStk:\t%8lu kB\n"
-		"VmExe:\t%8lu kB\n"
-		"VmLib:\t%8lu kB\n"
-		"VmPTE:\t%8lu kB\n"
-		"VmSwap:\t%8lu kB\n",
-		hiwater_vm << (PAGE_SHIFT-10),
-		total_vm << (PAGE_SHIFT-10),
-		mm->locked_vm << (PAGE_SHIFT-10),
-		mm->pinned_vm << (PAGE_SHIFT-10),
-		hiwater_rss << (PAGE_SHIFT-10),
-		total_rss << (PAGE_SHIFT-10),
-		anon << (PAGE_SHIFT-10),
-		file << (PAGE_SHIFT-10),
-		shmem << (PAGE_SHIFT-10),
-		mm->data_vm << (PAGE_SHIFT-10),
-		mm->stack_vm << (PAGE_SHIFT-10),
-		text >> 10,
-		lib >> 10,
-		mm_pgtables_bytes(mm) >> 10,
-		swap << (PAGE_SHIFT-10));
+	SEQ_PUT_DEC("VmPeak:\t", hiwater_vm);
+	SEQ_PUT_DEC(" kB\nVmSize:\t", total_vm);
+	SEQ_PUT_DEC(" kB\nVmLck:\t", mm->locked_vm);
+	SEQ_PUT_DEC(" kB\nVmPin:\t", mm->pinned_vm);
+	SEQ_PUT_DEC(" kB\nVmHWM:\t", hiwater_rss);
+	SEQ_PUT_DEC(" kB\nVmRSS:\t", total_rss);
+	SEQ_PUT_DEC(" kB\nRssAnon:\t", anon);
+	SEQ_PUT_DEC(" kB\nRssFile:\t", file);
+	SEQ_PUT_DEC(" kB\nRssShmem:\t", shmem);
+	SEQ_PUT_DEC(" kB\nVmData:\t", mm->data_vm);
+	SEQ_PUT_DEC(" kB\nVmStk:\t", mm->stack_vm);
+	seq_put_decimal_ull_width(m,
+		    " kB\nVmExe:\t", text >> 10, 8);
+	seq_put_decimal_ull_width(m,
+		    " kB\nVmLib:\t", lib >> 10, 8);
+	seq_put_decimal_ull_width(m,
+		    " kB\nVmPTE:\t", mm_pgtables_bytes(mm) >> 10, 8);
+	SEQ_PUT_DEC(" kB\nVmSwap:\t", swap);
+	seq_puts(m, " kB\n");
 	hugetlb_report_usage(m, mm);
 }
+#undef SEQ_PUT_DEC
 
 unsigned long task_vsize(struct mm_struct *mm)
 {
@@ -739,6 +730,8 @@ void __weak arch_show_smap(struct seq_fi
 {
 }
 
+#define SEQ_PUT_DEC(str, val) \
+		seq_put_decimal_ull_width(m, str, (val) >> 10, 8)
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
 	struct proc_maps_private *priv = m->private;
@@ -812,51 +805,34 @@ static int show_smap(struct seq_file *m,
 		ret = SEQ_SKIP;
 	}
 
-	if (!rollup_mode)
-		seq_printf(m,
-			   "Size:           %8lu kB\n"
-			   "KernelPageSize: %8lu kB\n"
-			   "MMUPageSize:    %8lu kB\n",
-			   (vma->vm_end - vma->vm_start) >> 10,
-			   vma_kernel_pagesize(vma) >> 10,
-			   vma_mmu_pagesize(vma) >> 10);
-
-
-	if (!rollup_mode || last_vma)
-		seq_printf(m,
-			   "Rss:            %8lu kB\n"
-			   "Pss:            %8lu kB\n"
-			   "Shared_Clean:   %8lu kB\n"
-			   "Shared_Dirty:   %8lu kB\n"
-			   "Private_Clean:  %8lu kB\n"
-			   "Private_Dirty:  %8lu kB\n"
-			   "Referenced:     %8lu kB\n"
-			   "Anonymous:      %8lu kB\n"
-			   "LazyFree:       %8lu kB\n"
-			   "AnonHugePages:  %8lu kB\n"
-			   "ShmemPmdMapped: %8lu kB\n"
-			   "Shared_Hugetlb: %8lu kB\n"
-			   "Private_Hugetlb: %7lu kB\n"
-			   "Swap:           %8lu kB\n"
-			   "SwapPss:        %8lu kB\n"
-			   "Locked:         %8lu kB\n",
-			   mss->resident >> 10,
-			   (unsigned long)(mss->pss >> (10 + PSS_SHIFT)),
-			   mss->shared_clean  >> 10,
-			   mss->shared_dirty  >> 10,
-			   mss->private_clean >> 10,
-			   mss->private_dirty >> 10,
-			   mss->referenced >> 10,
-			   mss->anonymous >> 10,
-			   mss->lazyfree >> 10,
-			   mss->anonymous_thp >> 10,
-			   mss->shmem_thp >> 10,
-			   mss->shared_hugetlb >> 10,
-			   mss->private_hugetlb >> 10,
-			   mss->swap >> 10,
-			   (unsigned long)(mss->swap_pss >> (10 + PSS_SHIFT)),
-			   (unsigned long)(mss->pss >> (10 + PSS_SHIFT)));
-
+	if (!rollup_mode) {
+		SEQ_PUT_DEC("Size:           ", vma->vm_end - vma->vm_start);
+		SEQ_PUT_DEC(" kB\nKernelPageSize: ", vma_kernel_pagesize(vma));
+		SEQ_PUT_DEC(" kB\nMMUPageSize:    ", vma_mmu_pagesize(vma));
+		seq_puts(m, " kB\n");
+	}
+
+	if (!rollup_mode || last_vma) {
+		SEQ_PUT_DEC("Rss:            ", mss->resident);
+		SEQ_PUT_DEC(" kB\nPss:            ", mss->pss >> PSS_SHIFT);
+		SEQ_PUT_DEC(" kB\nShared_Clean:   ", mss->shared_clean);
+		SEQ_PUT_DEC(" kB\nShared_Dirty:   ", mss->shared_dirty);
+		SEQ_PUT_DEC(" kB\nPrivate_Clean:  ", mss->private_clean);
+		SEQ_PUT_DEC(" kB\nPrivate_Dirty:  ", mss->private_dirty);
+		SEQ_PUT_DEC(" kB\nReferenced:     ", mss->referenced);
+		SEQ_PUT_DEC(" kB\nAnonymous:      ", mss->anonymous);
+		SEQ_PUT_DEC(" kB\nLazyFree:       ", mss->lazyfree);
+		SEQ_PUT_DEC(" kB\nAnonHugePages:  ", mss->anonymous_thp);
+		SEQ_PUT_DEC(" kB\nShmemPmdMapped: ", mss->shmem_thp);
+		SEQ_PUT_DEC(" kB\nShared_Hugetlb: ", mss->shared_hugetlb);
+		seq_put_decimal_ull_width(m, " kB\nPrivate_Hugetlb: ",
+					  mss->private_hugetlb >> 10, 7);
+		SEQ_PUT_DEC(" kB\nSwap:           ", mss->swap);
+		SEQ_PUT_DEC(" kB\nSwapPss:        ",
+						mss->swap_pss >> PSS_SHIFT);
+		SEQ_PUT_DEC(" kB\nLocked:         ", mss->pss >> PSS_SHIFT);
+		seq_puts(m, " kB\n");
+	}
 	if (!rollup_mode) {
 		arch_show_smap(m, vma);
 		show_smap_vma_flags(m, vma);
@@ -864,6 +840,7 @@ static int show_smap(struct seq_file *m,
 	m_cache_vma(m, vma);
 	return ret;
 }
+#undef SEQ_PUT_DEC
 
 static int show_pid_smap(struct seq_file *m, void *v)
 {
diff -puN fs/seq_file.c~proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps fs/seq_file.c
--- a/fs/seq_file.c~proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps
+++ a/fs/seq_file.c
@@ -673,15 +673,20 @@ void seq_puts(struct seq_file *m, const
 }
 EXPORT_SYMBOL(seq_puts);
 
-/*
+/**
  * A helper routine for putting decimal numbers without rich format of printf().
  * only 'unsigned long long' is supported.
- * This routine will put strlen(delimiter) + number into seq_file.
+ * @m: seq_file identifying the buffer to which data should be written
+ * @delimiter: a string which is printed before the number
+ * @num: the number
+ * @width: a minimum field width
+ *
+ * This routine will put strlen(delimiter) + number into seq_filed.
  * This routine is very quick when you show lots of numbers.
  * In usual cases, it will be better to use seq_printf(). It's easier to read.
  */
-void seq_put_decimal_ull(struct seq_file *m, const char *delimiter,
-			 unsigned long long num)
+void seq_put_decimal_ull_width(struct seq_file *m, const char *delimiter,
+			 unsigned long long num, unsigned int width)
 {
 	int len;
 
@@ -695,7 +700,10 @@ void seq_put_decimal_ull(struct seq_file
 	memcpy(m->buf + m->count, delimiter, len);
 	m->count += len;
 
-	if (m->count + 1 >= m->size)
+	if (!width)
+		width = 1;
+
+	if (m->count + width >= m->size)
 		goto overflow;
 
 	if (num < 10) {
@@ -703,7 +711,7 @@ void seq_put_decimal_ull(struct seq_file
 		return;
 	}
 
-	len = num_to_str(m->buf + m->count, m->size - m->count, num);
+	len = num_to_str(m->buf + m->count, m->size - m->count, num, width);
 	if (!len)
 		goto overflow;
 
@@ -713,6 +721,12 @@ void seq_put_decimal_ull(struct seq_file
 overflow:
 	seq_set_overflow(m);
 }
+
+void seq_put_decimal_ull(struct seq_file *m, const char *delimiter,
+			 unsigned long long num)
+{
+	return seq_put_decimal_ull_width(m, delimiter, num, 0);
+}
 EXPORT_SYMBOL(seq_put_decimal_ull);
 
 /**
@@ -788,7 +802,7 @@ void seq_put_decimal_ll(struct seq_file
 		return;
 	}
 
-	len = num_to_str(m->buf + m->count, m->size - m->count, num);
+	len = num_to_str(m->buf + m->count, m->size - m->count, num, 0);
 	if (!len)
 		goto overflow;
 
diff -puN include/linux/kernel.h~proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps include/linux/kernel.h
--- a/include/linux/kernel.h~proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps
+++ a/include/linux/kernel.h
@@ -439,7 +439,8 @@ extern long simple_strtol(const char *,c
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
 extern long long simple_strtoll(const char *,char **,unsigned int);
 
-extern int num_to_str(char *buf, int size, unsigned long long num);
+extern int num_to_str(char *buf, int size,
+		      unsigned long long num, unsigned int width);
 
 /* lib/printf utilities */
 
diff -puN include/linux/seq_file.h~proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps include/linux/seq_file.h
--- a/include/linux/seq_file.h~proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps
+++ a/include/linux/seq_file.h
@@ -118,6 +118,8 @@ __printf(2, 3)
 void seq_printf(struct seq_file *m, const char *fmt, ...);
 void seq_putc(struct seq_file *m, char c);
 void seq_puts(struct seq_file *m, const char *s);
+void seq_put_decimal_ull_width(struct seq_file *m, const char *delimiter,
+			       unsigned long long num, unsigned int width);
 void seq_put_decimal_ull(struct seq_file *m, const char *delimiter,
 			 unsigned long long num);
 void seq_put_decimal_ll(struct seq_file *m, const char *delimiter, long long num);
diff -puN lib/vsprintf.c~proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps lib/vsprintf.c
--- a/lib/vsprintf.c~proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps
+++ a/lib/vsprintf.c
@@ -336,7 +336,7 @@ char *put_dec(char *buf, unsigned long l
  *
  * If speed is not important, use snprintf(). It's easy to read the code.
  */
-int num_to_str(char *buf, int size, unsigned long long num)
+int num_to_str(char *buf, int size, unsigned long long num, unsigned int width)
 {
 	/* put_dec requires 2-byte alignment of the buffer. */
 	char tmp[sizeof(num) * 3] __aligned(2);
@@ -350,11 +350,21 @@ int num_to_str(char *buf, int size, unsi
 		len = put_dec(tmp, num) - tmp;
 	}
 
-	if (len > size)
+	if (len > size || width > size)
 		return 0;
+
+	if (width > len) {
+		width = width - len;
+		for (idx = 0; idx < width; idx++)
+			buf[idx] = ' ';
+	} else {
+		width = 0;
+	}
+
 	for (idx = 0; idx < len; ++idx)
-		buf[idx] = tmp[len - idx - 1];
-	return len;
+		buf[idx + width] = tmp[len - idx - 1];
+
+	return len + width;
 }
 
 #define SIGN	1		/* unsigned/signed, must be 1 */
_

Patches currently in -mm which might be from avagin@openvz.org are

procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps.patch
procfs-add-seq_put_hex_ll-to-speed-up-proc-pid-maps-v3.patch
procfs-optimize-seq_pad-to-speed-up-proc-pid-maps.patch
proc-add-seq_put_decimal_ull_width-to-speed-up-proc-pid-smaps.patch
proc-replace-seq_printf-on-seq_putc-to-speed-up-proc-pid-smaps.patch
proc-optimize-single-symbol-delimiters-to-spead-up-seq_put_decimal_ull.patch
proc-replace-seq_printf-by-seq_put_smth-to-speed-up-proc-pid-status.patch

