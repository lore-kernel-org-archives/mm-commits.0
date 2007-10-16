From: akpm@linux-foundation.org
Subject: - maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:36:42 -0700
Message-ID: <200710162136.l9GLag6b018611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34026 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965464AbXJPVhZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:37:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boutcher@cs.umn.edu, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     Fix /proc/pid/pagemap header copy to userspace
has been removed from the -mm tree.  Its filename was
     maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Fix /proc/pid/pagemap header copy to userspace
From: Dave Boutcher <boutcher@cs.umn.edu>

Earlier code relied on a broken length calculation copy /proc/pid/pagemap
header data to userspace.  This fix correctly calls the add_to_pagemap
routine after the header data is set to copy results to userspace in a sane
fashion.

Signed-off-by: Dave Boutcher <boutcher@cs.umn.edu>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace
+++ a/fs/proc/task_mmu.c
@@ -689,11 +689,11 @@ static ssize_t pagemap_read(struct file 
 	pm.out = buf;
 
 	if (svpfn == -1) {
-		add_to_pagemap(pm.next, 0, &pm);
 		((char *)page)[0] = (ntohl(1) != 1);
 		((char *)page)[1] = PAGE_SHIFT;
 		((char *)page)[2] = sizeof(unsigned long);
 		((char *)page)[3] = sizeof(unsigned long);
+		add_to_pagemap(pm.next, page[0], &pm);
 	}
 
 	down_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from boutcher@cs.umn.edu are

maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace.patch
