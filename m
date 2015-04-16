From: akpm@linux-foundation.org
Subject: [merged] mm-mmapc-use-while-instead-of-ifgoto.patch removed from
 -mm tree
Date: Thu, 16 Apr 2015 09:52:31 -0700
Message-ID: <552fe8cf.n7HFbZ+CuY+5+eQo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbbDPQrC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, gorcunov@openvz.org, hughd@google.com, kirill.shutemov@linux.intel.com, klamm@yandex-team.ru, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: use while instead of if+goto
has been removed from the -mm tree.  Its filename was
     mm-mmapc-use-while-instead-of-ifgoto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm/mmap.c: use while instead of if+goto

The creators of the C language gave us the while keyword. Let's use
that instead of synthesizing it from if+goto.

Made possible by 6597d783397a ("mm/mmap.c: replace find_vma_prepare()
with clearer find_vma_links()").

[akpm@linux-foundation.org: fix 80-col overflows]
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-use-while-instead-of-ifgoto mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-use-while-instead-of-ifgoto
+++ a/mm/mmap.c
@@ -1551,11 +1551,10 @@ unsigned long mmap_region(struct file *f
 
 	/* Clear old maps */
 	error = -ENOMEM;
-munmap_back:
-	if (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent)) {
+	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link,
+			      &rb_parent)) {
 		if (do_munmap(mm, addr, len))
 			return -ENOMEM;
-		goto munmap_back;
 	}
 
 	/*
@@ -1571,7 +1570,8 @@ munmap_back:
 	/*
 	 * Can we just expand an old mapping?
 	 */
-	vma = vma_merge(mm, prev, addr, addr + len, vm_flags, NULL, file, pgoff, NULL);
+	vma = vma_merge(mm, prev, addr, addr + len, vm_flags, NULL, file, pgoff,
+			NULL);
 	if (vma)
 		goto out;
 
@@ -2739,11 +2739,10 @@ static unsigned long do_brk(unsigned lon
 	/*
 	 * Clear old maps.  this also does some error checking for us
 	 */
- munmap_back:
-	if (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent)) {
+	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link,
+			      &rb_parent)) {
 		if (do_munmap(mm, addr, len))
 			return -ENOMEM;
-		goto munmap_back;
 	}
 
 	/* Check against address space limits *after* clearing old maps... */
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-find__bit-reimplementation.patch
lib-find__bit-reimplementation-fix.patch
lib-move-find_last_bit-to-lib-find_next_bitc.patch
lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
lib-vsprintfc-even-faster-decimal-conversion-fix.patch
lib-vsprintfc-improve-put_dec_trunc8-slightly.patch
lib-bitmap_-remove-code-duplication.patch
binfmt_misc-simplify-entry_status.patch
binfmt_misc-simplify-entry_status-fix.patch
linux-next.patch

