From: akpm@linux-foundation.org
Subject: [merged] kvm-use-little-endian-bitops.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:58 -0700
Message-ID: <201103250723.p2P7Nqhm025775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933600Ab1CYHYA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, avi@redhat.com, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kvm: use little-endian bitops
has been removed from the -mm tree.  Its filename was
     kvm-use-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kvm: use little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for removing ext2 non-atomic bit operations from
asm/bitops.h.  This converts ext2 non-atomic bit operations to
little-endian bit operations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN virt/kvm/kvm_main.c~kvm-use-little-endian-bitops virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~kvm-use-little-endian-bitops
+++ a/virt/kvm/kvm_main.c
@@ -1438,7 +1438,7 @@ void mark_page_dirty_in_slot(struct kvm 
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 
-		ext2_set_bit(rel_gfn, memslot->dirty_bitmap);
+		__set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

