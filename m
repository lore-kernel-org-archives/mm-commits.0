From: akpm@linux-foundation.org
Subject: + vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch added to -mm tree
Date: Mon, 26 Mar 2012 12:53:24 -0700
Message-ID: <20120326195324.9A47DA0496@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:63853 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2CZTx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:53:27 -0400
Received: by wibhj13 with SMTP id hj13so234119wib.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:53:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, vda.linux@googlemail.com


The patch titled
     Subject: vsprintf-further-optimize-decimal-conversion-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: vsprintf-further-optimize-decimal-conversion-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
brlocks-lglocks-cleanups.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-change-behavior-of-moving-charges-at-task-move-fix.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

