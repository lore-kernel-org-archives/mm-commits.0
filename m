From: akpm@linux-foundation.org
Subject: - maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:36:39 -0700
Message-ID: <200710162136.l9GLadZR018607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56767 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965590AbXJPVqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:46:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boutcher@cs.umn.edu, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     Fix /proc/pid/pagemap end address calculation
has been removed from the -mm tree.  Its filename was
     maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Fix /proc/pid/pagemap end address calculation
From: Dave Boutcher <boutcher@cs.umn.edu>

When dumping vma information the pagemap_read routine calculates the
minimum of what the user asks for and the end of the vma.  Unfortunately
the code uses vma->vm_start rather than vma->vm_end which can result in the
end address being before the start, and a nasty never-ending loop in the
kernel.

Signed-off-by: Dave Boutcher <boutcher@cs.umn.edu>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation
+++ a/fs/proc/task_mmu.c
@@ -703,7 +703,7 @@ static ssize_t pagemap_read(struct file 
 			ret = -EIO;
 			goto out_mm;
 		}
-		vend = min(vma->vm_start - 1, end - 1) + 1;
+		vend = min(vma->vm_end - 1, end - 1) + 1;
 		ret = pagemap_fill(&pm, vend);
 		if (ret || !pm.count)
 			break;
_

Patches currently in -mm which might be from boutcher@cs.umn.edu are

maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace.patch
