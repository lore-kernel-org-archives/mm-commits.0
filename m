From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch added to -mm
 tree
Date: Mon, 08 Jun 2020 16:33:07 -0700
Message-ID: <20200608233307.NbC98GVPX%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732028AbgFHXdI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 19:33:08 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, christian.brauner@ubuntu.com, geert@linux-m68k.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: lib-test-get_count_order-long-in-test_bitopsc-fix-fix
has been added to the -mm tree.  Its filename is
     lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch

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
Subject: lib-test-get_count_order-long-in-test_bitopsc-fix-fix

fix loop bound, per Wei Yang

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_bitops.c~lib-test-get_count_order-long-in-test_bitopsc-fix-fix
+++ a/lib/test_bitops.c
@@ -74,7 +74,7 @@ static int __init test_bitops_startup(vo
 	}
 
 #ifdef CONFIG_64BIT
-	for (i = 0; i < ARRAY_SIZE(order_comb); i++) {
+	for (i = 0; i < ARRAY_SIZE(order_comb_long); i++) {
 		if (order_comb_long[i][1] !=
 			       get_count_order_long(order_comb_long[i][0]))
 			pr_warn("get_count_order_long wrong for %lx\n",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-git-rejects.patch
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
kernel-forkc-export-kernel_thread-to-modules.patch
