From: akpm@linux-foundation.org
Subject: + find_extend_vma-fix-result-of-bungled-merging.patch added to -mm tree
Date: Tue, 11 Nov 2008 16:54:14 -0800
Message-ID: <200811120054.mAC0sEEh025576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbYKLAyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Nov 2008 19:54:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vda.linux@googlemail.com, deller@gmx.de, jer@gentoo.org, jirislaby@gmail.com, jkosina@suse.cz


The patch titled
     find_extend_vma(): fix result of bungled merging
has been added to the -mm tree.  Its filename is
     find_extend_vma-fix-result-of-bungled-merging.patch

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

find_extend_vma-fix-result-of-bungled-merging.patch

