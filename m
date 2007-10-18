From: akpm@linux-foundation.org
Subject: - remove-sysctlh-from-fsh.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:30 -0700
Message-ID: <200710180653.l9I6rUDk030451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760776AbXJRHhJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:37:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Remove sysctl.h from fs.h
has been removed from the -mm tree.  Its filename was
     remove-sysctlh-from-fsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove sysctl.h from fs.h
From: Alexey Dobriyan <adobriyan@gmail.com>

Rrrr, addition of sysctl.h to fs.h was't very smart, because simple
editing of the former will buy you big recompile, where it shouldn't
have to.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/fs.h~remove-sysctlh-from-fsh include/linux/fs.h
--- a/include/linux/fs.h~remove-sysctlh-from-fsh
+++ a/include/linux/fs.h
@@ -283,7 +283,6 @@ extern int dir_notify_enable;
 #include <linux/init.h>
 #include <linux/pid.h>
 #include <linux/mutex.h>
-#include <linux/sysctl.h>
 #include <linux/capability.h>
 
 #include <asm/atomic.h>
@@ -2032,7 +2031,8 @@ static inline void free_secdata(void *se
 { }
 #endif	/* CONFIG_SECURITY */
 
-int proc_nr_files(ctl_table *table, int write, struct file *filp,
+struct ctl_table;
+int proc_nr_files(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
 
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
remove-struct-task_structio_wait.patch
