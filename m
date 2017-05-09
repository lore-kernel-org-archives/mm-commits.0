From: akpm@linux-foundation.org
Subject: [merged]
 drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch removed
 from -mm tree
Date: Tue, 09 May 2017 11:03:33 -0700
Message-ID: <20170509180333.3KXkANyr3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34886 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753074AbdEISDe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:03:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, labbott@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/staging/media/atomisp/pci/atomisp2: use set_memory.h
has been removed from the -mm tree.  Its filename was
     drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
gcov-support-gcc-71-v2-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

