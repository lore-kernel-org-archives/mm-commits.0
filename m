From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test-get_count_order-long-in-test_bitopsc-fix.patch
 added to -mm tree
Date: Fri, 05 Jun 2020 17:18:24 -0700
Message-ID: <20200606001824.-HvvcYX_b%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728275AbgFFAS1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 20:18:27 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, christian.brauner@ubuntu.com, geert@linux-m68k.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: lib-test-get_count_order-long-in-test_bitopsc-fix
has been added to the -mm tree.  Its filename is
     lib-test-get_count_order-long-in-test_bitopsc-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test-get_count_order-long-in-test_bitopsc-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test-get_count_order-long-in-test_bitopsc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-test-get_count_order-long-in-test_bitopsc-fix

- use order_comb[] to test get_count_order_long() as well, per Geert

- avoid warnings on 32-bit, reported by Geert

- coding-style cleanups

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitops.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/lib/test_bitops.c~lib-test-get_count_order-long-in-test_bitopsc-fix
+++ a/lib/test_bitops.c
@@ -28,7 +28,7 @@ enum bitops_fun {
 
 static DECLARE_BITMAP(g_bitmap, BITOPS_LENGTH);
 
-unsigned int order_comb[][2] = {
+static unsigned int order_comb[][2] = {
 	{0x00000003,  2},
 	{0x00000004,  2},
 	{0x00001fff, 13},
@@ -38,7 +38,8 @@ unsigned int order_comb[][2] = {
 	{0x80003000, 32},
 };
 
-unsigned long order_comb_long[][2] = {
+#ifdef CONFIG_64BIT
+static unsigned long order_comb_long[][2] = {
 	{0x0000000300000000, 34},
 	{0x0000000400000000, 34},
 	{0x00001fff00000000, 45},
@@ -47,6 +48,7 @@ unsigned long order_comb_long[][2] = {
 	{0x8000000000000000, 63},
 	{0x8000300000000000, 64},
 };
+#endif
 
 static int __init test_bitops_startup(void)
 {
@@ -62,14 +64,23 @@ static int __init test_bitops_startup(vo
 	for (i = 0; i < ARRAY_SIZE(order_comb); i++) {
 		if (order_comb[i][1] != get_count_order(order_comb[i][0]))
 			pr_warn("get_count_order wrong for %x\n",
-				       order_comb[i][0]); }
+				       order_comb[i][0]);
+	}
 
-	for (i = 0; i < ARRAY_SIZE(order_comb_long); i++) {
+	for (i = 0; i < ARRAY_SIZE(order_comb); i++) {
+		if (order_comb[i][1] != get_count_order_long(order_comb[i][0]))
+			pr_warn("get_count_order_long wrong for %x\n",
+				       order_comb[i][0]);
+	}
+
+#ifdef CONFIG_64BIT
+	for (i = 0; i < ARRAY_SIZE(order_comb); i++) {
 		if (order_comb_long[i][1] !=
 			       get_count_order_long(order_comb_long[i][0]))
 			pr_warn("get_count_order_long wrong for %lx\n",
-				       order_comb_long[i][0]); }
-
+				       order_comb_long[i][0]);
+	}
+#endif
 	return 0;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-git-rejects.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
