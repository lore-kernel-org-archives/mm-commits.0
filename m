From: akpm@linux-foundation.org
Subject: + remove-the-unused-exports-of-sys_open--sys_read-for-2625.patch added to -mm tree
Date: Mon, 21 Jan 2008 18:34:52 -0800
Message-ID: <200801220234.m0M2YW8u032586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39763 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781AbYAVCei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 21:34:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     remove the unused exports of sys_open/sys_read
has been added to the -mm tree.  Its filename is
     remove-the-unused-exports-of-sys_open--sys_read-for-2625.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-input.patch
hci_ldisc-fix-null-pointer-deref.patch
git-sched.patch
git-x86.patch
drivers-edac-use-round_jiffies_relative.patch
remove-the-unused-exports-of-sys_open--sys_read-for-2625.patch
