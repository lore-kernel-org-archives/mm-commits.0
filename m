From: akpm@linux-foundation.org
Subject: [merged] nommu-fix-build-breakage.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:52:47 -0400
Message-ID: <201003150653.o2F6rKOP015989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759695Ab0COGxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:53:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@snapgear.com, monstr@monstr.eu, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     nommu: fix build breakage
has been removed from the -mm tree.  Its filename was
     nommu-fix-build-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: fix build breakage
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Commit 34e55232e59f7b19050267a05ff1226e5cd122a5 ("mm: avoid false sharing
of mm_counter") added sync_mm_rss() for syncing loosely accounted rss
counters.  It's for CONFIG_MMU but sync_mm_rss is called even in NOMMU
enviroment (kerne/exit.c, fs/exec.c).  Above commit doesn't handle it
well.

This patch changes
  SPLIT_RSS_COUNTING depends on SPLIT_PTLOCKS && CONFIG_MMU

And for avoid unnecessary function calls, sync_mm_rss changed to be inlined
noop function in header file.

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    6 ++++++
 include/linux/mm_types.h |    2 +-
 mm/memory.c              |    3 ---
 3 files changed, 7 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~nommu-fix-build-breakage include/linux/mm.h
--- a/include/linux/mm.h~nommu-fix-build-breakage
+++ a/include/linux/mm.h
@@ -971,7 +971,13 @@ static inline void setmax_mm_hiwater_rss
 		*maxrss = hiwater_rss;
 }
 
+#if defined(SPLIT_RSS_COUNTING)
 void sync_mm_rss(struct task_struct *task, struct mm_struct *mm);
+#else
+static inline void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
+{
+}
+#endif
 
 /*
  * A callback you can register to apply pressure to ageable caches.
diff -puN include/linux/mm_types.h~nommu-fix-build-breakage include/linux/mm_types.h
--- a/include/linux/mm_types.h~nommu-fix-build-breakage
+++ a/include/linux/mm_types.h
@@ -203,7 +203,7 @@ enum {
 	NR_MM_COUNTERS
 };
 
-#if USE_SPLIT_PTLOCKS
+#if USE_SPLIT_PTLOCKS && defined(CONFIG_MMU)
 #define SPLIT_RSS_COUNTING
 struct mm_rss_stat {
 	atomic_long_t count[NR_MM_COUNTERS];
diff -puN mm/memory.c~nommu-fix-build-breakage mm/memory.c
--- a/mm/memory.c~nommu-fix-build-breakage
+++ a/mm/memory.c
@@ -190,9 +190,6 @@ static void check_sync_rss_stat(struct t
 {
 }
 
-void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
-{
-}
 #endif
 
 /*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch
memory-hotplug-allow-setting-of-phys_device.patch
memory-hotplug-s390-set-phys_device.patch
linux-next.patch
cgroups-net_cls-as-module.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch

