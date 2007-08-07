From: akpm@linux-foundation.org
Subject: + maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch added to -mm tree
Date: Tue, 07 Aug 2007 16:07:49 -0700
Message-ID: <200708072307.l77N7n2F009586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48100 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755410AbXHGXIG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 19:08:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: boutcher@cs.umn.edu, mpm@selenic.com


The patch titled
     Fix /proc/pid/pagemap end address calculation
has been added to the -mm tree.  Its filename is
     maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix /proc/pid/pagemap end address calculation
From: boutcher@cs.umn.edu (Dave Boutcher)

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

maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch
