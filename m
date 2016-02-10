From: akpm@linux-foundation.org
Subject: + mm-move-max_map_count-bits-into-mmh.patch added to -mm tree
Date: Wed, 10 Feb 2016 13:30:19 -0800
Message-ID: <56bbabeb.XAlCBOUx5yb0e1HI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbcBJVaT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 16:30:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move max_map_count bits into mm.h
has been added to the -mm tree.  Its filename is
     mm-move-max_map_count-bits-into-mmh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-max_map_count-bits-into-mmh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-max_map_count-bits-into-mmh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm: move max_map_count bits into mm.h

max_map_count sysctl unrelated to scheduler. Move its bits from
include/linux/sched/sysctl.h to include/linux/mm.h.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h           |   21 +++++++++++++++++++++
 include/linux/sched/sysctl.h |   21 ---------------------
 mm/mmap.c                    |    1 -
 mm/mremap.c                  |    1 -
 mm/nommu.c                   |    1 -
 5 files changed, 21 insertions(+), 24 deletions(-)

diff -puN include/linux/mm.h~mm-move-max_map_count-bits-into-mmh include/linux/mm.h
--- a/include/linux/mm.h~mm-move-max_map_count-bits-into-mmh
+++ a/include/linux/mm.h
@@ -82,6 +82,27 @@ extern int mmap_rnd_compat_bits __read_m
 #define mm_forbids_zeropage(X)	(0)
 #endif
 
+/*
+ * Default maximum number of active map areas, this limits the number of vmas
+ * per mm struct. Users can overwrite this number by sysctl but there is a
+ * problem.
+ *
+ * When a program's coredump is generated as ELF format, a section is created
+ * per a vma. In ELF, the number of sections is represented in unsigned short.
+ * This means the number of sections should be smaller than 65535 at coredump.
+ * Because the kernel adds some informative sections to a image of program at
+ * generating coredump, we need some margin. The number of extra sections is
+ * 1-3 now and depends on arch. We use "5" as safe margin, here.
+ *
+ * ELF extended numbering allows more than 65535 sections, so 16-bit bound is
+ * not a hard limit any more. Although some userspace tools can be surprised by
+ * that.
+ */
+#define MAPCOUNT_ELF_CORE_MARGIN	(5)
+#define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
+
+extern int sysctl_max_map_count;
+
 extern unsigned long sysctl_user_reserve_kbytes;
 extern unsigned long sysctl_admin_reserve_kbytes;
 
diff -puN include/linux/sched/sysctl.h~mm-move-max_map_count-bits-into-mmh include/linux/sched/sysctl.h
--- a/include/linux/sched/sysctl.h~mm-move-max_map_count-bits-into-mmh
+++ a/include/linux/sched/sysctl.h
@@ -14,27 +14,6 @@ extern int proc_dohung_task_timeout_secs
 enum { sysctl_hung_task_timeout_secs = 0 };
 #endif
 
-/*
- * Default maximum number of active map areas, this limits the number of vmas
- * per mm struct. Users can overwrite this number by sysctl but there is a
- * problem.
- *
- * When a program's coredump is generated as ELF format, a section is created
- * per a vma. In ELF, the number of sections is represented in unsigned short.
- * This means the number of sections should be smaller than 65535 at coredump.
- * Because the kernel adds some informative sections to a image of program at
- * generating coredump, we need some margin. The number of extra sections is
- * 1-3 now and depends on arch. We use "5" as safe margin, here.
- *
- * ELF extended numbering allows more than 65535 sections, so 16-bit bound is
- * not a hard limit any more. Although some userspace tools can be surprised by
- * that.
- */
-#define MAPCOUNT_ELF_CORE_MARGIN	(5)
-#define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
-
-extern int sysctl_max_map_count;
-
 extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
diff -puN mm/mmap.c~mm-move-max_map_count-bits-into-mmh mm/mmap.c
--- a/mm/mmap.c~mm-move-max_map_count-bits-into-mmh
+++ a/mm/mmap.c
@@ -37,7 +37,6 @@
 #include <linux/khugepaged.h>
 #include <linux/uprobes.h>
 #include <linux/rbtree_augmented.h>
-#include <linux/sched/sysctl.h>
 #include <linux/notifier.h>
 #include <linux/memory.h>
 #include <linux/printk.h>
diff -puN mm/mremap.c~mm-move-max_map_count-bits-into-mmh mm/mremap.c
--- a/mm/mremap.c~mm-move-max_map_count-bits-into-mmh
+++ a/mm/mremap.c
@@ -20,7 +20,6 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/mmu_notifier.h>
-#include <linux/sched/sysctl.h>
 #include <linux/uaccess.h>
 #include <linux/mm-arch-hooks.h>
 
diff -puN mm/nommu.c~mm-move-max_map_count-bits-into-mmh mm/nommu.c
--- a/mm/nommu.c~mm-move-max_map_count-bits-into-mmh
+++ a/mm/nommu.c
@@ -33,7 +33,6 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/audit.h>
-#include <linux/sched/sysctl.h>
 #include <linux/printk.h>
 
 #include <asm/uaccess.h>
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

kernel-lockdep-eliminate-lockdep_init.patch
mm-page-writeback-fix-dirty_ratelimit-calculation.patch
mm-move-max_map_count-bits-into-mmh.patch
ubsan-fix-tree-wide-wmaybe-uninitialized-false-positives.patch

