From: akpm@linux-foundation.org
Subject: +
 shm-fix-unlikely-test-of-info-seals-to-test-only-for-write-and-grow.patch
 added to -mm tree
Date: Fri, 03 Feb 2017 15:17:41 -0800
Message-ID: <58950f95./557Xr4AadWzyDRg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39796 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752735AbdBCXRr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2017 18:17:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, dh.herrmann@gmail.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem.c: fix unlikely() test of info->seals to test only for WRITE and GROW
has been added to the -mm tree.  Its filename is
     shm-fix-unlikely-test-of-info-seals-to-test-only-for-write-and-grow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shm-fix-unlikely-test-of-info-seals-to-test-only-for-write-and-grow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shm-fix-unlikely-test-of-info-seals-to-test-only-for-write-and-grow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: mm/shmem.c: fix unlikely() test of info->seals to test only for WRITE and GROW

Running my likely/unlikely profiler, I discovered that the test in
shmem_write_begin() that tests for info->seals as unlikely, is always
incorrect.  This is because shmem_get_inode() sets info->seals to have
F_SEAL_SEAL set by default, and it is unlikely to be cleared when
shmem_write_begin() is called.  Thus, the if statement is very likely.

But as the if statement block only cares about F_SEAL_WRITE and
F_SEAL_GROW, change the test to only test those two bits.

Link: http://lkml.kernel.org/r/20170203105656.7aec6237@gandalf.local.home
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~shm-fix-unlikely-test-of-info-seals-to-test-only-for-write-and-grow mm/shmem.c
--- a/mm/shmem.c~shm-fix-unlikely-test-of-info-seals-to-test-only-for-write-and-grow
+++ a/mm/shmem.c
@@ -2331,7 +2331,7 @@ shmem_write_begin(struct file *file, str
 	pgoff_t index = pos >> PAGE_SHIFT;
 
 	/* i_mutex is held by caller */
-	if (unlikely(info->seals)) {
+	if (unlikely(info->seals & (F_SEAL_WRITE | F_SEAL_GROW))) {
 		if (info->seals & F_SEAL_WRITE)
 			return -EPERM;
 		if ((info->seals & F_SEAL_GROW) && pos + len > inode->i_size)
_

Patches currently in -mm which might be from rostedt@goodmis.org are

mm-page_alloc-swap-likely-to-unlikely-as-code-logic-is-different-for-next_zones_zonelist.patch
shm-fix-unlikely-test-of-info-seals-to-test-only-for-write-and-grow.patch

