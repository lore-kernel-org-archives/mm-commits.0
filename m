From: akpm@linux-foundation.org
Subject: + proc-remove-obsolete-comments.patch added to -mm tree
Date: Thu, 06 May 2010 14:54:58 -0700
Message-ID: <201005062154.o46LswNW017279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753041Ab0EFVzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 17:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, adobriyan@gmail.com


The patch titled
     proc: remove obsolete comments
has been added to the -mm tree.  Its filename is
     proc-remove-obsolete-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: remove obsolete comments
From: Amerigo Wang <amwang@redhat.com>

A quick test shows these comments are obsolete, so just remove them.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff -puN fs/proc/generic.c~proc-remove-obsolete-comments fs/proc/generic.c
--- a/fs/proc/generic.c~proc-remove-obsolete-comments
+++ a/fs/proc/generic.c
@@ -343,21 +343,6 @@ static DEFINE_SPINLOCK(proc_inum_lock); 
 /*
  * Return an inode number between PROC_DYNAMIC_FIRST and
  * 0xffffffff, or zero on failure.
- *
- * Current inode allocations in the proc-fs (hex-numbers):
- *
- * 00000000		reserved
- * 00000001-00000fff	static entries	(goners)
- *      001		root-ino
- *
- * 00001000-00001fff	unused
- * 0001xxxx-7fffxxxx	pid-dir entries for pid 1-7fff
- * 80000000-efffffff	unused
- * f0000000-ffffffff	dynamic entries
- *
- * Goal:
- *	Once we split the thing into several virtual filesystems,
- *	we will get rid of magical ranges (and this comment, BTW).
  */
 static unsigned int get_inode_number(void)
 {
_

Patches currently in -mm which might be from amwang@redhat.com are

kexec-fix-oops-in-crash_kernel_shrink.patch
linux-next.patch
proc-remove-obsolete-comments.patch

