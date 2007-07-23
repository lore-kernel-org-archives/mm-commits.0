From: akpm@linux-foundation.org
Subject: + remove-sysctlh-from-fsh.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:39:19 -0700
Message-ID: <200707232139.l6NLdJZu013238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754191AbXGWVj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:39:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     Remove sysctl.h from fs.h
has been added to the -mm tree.  Its filename is
     remove-sysctlh-from-fsh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 2 deletions(-)

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
@@ -1953,7 +1952,8 @@ static inline void free_secdata(void *se
 { }
 #endif	/* CONFIG_SECURITY */
 
-int proc_nr_files(ctl_table *table, int write, struct file *filp,
+struct ctl_table;
+int proc_nr_files(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
 
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

faster-ext2_clear_inode.patch
fs-proc-mmuc-headers-butchery.patch
remove-sysctlh-from-fsh.patch
revert-faster-ext2_clear_inode.patch
