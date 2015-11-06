From: akpm@linux-foundation.org
Subject: [merged]
 ksm-use-the-helper-method-to-do-the-hlist_empty-check.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:16:13 -0800
Message-ID: <563d0a8d.px0B9a4IQx+05KrE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162952AbbKFUQN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: use the helper method to do the hlist_empty check
has been removed from the -mm tree.  Its filename was
     ksm-use-the-helper-method-to-do-the-hlist_empty-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: ksm: use the helper method to do the hlist_empty check

This just uses the helper function to cleanup the assumption on the
hlist_node internals.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/ksm.c~ksm-use-the-helper-method-to-do-the-hlist_empty-check mm/ksm.c
--- a/mm/ksm.c~ksm-use-the-helper-method-to-do-the-hlist_empty-check
+++ a/mm/ksm.c
@@ -625,7 +625,7 @@ static void remove_rmap_item_from_tree(s
 		unlock_page(page);
 		put_page(page);
 
-		if (stable_node->hlist.first)
+		if (!hlist_empty(&stable_node->hlist))
 			ksm_pages_sharing--;
 		else
 			ksm_pages_shared--;
_

Patches currently in -mm which might be from aarcange@redhat.com are


