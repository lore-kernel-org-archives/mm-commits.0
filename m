From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-extern-cleanup-latencytop.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:50:06 -0400
Message-ID: <201003150650.o2F6od5I015795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758806Ab0COGuw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:50:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, arjan@infradead.org, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: latencytop
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-latencytop.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: latencytop
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

latencytop_enabled is declared in linux/latencytop.h, so remove the
declaration in sysctl.c, include the head file instead.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~sysctl-extern-cleanup-latencytop kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-latencytop
+++ a/kernel/sysctl.c
@@ -39,6 +39,7 @@
 #include <linux/pid.h>
 #include <linux/writeback.h>
 #include <linux/ratelimit.h>
+#include <linux/latencytop.h>
 #include <linux/hugetlb.h>
 #include <linux/initrd.h>
 #include <linux/key.h>
@@ -77,7 +78,6 @@ extern int sysctl_oom_dump_tasks;
 extern int max_threads;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
-extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifndef CONFIG_MMU
 extern int sysctl_nr_trim_pages;
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
sysctl-extern-cleanup-latencytop.patch
sysctl-extern-cleanup-file-nr.patch
sysctl-extern-cleanup-block-iopoll.patch
linux-next.patch

