From: akpm@linux-foundation.org
Subject: - find_extend_vma-fix-result-of-bungled-merging.patch removed from -mm tree
Date: Wed, 12 Nov 2008 12:46:55 -0800
Message-ID: <200811122046.mACKktKE006733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbYKLUrH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 15:47:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, deller@gmx.de, jer@gentoo.org, jirislaby@gmail.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     find_extend_vma(): fix result of bungled merging
has been removed from the -mm tree.  Its filename was
     find_extend_vma-fix-result-of-bungled-merging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: find_extend_vma(): fix result of bungled merging
From: Denys Vlasenko <vda.linux@googlemail.com>

This test of `prev' got accidentally removed in
cb8f488c33539f096580e202f5438a809195008f ("mmap.c: deinline a few
functions")

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Helge Deller <deller@gmx.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeroen Roovers <jer@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~find_extend_vma-fix-result-of-bungled-merging mm/mmap.c
--- a/mm/mmap.c~find_extend_vma-fix-result-of-bungled-merging
+++ a/mm/mmap.c
@@ -1704,7 +1704,7 @@ find_extend_vma(struct mm_struct *mm, un
 	vma = find_vma_prev(mm, addr, &prev);
 	if (vma && (vma->vm_start <= addr))
 		return vma;
-	if (expand_stack(prev, addr))
+	if (!prev || expand_stack(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED) {
 		if (mlock_vma_pages_range(prev, addr, prev->vm_end) < 0)
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

origin.patch
linux-next.patch

