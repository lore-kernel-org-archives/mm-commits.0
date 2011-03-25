From: akpm@linux-foundation.org
Subject: [merged] kvm-stop-including-asm-generic-bitops-leh-directly.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:28 -0700
Message-ID: <201103250723.p2P7NMO7025721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab1CYHXf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:23:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, avi@redhat.com, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kvm: stop including asm-generic/bitops/le.h directly
has been removed from the -mm tree.  Its filename was
     kvm-stop-including-asm-generic-bitops-leh-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kvm: stop including asm-generic/bitops/le.h directly
From: Akinobu Mita <akinobu.mita@gmail.com>

asm-generic/bitops/le.h is only intended to be included directly from
asm-generic/bitops/ext2-non-atomic.h or asm-generic/bitops/minix-le.h
which implements generic ext2 or minix bit operations.

This stops including asm-generic/bitops/le.h directly and use ext2
non-atomic bit operations instead.

It seems odd to use ext2_set_bit() on kvm, but it will replaced with
__set_bit_le() after introducing little endian bit operations for all
architectures.  This indirect step is necessary to maintain bisectability
for some architectures which have their own little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 virt/kvm/kvm_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN virt/kvm/kvm_main.c~kvm-stop-including-asm-generic-bitops-leh-directly virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~kvm-stop-including-asm-generic-bitops-leh-directly
+++ a/virt/kvm/kvm_main.c
@@ -52,7 +52,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm-generic/bitops/le.h>
 
 #include "coalesced_mmio.h"
 #include "async_pf.h"
@@ -1439,7 +1438,7 @@ void mark_page_dirty_in_slot(struct kvm 
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 
-		generic___set_le_bit(rel_gfn, memslot->dirty_bitmap);
+		ext2_set_bit(rel_gfn, memslot->dirty_bitmap);
 	}
 }
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

