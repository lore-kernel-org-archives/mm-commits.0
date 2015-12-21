From: akpm@linux-foundation.org
Subject: +
 ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-3.patch added to -mm tree
Date: Mon, 21 Dec 2015 12:53:59 -0800
Message-ID: <567866e7.FDYA0336LiojENoX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbbLUUx7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Dec 2015 15:53:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: validate STABLE_NODE_DUP_HEAD conditional to gcc version
has been added to the -mm tree.  Its filename is
     ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: ksm: validate STABLE_NODE_DUP_HEAD conditional to gcc version

BUILD_BUG_ON can only validate this successfully on recent gcc.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/ksm.c~ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-3 mm/ksm.c
--- a/mm/ksm.c~ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-3
+++ a/mm/ksm.c
@@ -629,8 +629,10 @@ static void remove_node_from_stable_tree
 	 * from &migrate_nodes. This will verify that future list.h changes
 	 * don't break STABLE_NODE_DUP_HEAD.
 	 */
+#if GCC_VERSION >= 40903 /* only recent gcc can handle it */
 	BUILD_BUG_ON(STABLE_NODE_DUP_HEAD <= &migrate_nodes);
 	BUILD_BUG_ON(STABLE_NODE_DUP_HEAD >= &migrate_nodes + 1);
+#endif
 
 	if (stable_node->head == &migrate_nodes)
 		list_del(&stable_node->list);
_

Patches currently in -mm which might be from aarcange@redhat.com are

ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-3.patch

