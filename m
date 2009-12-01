From: akpm@linux-foundation.org
Subject: + mm-uncached-vma-support-with-writenotify.patch added to -mm tree
Date: Tue, 01 Dec 2009 14:56:27 -0800
Message-ID: <200912012256.nB1MuRk4020404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929AbZLAW4h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 17:56:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@opensource.se, arnd@arndb.de, hugh.dickins@tiscali.co.uk, jayakumar.lkml@gmail.com, lethal@linux-sh.org, nickpiggin@yahoo.com.au


The patch titled
     mm: uncached vma support with writenotify
has been added to the -mm tree.  Its filename is
     mm-uncached-vma-support-with-writenotify.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1220,8 +1220,20 @@ munmap_back:
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

linux-next.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
mm-uncached-vma-support-with-writenotify.patch
mmc-let-tmio-mmc-use-dev_name-with-request_irq.patch
mmc-remove-const-from-tmio-mmc-platform-data-v2.patch
mmc-balance-tmio-mmc-cell-enable-disable-calls.patch
spi-superh-msiof-spi-master-driver.patch
spi-superh-msiof-spi-master-driver-update.patch

