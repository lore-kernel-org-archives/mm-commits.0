From: akpm@linux-foundation.org
Subject: + bug-in-mm_rb-debugging.patch added to -mm tree
Date: Tue, 27 Feb 2007 22:28:48 -0800
Message-ID: <200702280628.l1S6Sqgj008785@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41940 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbXB1G32 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 01:29:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, andrea@novell.com


The patch titled
     Bug in MM_RB debugging
has been added to the -mm tree.  Its filename is
     bug-in-mm_rb-debugging.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Bug in MM_RB debugging
From: David Miller <davem@davemloft.net>

The code is seemingly trying to make sure that rb_next() brings us to
successive increasing vma entries.

But the two variables, prev and pend, used to perform these checks, are
never advanced.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Andrea Arcangeli <andrea@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/mmap.c~bug-in-mm_rb-debugging mm/mmap.c
--- a/mm/mmap.c~bug-in-mm_rb-debugging
+++ a/mm/mmap.c
@@ -299,6 +299,8 @@ static int browse_rb(struct rb_root *roo
 			printk("vm_end %lx < vm_start %lx\n", vma->vm_end, vma->vm_start);
 		i++;
 		pn = nd;
+		prev = vma->vm_start;
+		pend = vma->vm_end;
 	}
 	j = 0;
 	for (nd = pn; nd; nd = rb_prev(nd)) {
_

Patches currently in -mm which might be from davem@davemloft.net are

tick-schedc-build-fix.patch
generic-one-shot-bug.patch
bug-in-mm_rb-debugging.patch
git-net.patch
resend-iphase-64bit-cleanup.patch
simplify-the-stacktrace-code.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
ipvs-flush-defense_work-before-module-unload.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
local_t-sparc64-cleanup.patch
