From: akpm@linux-foundation.org
Subject: [folded-merged]
 x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch removed
 from -mm tree
Date: Mon, 08 Jun 2020 20:26:00 -0700
Message-ID: <20200609032600.EqxjhRmhX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgFID0D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:26:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-use-non-set_fs-based-maccess-routines-x86-use-non-set_fs-based-maccess-routines
has been removed from the -mm tree.  Its filename was
     x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch

This patch was dropped because it was folded into x86-use-non-set_fs-based-maccess-routines.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-use-non-set_fs-based-maccess-routines-x86-use-non-set_fs-based-maccess-routines

WARNING: Macros with flow control statements should be avoided
#30: FILE: arch/x86/include/asm/uaccess.h:528:
+#define __get_kernel_nofault(dst, src, type, err_label)			\
+do {									\
+        int __kr_err;							\
+									\
+	__get_user_size(*((type *)dst), (__force type __user *)src,	\
+			sizeof(type), __kr_err);			\
+        if (unlikely(__kr_err))						\
+		goto err_label;						\
+} while (0)

ERROR: code indent should use tabs where possible
#32: FILE: arch/x86/include/asm/uaccess.h:530:
+        int __kr_err;^I^I^I^I^I^I^I\$

WARNING: please, no spaces at the start of a line
#32: FILE: arch/x86/include/asm/uaccess.h:530:
+        int __kr_err;^I^I^I^I^I^I^I\$

ERROR: code indent should use tabs where possible
#36: FILE: arch/x86/include/asm/uaccess.h:534:
+        if (unlikely(__kr_err))^I^I^I^I^I^I\$

WARNING: please, no spaces at the start of a line
#36: FILE: arch/x86/include/asm/uaccess.h:534:
+        if (unlikely(__kr_err))^I^I^I^I^I^I\$

total: 2 errors, 3 warnings, 21 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/x86-use-non-set_fs-based-maccess-routines.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uaccess.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/uaccess.h~x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes
+++ a/arch/x86/include/asm/uaccess.h
@@ -527,11 +527,11 @@ do {									\
 
 #define __get_kernel_nofault(dst, src, type, err_label)			\
 do {									\
-        int __kr_err;							\
+	int __kr_err;							\
 									\
 	__get_user_size(*((type *)dst), (__force type __user *)src,	\
 			sizeof(type), __kr_err);			\
-        if (unlikely(__kr_err))						\
+	if (unlikely(__kr_err))						\
 		goto err_label;						\
 } while (0)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
x86-use-non-set_fs-based-maccess-routines.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-git-rejects.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
