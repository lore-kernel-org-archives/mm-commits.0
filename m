From: akpm@linux-foundation.org
Subject: +
 radix-tree-get_slot_offset-returns-invalid-offset-when-parent-is-null.patch added to -mm tree
Date: Tue, 10 Oct 2017 13:54:07 -0700
Message-ID: <59dd336f.9Fd6a3NfjuC78NPh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57122 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933196AbdJJUyI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 16:54:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: get_slot_offset() returns invalid offset when parent is NULL
has been added to the -mm tree.  Its filename is
     radix-tree-get_slot_offset-returns-invalid-offset-when-parent-is-null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-get_slot_offset-returns-invalid-offset-when-parent-is-null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-get_slot_offset-returns-invalid-offset-when-parent-is-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: radix-tree: get_slot_offset() returns invalid offset when parent is NULL

Needs new changelog.  And maybe a -stable backport?

Link: http://lkml.kernel.org/r/20171010025201.5895-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/radix-tree.c~radix-tree-get_slot_offset-returns-invalid-offset-when-parent-is-null lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-get_slot_offset-returns-invalid-offset-when-parent-is-null
+++ a/lib/radix-tree.c
@@ -119,7 +119,7 @@ bool is_sibling_entry(const struct radix
 static inline unsigned long
 get_slot_offset(const struct radix_tree_node *parent, void __rcu **slot)
 {
-	return slot - parent->slots;
+	return parent ? (slot - parent->slots):0;
 }
 
 static unsigned int radix_tree_descend(const struct radix_tree_node *parent,
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

radix-tree-get_slot_offset-returns-invalid-offset-when-parent-is-null.patch
mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch

