From: akpm@linux-foundation.org
Subject: [folded] vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 31 May 2012 16:14:00 -0700
Message-ID: <20120531231400.817DAA009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:48400 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758590Ab2EaXOC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2012 19:14:02 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so82859lag.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:14:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch

This patch was dropped because it was folded into vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes

ERROR: "(foo*)" should be "(foo *)"
#20: FILE: lib/vsprintf.c:869:
+	int default_width = 2 * sizeof(void*) + (spec.flags & SPECIAL ? 2 : 0);

total: 1 errors, 0 warnings, 32 lines checked

./patches/vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes
+++ a/lib/vsprintf.c
@@ -866,7 +866,7 @@ static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	      struct printf_spec spec)
 {
-	int default_width = 2 * sizeof(void*) + (spec.flags & SPECIAL ? 2 : 0);
+	int default_width = 2 * sizeof(void *) + (spec.flags & SPECIAL ? 2 : 0);
 
 	if (!ptr && *fmt != 'K') {
 		/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
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

