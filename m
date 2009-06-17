From: akpm@linux-foundation.org
Subject: [merged] mm-madvise-correct-return-code.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:20 -0700
Message-ID: <200906171835.n5HIZKtS001356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760259AbZFQSgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:36:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, jdluhos@novell.com, mtk.manpages@googlemail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: madvise(): correct return code
has been removed from the -mm tree.  Its filename was
     mm-madvise-correct-return-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: madvise(): correct return code
From: Nick Piggin <npiggin@suse.de>

The posix_madvise() function succeeds (and does nothing) when called with
parameters (NULL, 0, -1); according to LSB tests, it should fail with
EINVAL because -1 is not a valid flag.

When called with a valid address and size, it correctly fails.

So perform an initial check for valid flags first.

Reported-by: Jiri Dluhos <jdluhos@novell.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Reviewed-and-Tested-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff -puN mm/madvise.c~mm-madvise-correct-return-code mm/madvise.c
--- a/mm/madvise.c~mm-madvise-correct-return-code
+++ a/mm/madvise.c
@@ -238,12 +238,30 @@ madvise_vma(struct vm_area_struct *vma, 
 		break;
 
 	default:
-		error = -EINVAL;
+		BUG();
 		break;
 	}
 	return error;
 }
 
+static int
+madvise_behavior_valid(int behavior)
+{
+	switch (behavior) {
+	case MADV_DOFORK:
+	case MADV_DONTFORK:
+	case MADV_NORMAL:
+	case MADV_SEQUENTIAL:
+	case MADV_RANDOM:
+	case MADV_REMOVE:
+	case MADV_WILLNEED:
+	case MADV_DONTNEED:
+		return 1;
+
+	default:
+		return 0;
+	}
+}
 /*
  * The madvise(2) system call.
  *
@@ -289,6 +307,9 @@ SYSCALL_DEFINE3(madvise, unsigned long, 
 	int write;
 	size_t len;
 
+	if (!madvise_behavior_valid(behavior))
+		return error;
+
 	write = madvise_need_mmap_write(behavior);
 	if (write)
 		down_write(&current->mm->mmap_sem);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

