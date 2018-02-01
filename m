From: akpm@linux-foundation.org
Subject: [patch 034/119] mm/mempolicy: remove redundant check in
 get_nodes
Date: Wed, 31 Jan 2018 16:16:07 -0800
Message-ID: <20180201001607.w-qJdPD0D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34176 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754449AbeBAAQJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:16:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, akpm@linux-foundation.org, cl@linux.com, mingo@kernel.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, salls@cs.ucsb.edu, tanxiaojun@huawei.com, torvalds@linux-foundation.org, vbabka@suse.cz, xieyisheng1@huawei.com

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
