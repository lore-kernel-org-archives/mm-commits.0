From: akpm@linux-foundation.org
Subject: - remove-the-unused-exports-of-sys_open--sys_read-for-2625.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:18:07 -0800
Message-ID: <200802082017.m18KHmBr010860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39364 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752328AbYBHUpJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:45:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     remove the unused exports of sys_open/sys_read
has been removed from the -mm tree.  Its filename was
     remove-the-unused-exports-of-sys_open--sys_read-for-2625.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove the unused exports of sys_open/sys_read
From: Arjan van de Ven <arjan@linux.intel.com>

These exports (which aren't used and which are in fact dangerous to use
because they pretty much form a security hole to use) have been marked
_UNUSED since 2.6.24 with removal in 2.6.25.  This patch is their final
departure from the Linux kernel tree.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c       |    1 -
 fs/read_write.c |    1 -
 2 files changed, 2 deletions(-)

diff -puN fs/open.c~remove-the-unused-exports-of-sys_open--sys_read-for-2625 fs/open.c
--- a/fs/open.c~remove-the-unused-exports-of-sys_open--sys_read-for-2625
+++ a/fs/open.c
@@ -1061,7 +1061,6 @@ asmlinkage long sys_open(const char __us
 	prevent_tail_call(ret);
 	return ret;
 }
-EXPORT_UNUSED_SYMBOL_GPL(sys_open); /* To be deleted for 2.6.25 */
 
 asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
 			   int mode)
diff -puN fs/read_write.c~remove-the-unused-exports-of-sys_open--sys_read-for-2625 fs/read_write.c
--- a/fs/read_write.c~remove-the-unused-exports-of-sys_open--sys_read-for-2625
+++ a/fs/read_write.c
@@ -366,7 +366,6 @@ asmlinkage ssize_t sys_read(unsigned int
 
 	return ret;
 }
-EXPORT_UNUSED_SYMBOL_GPL(sys_read); /* to be deleted for 2.6.25 */
 
 asmlinkage ssize_t sys_write(unsigned int fd, const char __user * buf, size_t count)
 {
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
git-agpgart.patch
hci_ldisc-fix-null-pointer-deref.patch
git-sched.patch
git-x86.patch
