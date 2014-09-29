From: akpm@linux-foundation.org
Subject: [merged] mm-softdirty-keep-bit-when-zapping-file-pte.patch
 removed from -mm tree
Date: Mon, 29 Sep 2014 13:22:36 -0700
Message-ID: <5429bf8c.fAmBymWKJsvL02cF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaI2UWg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Sep 2014 16:22:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pfeiner@google.com, gorcunov@openvz.org, hughd@google.com, jamieliu@google.com, stable@vger.kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: softdirty: keep bit when zapping file pte
has been removed from the -mm tree.  Its filename was
     mm-softdirty-keep-bit-when-zapping-file-pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Feiner <pfeiner@google.com>
Subject: mm: softdirty: keep bit when zapping file pte

Fixes the same bug as b43790eedd31e9 ("mm: softdirty: don't forget to save
file map softdiry bit on unmap") and 9aed8614af5a05cd ("mm/memory.c: don't
forget to set softdirty on file mapped fault") where the return value of
pte_*mksoft_dirty was being ignored.

To be sure that no other pte/pmd "mk" function return values were being
ignored, I annotated the functions in arch/x86/include/asm/pgtable.h with
__must_check and rebuilt.

The userspace effect of this bug is that the softdirty mark might be
lost if a file mapped pte get zapped.

Signed-off-by: Peter Feiner <pfeiner@google.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Jamie Liu <jamieliu@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-softdirty-keep-bit-when-zapping-file-pte mm/memory.c
--- a/mm/memory.c~mm-softdirty-keep-bit-when-zapping-file-pte
+++ a/mm/memory.c
@@ -1127,7 +1127,7 @@ again:
 						addr) != page->index) {
 				pte_t ptfile = pgoff_to_pte(page->index);
 				if (pte_soft_dirty(ptent))
-					pte_file_mksoft_dirty(ptfile);
+					ptfile = pte_file_mksoft_dirty(ptfile);
 				set_pte_at(mm, addr, pte, ptfile);
 			}
 			if (PageAnon(page))
_

Patches currently in -mm which might be from pfeiner@google.com are

mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch
mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared-fix.patch

