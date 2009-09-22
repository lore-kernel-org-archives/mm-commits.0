From: akpm@linux-foundation.org
Subject: [merged] mmap-remove-unnecessary-code.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:43:16 -0700
Message-ID: <200909222043.n8MKhGCM011286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060AbZIVUnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie8@gmail.com, hugh.dickins@tiscali.co.uk, mm-commits@vger.kernel.org


The patch titled
     mmap: remove unnecessary code
has been removed from the -mm tree.  Its filename was
     mmap-remove-unnecessary-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmap: remove unnecessary code
From: Huang Shijie <shijie8@gmail.com>

If (flags & MAP_LOCKED) is true, it means vm_flags has already contained
the bit VM_LOCKED which is set by calc_vm_flag_bits().

So there is no need to reset it again, just remove it.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/mmap.c~mmap-remove-unnecessary-code mm/mmap.c
--- a/mm/mmap.c~mmap-remove-unnecessary-code
+++ a/mm/mmap.c
@@ -963,11 +963,9 @@ unsigned long do_mmap_pgoff(struct file 
 	vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags) |
 			mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
 
-	if (flags & MAP_LOCKED) {
+	if (flags & MAP_LOCKED)
 		if (!can_do_mlock())
 			return -EPERM;
-		vm_flags |= VM_LOCKED;
-	}
 
 	/* mlock MCL_FUTURE? */
 	if (vm_flags & VM_LOCKED) {
_

Patches currently in -mm which might be from shijie8@gmail.com are

origin.patch

