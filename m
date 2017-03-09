From: akpm@linux-foundation.org
Subject: +
 drivers-gpu-drm-i915-selftests-i915_selftestc-fix-build-with-gcc-444.patch
 added to -mm tree
Date: Thu, 09 Mar 2017 15:43:10 -0800
Message-ID: <58c1e88e.qsZfPubeid9NfCMk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47524 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752390AbdCIXnM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 18:43:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chris-wilson.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/gpu/drm/i915/selftests/i915_selftest.c: fix build with gcc-4.4.4
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-i915-selftests-i915_selftestc-fix-build-with-gcc-444.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-gpu-drm-i915-selftests-i915_selftestc-fix-build-with-gcc-444.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-gpu-drm-i915-selftests-i915_selftestc-fix-build-with-gcc-444.patch

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
Subject: drivers/gpu/drm/i915/selftests/i915_selftest.c: fix build with gcc-4.4.4

gcc-4.4.4 has issues with anonymous union initializers.

In file included from drivers/gpu/drm/i915/selftests/i915_selftest.c:68:
drivers/gpu/drm/i915/selftests/i915_mock_selftests.h:11: error: unknown field 'mock' specified in initializer
drivers/gpu/drm/i915/selftests/i915_mock_selftests.h:11: warning: missing braces around initializer
drivers/gpu/drm/i915/selftests/i915_mock_selftests.h:11: warning: (near initialization for 'mock_selftests[0].<anonymous>')
drivers/gpu/drm/i915/selftests/i915_mock_selftests.h:12: error: unknown field 'mock' specified in initializer
drivers/gpu/drm/i915/selftests/i915_mock_selftests.h:13: error: unknown field 'm
...

Work around this.

Cc: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/selftests/i915_selftest.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/i915/selftests/i915_selftest.c~drivers-gpu-drm-i915-selftests-i915_selftestc-fix-build-with-gcc-444 drivers/gpu/drm/i915/selftests/i915_selftest.c
--- a/drivers/gpu/drm/i915/selftests/i915_selftest.c~drivers-gpu-drm-i915-selftests-i915_selftestc-fix-build-with-gcc-444
+++ a/drivers/gpu/drm/i915/selftests/i915_selftest.c
@@ -63,13 +63,13 @@ struct selftest {
 	};
 };
 
-#define selftest(n, f) [mock_##n] = { .name = #n, .mock = f },
+#define selftest(n, f) [mock_##n] = { .name = #n, { .mock = f } },
 static struct selftest mock_selftests[] = {
 #include "i915_mock_selftests.h"
 };
 #undef selftest
 
-#define selftest(n, f) [live_##n] = { .name = #n, .live = f },
+#define selftest(n, f) [live_##n] = { .name = #n, { .live = f } },
 static struct selftest live_selftests[] = {
 #include "i915_live_selftests.h"
 };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
linux-next-rejects.patch
drm-use-set_memoryh-header-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
drivers-gpu-drm-i915-selftests-i915_selftestc-fix-build-with-gcc-444.patch

