From: akpm@linux-foundation.org
Subject: +
 hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch added to -mm tree
Date: Fri, 02 Jan 2015 15:24:49 -0800
Message-ID: <54a728c1.Z2NWz+nxadIJPSeC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbABXYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 18:24:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix
has been added to the -mm tree.  Its filename is
     hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch

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
Subject: hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix

fix printk warning

lib/test-hexdump.c: In function 'test_hexdump_overflow':
lib/test-hexdump.c:151: warning: format '%zu' expects type 'size_t', but argument 3 has type 'int'

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test-hexdump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/test-hexdump.c~hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix lib/test-hexdump.c
--- a/lib/test-hexdump.c~hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix
+++ a/lib/test-hexdump.c
@@ -148,7 +148,7 @@ static void __init test_hexdump_overflow
 	}
 
 	if (!a) {
-		pr_err("Len: %zu rc: %zu strlen: %zu\n", l, r, strlen(buf));
+		pr_err("Len: %zu rc: %u strlen: %zu\n", l, r, strlen(buf));
 		pr_err("Result: '%s'\n", buf);
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

