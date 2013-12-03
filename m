From: akpm@linux-foundation.org
Subject: + mm-mlock-prepare-params-outside-critical-region.patch added to
 -mm tree
Date: Tue, 03 Dec 2013 14:58:02 -0800
Message-ID: <529e61fa.J4AfgbwdKqxvqAen%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab3LCW6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 17:58:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, riel@redhat.com, davidlohr@hp.com

Subject: + mm-mlock-prepare-params-outside-critical-region.patch added to -mm tree
To: davidlohr@hp.com,riel@redhat.com,vbabka@suse.cz,walken@google.com
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 14:58:02 -0800


The patch titled
     Subject: mm/mlock: prepare params outside critical region
has been added to the -mm tree.  Its filename is
     mm-mlock-prepare-params-outside-critical-region.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-prepare-params-outside-critical-region.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-prepare-params-outside-critical-region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm/mlock: prepare params outside critical region

All mlock related syscalls prepare lock limits, lengths and start
parameters with the mmap_sem held.  Move this logic outside of the
critical region.  For the case of mlock, continue incrementing the amount
already locked by mm->locked_vm with the rwsem taken.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN mm/mlock.c~mm-mlock-prepare-params-outside-critical-region mm/mlock.c
--- a/mm/mlock.c~mm-mlock-prepare-params-outside-critical-region
+++ a/mm/mlock.c
@@ -689,19 +689,21 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 
 	lru_add_drain_all();	/* flush pagevec */
 
-	down_write(&current->mm->mmap_sem);
 	len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
 	start &= PAGE_MASK;
 
-	locked = len >> PAGE_SHIFT;
-	locked += current->mm->locked_vm;
-
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
+	locked = len >> PAGE_SHIFT;
+
+	down_write(&current->mm->mmap_sem);
+
+	locked += current->mm->locked_vm;
 
 	/* check against resource limits */
 	if ((locked <= lock_limit) || capable(CAP_IPC_LOCK))
 		error = do_mlock(start, len, 1);
+
 	up_write(&current->mm->mmap_sem);
 	if (!error)
 		error = __mm_populate(start, len, 0);
@@ -712,11 +714,13 @@ SYSCALL_DEFINE2(munlock, unsigned long,
 {
 	int ret;
 
-	down_write(&current->mm->mmap_sem);
 	len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
 	start &= PAGE_MASK;
+
+	down_write(&current->mm->mmap_sem);
 	ret = do_mlock(start, len, 0);
 	up_write(&current->mm->mmap_sem);
+
 	return ret;
 }
 
@@ -761,12 +765,12 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	if (flags & MCL_CURRENT)
 		lru_add_drain_all();	/* flush pagevec */
 
-	down_write(&current->mm->mmap_sem);
