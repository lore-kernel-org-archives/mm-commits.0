From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-extern-cleanup-file-nr.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:50:09 -0400
Message-ID: <201003150650.o2F6ognj015803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758870Ab0COGuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: file nr
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-file-nr.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: file nr
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

Move sysctl_nr_open_min, sysctl_nr_open_max extern declarations to
linux/file.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/file.h |    1 +
 kernel/sysctl.c      |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/file.h~sysctl-extern-cleanup-file-nr include/linux/file.h
--- a/include/linux/file.h~sysctl-extern-cleanup-file-nr
+++ a/include/linux/file.h
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/posix_types.h>
 
+extern int sysctl_nr_open_min, sysctl_nr_open_max; /* for sysctl */
 struct file;
 
 extern void __fput(struct file *);
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-file-nr kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-file-nr
+++ a/kernel/sysctl.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
+#include <linux/file.h>
 #include <linux/sysctl.h>
 #include <linux/signal.h>
 #include <linux/proc_fs.h>
@@ -78,7 +79,6 @@ extern int sysctl_oom_dump_tasks;
 extern int max_threads;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
-extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifndef CONFIG_MMU
 extern int sysctl_nr_trim_pages;
 #endif
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
sysctl-extern-cleanup-file-nr.patch
sysctl-extern-cleanup-block-iopoll.patch
linux-next.patch

