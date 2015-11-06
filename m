From: akpm@linux-foundation.org
Subject: [merged]
 syscall-mlockall-reorganize-return-values-and-remove-goto-out-label.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:07:13 -0800
Message-ID: <563d0871.97MSai4mahbmDxLU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533AbbKFUHN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: klimov.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock.c: reorganize mlockall() return values and remove goto-out label
has been removed from the -mm tree.  Its filename was
     syscall-mlockall-reorganize-return-values-and-remove-goto-out-label.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


