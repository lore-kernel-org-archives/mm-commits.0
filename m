From: akpm@linux-foundation.org
Subject: [folded-merged]
 compiler-dont-perform-compiletime_assert-with-o0-fix.patch removed from -mm tree
Date: Thu, 31 Aug 2017 14:47:13 -0700
Message-ID: <59a883e1.FcwOYEdbEmx4QAf2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56814 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbdHaVrO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Aug 2017 17:47:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, abbotti@mev.co.uk, arnd@arndb.de, joe@ovn.org, keescook@chromium.org, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-dont-perform-compiletime_assert-with-o0-fix
has been removed from the -mm tree.  Its filename was
     compiler-dont-perform-compiletime_assert-with-o0-fix.patch

This patch was dropped because it was folded into compiler-dont-perform-compiletime_assert-with-o0.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: compiler-dont-perform-compiletime_assert-with-o0-fix

use do{}while(0), per Michal

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Joe Stringer <joe@ovn.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/compiler.h~compiler-dont-perform-compiletime_assert-with-o0-fix include/linux/compiler.h
--- a/include/linux/compiler.h~compiler-dont-perform-compiletime_assert-with-o0-fix
+++ a/include/linux/compiler.h
@@ -527,7 +527,7 @@ static __always_inline void __write_once
 		__compiletime_error_fallback(__cond);			\
 	} while (0)
 #else
-# define __compiletime_assert(condition, msg, prefix, suffix)
+# define __compiletime_assert(condition, msg, prefix, suffix) do { } while (0)
 #endif
 
 #define _compiletime_assert(condition, msg, prefix, suffix) \
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
compiler-dont-perform-compiletime_assert-with-o0.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
mm-page_owner-make-init_pages_in_zone-faster-fix-checkpatch-fixes.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
swap-choose-swap-device-according-to-numa-node-v2-fix.patch
mm-change-the-call-sites-of-numa-statistics-items-checkpatch-fixes.patch
add-testcases-for-memset16-32-64-fix.patch
vga-optimise-console-scrolling-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
zram-mm-vs-block.patch
drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

