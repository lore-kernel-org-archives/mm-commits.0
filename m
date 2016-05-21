From: akpm@linux-foundation.org
Subject: [patch 110/162] radix-tree: remove restriction on multi-order
 entries
Date: Fri, 20 May 2016 17:02:05 -0700
Message-ID: <573fa57d.wOjzCao2qZw7ab/f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbcEUACH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: remove restriction on multi-order entries

Now that sibling pointers are handled explicitly, there is no purpose
served by restricting the order to be >= RADIX_TREE_MAP_SHIFT.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-remove-restriction-on-multi-order-entries lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-remove-restriction-on-multi-order-entries
+++ a/lib/radix-tree.c
@@ -483,8 +483,6 @@ int __radix_tree_create(struct radix_tre
 	unsigned int height, shift, offset;
 	int error;
 
-	BUG_ON((0 < order) && (order < RADIX_TREE_MAP_SHIFT));
