From: akpm@linux-foundation.org
Subject: +
 syscall-mlockall-reorganize-return-values-and-remove-goto-out-label.patch
 added to -mm tree
Date: Fri, 11 Sep 2015 15:54:36 -0700
Message-ID: <55f35bac.S0f5QJzEzT2oioxo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbbIKWyg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 18:54:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: klimov.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock.c: reorganize mlockall() return values and remove goto-out label
has been added to the -mm tree.  Its filename is
     syscall-mlockall-reorganize-return-values-and-remove-goto-out-label.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/syscall-mlockall-reorganize-return-values-and-remove-goto-out-label.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/syscall-mlockall-reorganize-return-values-and-remove-goto-out-label.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Klimov <klimov.linux@gmail.com>
Subject: mm/mlock.c: reorganize mlockall() return values and remove goto-out label

In mlockall syscall wrapper after out-label for goto code just doing
return.  Remove goto out statements and return error values directly.

Also instead of rewriting ret variable before every if-check move returns
to 'error'-like path under if-check.

Objdump asm listing showed me reducing by few asm lines.  Object file size
descreased from 220592 bytes to 220528 bytes for me (for aarch64).

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/mlock.c~syscall-mlockall-reorganize-return-values-and-remove-goto-out-label mm/mlock.c
--- a/mm/mlock.c~syscall-mlockall-reorganize-return-values-and-remove-goto-out-label
+++ a/mm/mlock.c
@@ -684,14 +684,13 @@ out:
 SYSCALL_DEFINE1(mlockall, int, flags)
 {
 	unsigned long lock_limit;
-	int ret = -EINVAL;
+	int ret;
 
 	if (!flags || (flags & ~(MCL_CURRENT | MCL_FUTURE)))
-		goto out;
+		return -EINVAL;
 
-	ret = -EPERM;
 	if (!can_do_mlock())
-		goto out;
+		return -EPERM;
 
 	if (flags & MCL_CURRENT)
 		lru_add_drain_all();	/* flush pagevec */
@@ -708,7 +707,7 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	up_write(&current->mm->mmap_sem);
 	if (!ret && (flags & MCL_CURRENT))
 		mm_populate(0, TASK_SIZE);
-out:
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from klimov.linux@gmail.com are

syscall-mlockall-reorganize-return-values-and-remove-goto-out-label.patch

