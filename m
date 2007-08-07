From: akpm@linux-foundation.org
Subject: + maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation.patch added to -mm tree
Date: Tue, 07 Aug 2007 16:06:42 -0700
Message-ID: <200708072306.l77N6gGC009566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51377 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281AbXHGXHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 19:07:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: boutcher@cs.umn.edu, mpm@selenic.com


The patch titled
     Fix /proc/pid/pagemap return length calculation
has been added to the -mm tree.  Its filename is
     maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix /proc/pid/pagemap return length calculation
From: boutcher@cs.umn.edu (Dave Boutcher)

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
