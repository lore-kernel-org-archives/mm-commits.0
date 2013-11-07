From: akpm@linux-foundation.org
Subject: +
 arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase.patch added to -mm tree
Date: Thu, 07 Nov 2013 14:16:58 -0800
Message-ID: <527c115a.rHlmYs3xYxOdrDbF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab3KGWQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 17:16:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, lethal@linux-sh.org, jack@suse.cz, cody@linux.vnet.ibm.com

Subject: + arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase.patch added to -mm tree
To: cody@linux.vnet.ibm.com,jack@suse.cz,lethal@linux-sh.org,walken@google.com
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 14:16:58 -0800


The patch titled
     Subject: arch/sh/kernel/dwarf.c: use rbtree postorder iteration helper instead of solution using repeated rb_erase()
has been added to the -mm tree.  Its filename is
     arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: arch/sh/kernel/dwarf.c: use rbtree postorder iteration helper instead of solution using repeated rb_erase()

Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
of using repeated rb_erase() calls

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/dwarf.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN arch/sh/kernel/dwarf.c~arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase arch/sh/kernel/dwarf.c
--- a/arch/sh/kernel/dwarf.c~arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase
+++ a/arch/sh/kernel/dwarf.c
@@ -995,29 +995,19 @@ static struct unwinder dwarf_unwinder =
 
 static void dwarf_unwinder_cleanup(void)
 {
-	struct rb_node **fde_rb_node = &fde_root.rb_node;
-	struct rb_node **cie_rb_node = &cie_root.rb_node;
+	struct dwarf_fde *fde, *next_fde;
+	struct dwarf_cie *cie, *next_cie;
 
 	/*
 	 * Deallocate all the memory allocated for the DWARF unwinder.
 	 * Traverse all the FDE/CIE lists and remove and free all the
 	 * memory associated with those data structures.
 	 */
-	while (*fde_rb_node) {
-		struct dwarf_fde *fde;
-
-		fde = rb_entry(*fde_rb_node, struct dwarf_fde, node);
-		rb_erase(*fde_rb_node, &fde_root);
+	rbtree_postorder_for_each_entry_safe(fde, next_fde, &fde_root, node)
 		kfree(fde);
-	}
-
-	while (*cie_rb_node) {
-		struct dwarf_cie *cie;
 
-		cie = rb_entry(*cie_rb_node, struct dwarf_cie, node);
-		rb_erase(*cie_rb_node, &cie_root);
+	rbtree_postorder_for_each_entry_safe(cie, next_cie, &cie_root, node)
 		kfree(cie);
-	}
 
 	kmem_cache_destroy(dwarf_reg_cachep);
 	kmem_cache_destroy(dwarf_frame_cachep);
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

bitops-find-clarify-and-extend-documentation.patch
linux-next.patch
rbtree-fix-rbtree_postorder_for_each_entry_safe-iterator.patch
rbtree-test-move-rb_node-to-the-middle-of-the-test-struct.patch
rbtree-test-test-rbtree_postorder_for_each_entry_safe.patch
net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding.patch
fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
drivers-mtd-ubi-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase.patch

