From: akpm@linux-foundation.org
Subject: + cpumask-add-cpumask_scnprintf_len-function.patch added to -mm tree
Date: Thu, 27 Mar 2008 01:00:34 -0700
Message-ID: <200803270800.m2R80YRr024709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754376AbYC0IAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 04:00:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, pj@sgi.com


The patch titled
     cpumask: Add cpumask_scnprintf_len function
has been added to the -mm tree.  Its filename is
     cpumask-add-cpumask_scnprintf_len-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpumask: Add cpumask_scnprintf_len function
From: Mike Travis <travis@sgi.com>

Add a new function cpumask_scnprintf_len() to return the number of characters
needed to display "len" cpumask bits.  The current method of allocating
NR_CPUS bytes is incorrect as what's really needed is 9 characters per 32-bit
word of cpumask bits (8 hex digits plus the seperator [','] or the terminating
NULL.) This function provides the caller the means to allocate the correct
string length.

Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h  |    1 +
 include/linux/cpumask.h |    7 +++++++
 lib/bitmap.c            |   16 ++++++++++++++++
 3 files changed, 24 insertions(+)

diff -puN include/linux/bitmap.h~cpumask-add-cpumask_scnprintf_len-function include/linux/bitmap.h
--- a/include/linux/bitmap.h~cpumask-add-cpumask_scnprintf_len-function
+++ a/include/linux/bitmap.h
@@ -110,6 +110,7 @@ extern int __bitmap_weight(const unsigne
 
 extern int bitmap_scnprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
+extern int bitmap_scnprintf_len(unsigned int len);
 extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
 			unsigned long *dst, int nbits);
 extern int bitmap_parse_user(const char __user *ubuf, unsigned int ulen,
diff -puN include/linux/cpumask.h~cpumask-add-cpumask_scnprintf_len-function include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-add-cpumask_scnprintf_len-function
+++ a/include/linux/cpumask.h
@@ -277,6 +277,13 @@ static inline int __cpumask_scnprintf(ch
 	return bitmap_scnprintf(buf, len, srcp->bits, nbits);
 }
 
+#define cpumask_scnprintf_len(len) \
+			__cpumask_scnprintf_len((len))
+static inline int __cpumask_scnprintf_len(int len)
+{
+	return bitmap_scnprintf_len(len);
+}
+
 #define cpumask_parse_user(ubuf, ulen, dst) \
 			__cpumask_parse_user((ubuf), (ulen), &(dst), NR_CPUS)
 static inline int __cpumask_parse_user(const char __user *buf, int len,
diff -puN lib/bitmap.c~cpumask-add-cpumask_scnprintf_len-function lib/bitmap.c
--- a/lib/bitmap.c~cpumask-add-cpumask_scnprintf_len-function
+++ a/lib/bitmap.c
@@ -316,6 +316,22 @@ int bitmap_scnprintf(char *buf, unsigned
 EXPORT_SYMBOL(bitmap_scnprintf);
 
 /**
+ * bitmap_scnprintf_len - return buffer length needed to convert
+ * bitmap to an ASCII hex string.
+ * @len: number of bits to be converted
+ */
+int bitmap_scnprintf_len(unsigned int len)
+{
+	/* we need 9 chars per word for 32 bit words (8 hexdigits + sep/null) */
+	int bitslen = ALIGN(len, CHUNKSZ);
+	int wordlen = CHUNKSZ / 4;
+	int buflen = (bitslen / wordlen) * (wordlen + 1) * sizeof(char);
+
+	return buflen;
+}
+EXPORT_SYMBOL(bitmap_scnprintf_len);
+
+/**
  * __bitmap_parse - convert an ASCII hex string into a bitmap.
  * @buf: pointer to buffer containing string.
  * @buflen: buffer size in bytes.  If string is smaller than this
_

Patches currently in -mm which might be from travis@sgi.com are

git-cpufreq.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
cpufreq-change-cpu-freq-arrays-to-per_cpu-variables.patch
acpi-change-processors-from-array-to-per_cpu-variable.patch
cpumask-add-cpumask_scnprintf_len-function.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch
net-remove-nr_cpus-arrays-in-net-core-devc-v2.patch
sched-remove-fixed-nr_cpus-sized-arrays-in-kernel_schedc.patch

