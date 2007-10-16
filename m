From: akpm@linux-foundation.org
Subject: - maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:36:36 -0700
Message-ID: <200710162136.l9GLaaJF018604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36199 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966382AbXJPVrq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:47:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boutcher@cs.umn.edu, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     Fix /proc/pid/pagemap return length calculation
has been removed from the -mm tree.  Its filename was
     maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Fix /proc/pid/pagemap return length calculation
From: Dave Boutcher <boutcher@cs.umn.edu>

/proc/pid/pagemap has a header (usually 8 bytes) the length of which needs
to be compensated for when converting from proc file offset to page number.
 The calculation of the starting page number (svpfn) compensates for this,
but the calculation of the ending page number (evpfn) does not, resulting
in reads returning 8 bytes more than were asked for and nastily overwriting
userspace memory.

Signed-off-by: Dave Boutcher <boutcher@cs.umn.edu>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation
+++ a/fs/proc/task_mmu.c
@@ -659,7 +659,7 @@ static ssize_t pagemap_read(struct file 
 	addr = PAGE_SIZE * svpfn;
 	if ((svpfn + 1) * sizeof(unsigned long) != src)
 		goto out;
-	evpfn = min((src + count) / sizeof(unsigned long),
+	evpfn = min((src + count) / sizeof(unsigned long) - 1,
 		    ((~0UL) >> PAGE_SHIFT) + 1);
 	count = (evpfn - svpfn) * sizeof(unsigned long);
 	end = PAGE_SIZE * evpfn;
_

Patches currently in -mm which might be from boutcher@cs.umn.edu are

maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace.patch
