From: akpm@osdl.org
Subject: - futex-remove-unneeded-barrier.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:37 -0800
Message-ID: <200612072316.kB7NGbql030854@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53682 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163807AbWLGXQw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:16:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     futex: remove unneeded barrier
has been removed from the -mm tree.  Its filename was
     futex-remove-unneeded-barrier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: futex: remove unneeded barrier
From: Ralf Baechle <ralf@linux-mips.org>

When disassembling a kernel I found around over 90 sync Instructions from
mb, rmb and wmb calls in the kernel and only few of those make any sense to
me.  So here's the first one - I think the wmb() in kernel/futex.c is not
needed on uniprocessors so should become an smb_wmb().

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/futex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/futex.c~futex-remove-unneeded-barrier kernel/futex.c
--- a/kernel/futex.c~futex-remove-unneeded-barrier
+++ a/kernel/futex.c
@@ -552,7 +552,7 @@ static void wake_futex(struct futex_q *q
 	 * at the end of wake_up_all() does not prevent this store from
 	 * moving.
 	 */
-	wmb();
+	smp_wmb();
 	q->lock_ptr = NULL;
 }
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
mips-dbg_io-stray-brackets-fix.patch
mmc-fix-syntax-error.patch
git-mtd.patch
pci-legacy-resource-fix.patch
pci-legacy-resource-fix-tidy.patch
generic-ioremap_page_range-mips-conversion.patch

