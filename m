From: akpm@linux-foundation.org
Subject: + numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled.patch added to -mm tree
Date: Thu, 25 Aug 2011 13:41:24 -0700
Message-ID: <201108252041.p7PKfOe8006828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754215Ab1HYUmC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 16:42:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, amwang@redhat.com, rdunlap@xenotime.net


The patch titled
     numa: fix NUMA compile error when sysfs and procfs are disabled
has been added to the -mm tree.  Its filename is
     numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: numa: fix NUMA compile error when sysfs and procfs are disabled
From: David Rientjes <rientjes@google.com>

The vmstat_text array is only defined for CONFIG_SYSFS or CONFIG_PROC_FS,
yet it is referenced for per-node vmstat with CONFIG_NUMA:

	drivers/built-in.o: In function `node_read_vmstat':
	node.c:(.text+0x1106df): undefined reference to `vmstat_text'

in fa25c503dfa2 (mm: per-node vmstat: show proper vmstats).

Define the array for CONFIG_NUMA as well.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Cong Wang <amwang@redhat.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 ++
 mm/vmstat.c            |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/vmstat.h~numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled include/linux/vmstat.h
--- a/include/linux/vmstat.h~numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled
+++ a/include/linux/vmstat.h
@@ -258,6 +258,8 @@ static inline void refresh_zone_stat_thr
 
 #endif		/* CONFIG_SMP */
 
+#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSFS) || defined(CONFIG_NUMA)
 extern const char * const vmstat_text[];
+#endif
 
 #endif /* _LINUX_VMSTAT_H */
diff -puN mm/vmstat.c~numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled mm/vmstat.c
--- a/mm/vmstat.c~numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled
+++ a/mm/vmstat.c
@@ -659,7 +659,7 @@ static void walk_zones_in_node(struct se
 }
 #endif
 
-#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSFS)
+#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSFS) || defined(CONFIG_NUMA)
 #ifdef CONFIG_ZONE_DMA
 #define TEXT_FOR_DMA(xx) xx "_dma",
 #else
@@ -789,7 +789,7 @@ const char * const vmstat_text[] = {
 
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
-#endif /* CONFIG_PROC_FS || CONFIG_SYSFS */
+#endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA */
 
 
 #ifdef CONFIG_PROC_FS
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled.patch
oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch

