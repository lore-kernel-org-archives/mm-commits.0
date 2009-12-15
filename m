From: akpm@linux-foundation.org
Subject: [merged] mm-uncached-vma-support-with-writenotify.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:54:25 -0800
Message-ID: <200912152154.nBFLsPRE015355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761265AbZLOVzJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:55:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@opensource.se, arnd@arndb.de, hugh.dickins@tiscali.co.uk, jayakumar.lkml@gmail.com, lethal@linux-sh.org, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: uncached vma support with writenotify
has been removed from the -mm tree.  Its filename was
     mm-uncached-vma-support-with-writenotify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: uncached vma support with writenotify
From: Magnus Damm <damm@opensource.se>

Modify the generic mmap() code to keep the cache attribute in
vma->vm_page_prot regardless if writenotify is enabled or not.  Without
this patch the cache configuration selected by f_op->mmap() is overwritten
if writenotify is enabled, making it impossible to keep the vma uncached.

Needed by drivers such as drivers/video/sh_mobile_lcdcfb.c which uses
deferred io together with uncached memory.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-uncached-vma-support-with-writenotify mm/mmap.c
--- a/mm/mmap.c~mm-uncached-vma-support-with-writenotify
+++ a/mm/mmap.c
@@ -1198,8 +1198,20 @@ munmap_back:
 			goto free_vma;
 	}
 
-	if (vma_wants_writenotify(vma))
+	if (vma_wants_writenotify(vma)) {
+		pgprot_t pprot = vma->vm_page_prot;
+
+		/* Can vma->vm_page_prot have changed??
+		 *
+		 * Answer: Yes, drivers may have changed it in their
+		 *         f_op->mmap method.
+		 *
+		 * Ensures that vmas marked as uncached stay that way.
+		 */
 		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
+		if (pgprot_val(pprot) == pgprot_val(pgprot_noncached(pprot)))
+			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	}
 
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	file = vma->vm_file;
_

Patches currently in -mm which might be from damm@opensource.se are

origin.patch
linux-next.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
clocksource-start-cmt-at-clocksource-resume-v2.patch
clocksource-add-suspend-callback.patch
mmc-remove-const-from-tmio-mmc-platform-data-v2.patch
mmc-balance-tmio-mmc-cell-enable-disable-calls.patch

