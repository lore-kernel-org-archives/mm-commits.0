From: akpm@linux-foundation.org
Subject: [patch 108/162] radix-tree: fix sibling entry insertion
Date: Fri, 20 May 2016 17:01:59 -0700
Message-ID: <573fa577.Cbwi3x9EtKDnrsQV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbcEUACB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: fix sibling entry insertion

The subtraction was the wrong way round, leading to undefined behaviour
(shift by an amount larger than the size of the type).

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-fix-sibling-entry-insertion lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-sibling-entry-insertion
+++ a/lib/radix-tree.c
@@ -526,8 +526,8 @@ int __radix_tree_create(struct radix_tre
 
 #ifdef CONFIG_RADIX_TREE_MULTIORDER
 	/* Insert pointers to the canonical entry */
-	if ((shift - order) > 0) {
-		int i, n = 1 << (shift - order);
+	if (order > shift) {
+		int i, n = 1 << (order - shift);
 		offset = offset & ~(n - 1);
 		slot = ptr_to_indirect(&node->slots[offset]);
 		for (i = 0; i < n; i++) {
_
