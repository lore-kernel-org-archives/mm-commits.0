From: akpm@linux-foundation.org
Subject: [folded] vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 31 May 2012 16:14:23 -0700
Message-ID: <20120531231424.1C64BA009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61233 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592Ab2EaXOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:14:25 -0400
Received: by qabg24 with SMTP id g24so9804qab.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:14:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vda.linux@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vsprintf-further-optimize-decimal-conversion-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch

This patch was dropped because it was folded into vsprintf-further-optimize-decimal-conversion.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vsprintf-further-optimize-decimal-conversion-checkpatch-fixes

WARNING: line over 80 characters
#112: FILE: lib/vsprintf.c:136:
+	 * (x * 0x00cd) >> 11     x <       1029 shorter code than * 0x67 (on i386)

ERROR: trailing statements should be on next line
#192: FILE: lib/vsprintf.c:178:
+	if (q == 0) return buf;

ERROR: trailing statements should be on next line
#195: FILE: lib/vsprintf.c:181:
+	if (r == 0) return buf;

ERROR: trailing statements should be on next line
#198: FILE: lib/vsprintf.c:184:
+	if (q == 0) return buf;

ERROR: trailing statements should be on next line
#201: FILE: lib/vsprintf.c:187:
+	if (r == 0) return buf;

ERROR: trailing statements should be on next line
#204: FILE: lib/vsprintf.c:190:
+	if (q == 0) return buf;

ERROR: trailing statements should be on next line
#207: FILE: lib/vsprintf.c:193:
+	if (r == 0) return buf;

ERROR: trailing statements should be on next line
#210: FILE: lib/vsprintf.c:196:
+	if (q == 0) return buf;

ERROR: space prohibited after that '&' (ctx:WxW)
#290: FILE: lib/vsprintf.c:267:
+	d2  = (h      ) & 0xffff;
 	                ^

ERROR: space prohibited before that close parenthesis ')'
#290: FILE: lib/vsprintf.c:267:
+	d2  = (h      ) & 0xffff;

total: 9 errors, 1 warnings, 310 lines checked

./patches/vsprintf-further-optimize-decimal-conversion.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Denys Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-further-optimize-decimal-conversion-checkpatch-fixes lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-further-optimize-decimal-conversion-checkpatch-fixes
+++ a/lib/vsprintf.c
@@ -123,7 +123,8 @@ char *put_dec_full9(char *buf, unsigned 
 {
 	unsigned r;
 
-	/* Possible ways to approx. divide by 10
+	/*
+	 * Possible ways to approx. divide by 10
 	 * (x * 0x1999999a) >> 32 x < 1073741829 (multiply must be 64-bit)
 	 * (x * 0xcccd) >> 19     x <      81920 (x < 262149 when 64-bit mul)
 	 * (x * 0x6667) >> 18     x <      43699
@@ -175,25 +176,32 @@ char *put_dec_trunc8(char *buf, unsigned
 	/* Copy of previous function's body with added early returns */
 	q      = (r * (uint64_t)0x1999999a) >> 32;
 	*buf++ = (r - 10 * q) + '0'; /* 2 */
-	if (q == 0) return buf;
+	if (q == 0)
+		return buf;
 	r      = (q * (uint64_t)0x1999999a) >> 32;
 	*buf++ = (q - 10 * r) + '0'; /* 3 */
-	if (r == 0) return buf;
+	if (r == 0)
+		return buf;
 	q      = (r * (uint64_t)0x1999999a) >> 32;
 	*buf++ = (r - 10 * q) + '0'; /* 4 */
-	if (q == 0) return buf;
+	if (q == 0)
+		return buf;
 	r      = (q * (uint64_t)0x1999999a) >> 32;
 	*buf++ = (q - 10 * r) + '0'; /* 5 */
-	if (r == 0) return buf;
+	if (r == 0)
+		return buf;
 	q      = (r * 0x199a) >> 16;
 	*buf++ = (r - 10 * q)  + '0'; /* 6 */
-	if (q == 0) return buf;
+	if (q == 0)
+		return buf;
 	r      = (q * 0xcd) >> 11;
 	*buf++ = (q - 10 * r)  + '0'; /* 7 */
-	if (r == 0) return buf;
+	if (r == 0)
+		return buf;
 	q      = (r * 0xcd) >> 11;
 	*buf++ = (r - 10 * q) + '0'; /* 8 */
-	if (q == 0) return buf;
+	if (q == 0)
+		return buf;
 	*buf++ = q + '0'; /* 9 */
 	return buf;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch
vsprintf-further-optimize-decimal-conversion.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
kernel-cpuc-document-clear_tasks_mm_cpumask-fix.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
fs-nls-add-apple-nls-fix.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch

