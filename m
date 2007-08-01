From: akpm@linux-foundation.org
Subject: + remove-unused-struct-proc_dir_entryset.patch added to -mm tree
Date: Wed, 01 Aug 2007 16:38:51 -0700
Message-ID: <200708012338.l71Ncp2B023210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53142 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448AbXHAXj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 19:39:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, ebiederm@xmission.com


The patch titled
     Remove unused struct proc_dir_entry::set
has been added to the -mm tree.  Its filename is
     remove-unused-struct-proc_dir_entryset.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
blackfin-arch-after-removing-fsh-from-mmh-fix-the-broken-on-blackfin-arch.patch
remove-unused-struct-proc_dir_entryset.patch
faster-ext2_clear_inode.patch
fs-proc-mmuc-headers-butchery.patch
remove-sysctlh-from-fsh.patch
epcac-reformat-comments-and-coding-style-improvements.patch
revert-faster-ext2_clear_inode.patch
