From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-extern-cleanup-mm.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:50:01 -0400
Message-ID: <201003150650.o2F6oYPg015783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756997Ab0COGug (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:50:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: mm
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-mm.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: mm
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

Move min_free_kbytes extern declaration to linux/mmzone.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 kernel/sysctl.c        |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~sysctl-extern-cleanup-mm include/linux/mmzone.h
--- a/include/linux/mmzone.h~sysctl-extern-cleanup-mm
+++ a/include/linux/mmzone.h
@@ -746,6 +746,7 @@ static inline int is_dma(struct zone *zo
 struct ctl_table;
 int min_free_kbytes_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
+extern int min_free_kbytes; /* for sysctl */
 extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES-1];
 int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-mm kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-mm
+++ a/kernel/sysctl.c
@@ -74,7 +74,6 @@ extern int sysctl_panic_on_oom;
 extern int sysctl_oom_kill_allocating_task;
 extern int sysctl_oom_dump_tasks;
 extern int max_threads;
-extern int min_free_kbytes;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
sysctl-extern-cleanup-mm.patch
sysctl-extern-cleanup-compat.patch
sysctl-extern-cleanup-latencytop.patch
sysctl-extern-cleanup-file-nr.patch
sysctl-extern-cleanup-block-iopoll.patch
linux-next.patch

