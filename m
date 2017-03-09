From: akpm@linux-foundation.org
Subject: +
 drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch added to
 -mm tree
Date: Thu, 09 Mar 2017 15:45:13 -0800
Message-ID: <58c1e909.vDjcBs2eBPg6C6OA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47540 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751896AbdCIXpP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 18:45:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, labbott@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/staging/media/atomisp/pci/atomisp2: use set_memory.h
has been added to the -mm tree.  Its filename is
     drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch

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
Subject: drivers/staging/media/atomisp/pci/atomisp2: use set_memory.h

Cc: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c            |    3 ++-
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c  |    2 +-
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c |    3 ++-
 drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c           |    5 ++++-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c~drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c~drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh
+++ a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
@@ -36,12 +36,13 @@
 #include <linux/string.h>
 #include <linux/list.h>
 #include <linux/errno.h>
-#include <asm/cacheflush.h>
 #include <linux/io.h>
 #include <asm/current.h>
 #include <linux/sched/signal.h>
 #include <linux/file.h>
 
+#include <asm/set_memory.h>
+
 #include "atomisp_internal.h"
 #include "hmm/hmm_common.h"
 #include "hmm/hmm_pool.h"
diff -puN drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c~drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c~drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh
+++ a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c
@@ -27,7 +27,7 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 
-#include "asm/cacheflush.h"
+#include <asm/set_memory.h>
 
 #include "atomisp_internal.h"
 
diff -puN drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c~drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c~drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh
+++ a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c
@@ -27,7 +27,8 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 
-#include "asm/cacheflush.h"
+#include <asm/set_memory.h>
+
 #include "atomisp_internal.h"
 #include "hmm/hmm_pool.h"
 
diff -puN drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c~drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c
--- a/drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c~drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh
+++ a/drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c
@@ -30,13 +30,16 @@
 #include <linux/slab.h>		/* for kmalloc */
 #include <linux/list.h>
 #include <linux/io.h>
-#include <asm/cacheflush.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/sizes.h>
 
+#ifdef CONFIG_X86
+#include <asm/set_memory.h>
+#endif
+
 #include "atomisp_internal.h"
 #include "mmu/isp_mmu.h"
 
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

