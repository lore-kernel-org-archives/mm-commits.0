From: akpm@linux-foundation.org
Subject: - remove-unused-struct-proc_dir_entryset.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:02:54 -0700
Message-ID: <200708140502.l7E52smT032009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760475AbXHNFDb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Remove unused struct proc_dir_entry::set
has been removed from the -mm tree.  Its filename was
     remove-unused-struct-proc_dir_entryset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove unused struct proc_dir_entry::set
From: Alexey Dobriyan <adobriyan@gmail.com>

After /proc/sys rewrite it was left unused.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/proc_fs.h |    1 -
 1 files changed, 1 deletion(-)

diff -puN include/linux/proc_fs.h~remove-unused-struct-proc_dir_entryset include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~remove-unused-struct-proc_dir_entryset
+++ a/include/linux/proc_fs.h
@@ -75,7 +75,6 @@ struct proc_dir_entry {
 	write_proc_t *write_proc;
 	atomic_t count;		/* use count */
 	int deleted;		/* delete flag */
-	void *set;
 	int pde_users;	/* number of callers into module in progress */
 	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
 	struct completion *pde_unload_completion;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ifdef-struct-task_structsecurity.patch
faster-ext2_clear_inode.patch
fs-proc-mmuc-headers-butchery.patch
remove-sysctlh-from-fsh.patch
epcac-reformat-comments-and-coding-style-improvements.patch
revert-faster-ext2_clear_inode.patch
