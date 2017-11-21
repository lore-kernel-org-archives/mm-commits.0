From: akpm@linux-foundation.org
Subject: + mm-mempolicy-remove-redundant-check-in-get_nodes.patch added to -mm tree
Date: Mon, 20 Nov 2017 16:16:30 -0800
Message-ID: <5a13705e.Hm2vhM3Znqxwk4lG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53420 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdKUAQc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 19:16:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, ak@linux.intel.com, cl@linux.com, mingo@kernel.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, salls@cs.ucsb.edu, tanxiaojun@huawei.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: remove redundant check in get_nodes
has been added to the -mm tree.  Its filename is
     mm-mempolicy-remove-redundant-check-in-get_nodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-remove-redundant-check-in-get_nodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-remove-redundant-check-in-get_nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm/mempolicy: remove redundant check in get_nodes

We have already checked whether maxnode is a page worth of bits, by:
    maxnode > PAGE_SIZE*BITS_PER_BYTE

So no need to check it once more.

Link: http://lkml.kernel.org/r/1510882624-44342-2-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Chris Salls <salls@cs.ucsb.edu>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Tan Xiaojun <tanxiaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-remove-redundant-check-in-get_nodes mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-remove-redundant-check-in-get_nodes
+++ a/mm/mempolicy.c
@@ -1282,8 +1282,6 @@ static int get_nodes(nodemask_t *nodes,
 	/* When the user specified more nodes than supported just check
 	   if the non supported part is all zero. */
 	if (nlongs > BITS_TO_LONGS(MAX_NUMNODES)) {
-		if (nlongs > PAGE_SIZE/sizeof(long))
-			return -EINVAL;
 		for (k = BITS_TO_LONGS(MAX_NUMNODES); k < nlongs; k++) {
 			unsigned long t;
 			if (get_user(t, nmask + k))
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are

mm-mempolicy-remove-redundant-check-in-get_nodes.patch
mm-mempolicy-fix-the-check-of-nodemask-from-user.patch
mm-mempolicy-add-nodes_empty-check-in-sysc_migrate_pages.patch

