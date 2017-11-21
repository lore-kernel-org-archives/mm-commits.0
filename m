From: akpm@linux-foundation.org
Subject: + mm-mempolicy-fix-the-check-of-nodemask-from-user.patch added to -mm tree
Date: Mon, 20 Nov 2017 16:16:33 -0800
Message-ID: <5a137061.PyJCNN8sQT7Ddq7T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53440 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdKUAQf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 19:16:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, ak@linux.intel.com, cl@linux.com, mingo@kernel.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, salls@cs.ucsb.edu, tanxiaojun@huawei.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: fix the check of nodemask from user
has been added to the -mm tree.  Its filename is
     mm-mempolicy-fix-the-check-of-nodemask-from-user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-fix-the-check-of-nodemask-from-user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-fix-the-check-of-nodemask-from-user.patch

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
Subject: mm/mempolicy: fix the check of nodemask from user

As Xiaojun reported the ltp of migrate_pages01 will fail on arm64 system
which has 4 nodes[0...3], all have memory and CONFIG_NODES_SHIFT=2:

migrate_pages01    0  TINFO  :  test_invalid_nodes
migrate_pages01   14  TFAIL  :  migrate_pages_common.c:45: unexpected failure - returned value = 0, expected: -1
migrate_pages01   15  TFAIL  :  migrate_pages_common.c:55: call succeeded unexpectedly

In this case the test_invalid_nodes of migrate_pages01 will call:
SYSC_migrate_pages as:

migrate_pages(0, , {0x0000000000000001}, 64, , {0x0000000000000010}, 64) = 0

The new nodes specifies one or more node IDs that are greater than the
maximum supported node ID, however, the errno is not set to EINVAL as
expected.

As man pages of set_mempolicy[1], mbind[2], and migrate_pages[3]
mentioned, when nodemask specifies one or more node IDs that are greater
than the maximum supported node ID, the errno should set to EINVAL. 
However, get_nodes only check whether the part of bits
[BITS_PER_LONG*BITS_TO_LONGS(MAX_NUMNODES), maxnode) is zero or not, and
remain [MAX_NUMNODES, BITS_PER_LONG*BITS_TO_LONGS(MAX_NUMNODES) unchecked.

This patch is to check the bits of [MAX_NUMNODES, maxnode) in get_nodes to
let migrate_pages set the errno to EINVAL when nodemask specifies one or
more node IDs that are greater than the maximum supported node ID, which
follows the manpage's guide.

[1] http://man7.org/linux/man-pages/man2/set_mempolicy.2.html
[2] http://man7.org/linux/man-pages/man2/mbind.2.html
[3] http://man7.org/linux/man-pages/man2/migrate_pages.2.html

Link: http://lkml.kernel.org/r/1510882624-44342-3-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Reported-by: Tan Xiaojun <tanxiaojun@huawei.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Chris Salls <salls@cs.ucsb.edu>
Cc: Christopher Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-fix-the-check-of-nodemask-from-user mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-fix-the-check-of-nodemask-from-user
+++ a/mm/mempolicy.c
@@ -1263,6 +1263,7 @@ static int get_nodes(nodemask_t *nodes,
 		     unsigned long maxnode)
 {
 	unsigned long k;
+	unsigned long t;
 	unsigned long nlongs;
 	unsigned long endmask;
 
@@ -1279,11 +1280,17 @@ static int get_nodes(nodemask_t *nodes,
 	else
 		endmask = (1UL << (maxnode % BITS_PER_LONG)) - 1;
 
-	/* When the user specified more nodes than supported just check
-	   if the non supported part is all zero. */
+	/*
+	 * When the user specified more nodes than supported just check
+	 * if the non supported part is all zero.
+	 *
+	 * If maxnode have more longs than MAX_NUMNODES, check
+	 * the bits in that area first. And then go through to
+	 * check the rest bits which equal or bigger than MAX_NUMNODES.
+	 * Otherwise, just check bits [MAX_NUMNODES, maxnode).
+	 */
 	if (nlongs > BITS_TO_LONGS(MAX_NUMNODES)) {
 		for (k = BITS_TO_LONGS(MAX_NUMNODES); k < nlongs; k++) {
-			unsigned long t;
 			if (get_user(t, nmask + k))
 				return -EFAULT;
 			if (k == nlongs - 1) {
@@ -1296,6 +1303,16 @@ static int get_nodes(nodemask_t *nodes,
 		endmask = ~0UL;
 	}
 
+	if (maxnode > MAX_NUMNODES && MAX_NUMNODES % BITS_PER_LONG != 0) {
+		unsigned long valid_mask = endmask;
+
+		valid_mask &= ~((1UL << (MAX_NUMNODES % BITS_PER_LONG)) - 1);
+		if (get_user(t, nmask + nlongs - 1))
+			return -EFAULT;
+		if (t & valid_mask)
+			return -EINVAL;
+	}
+
 	if (copy_from_user(nodes_addr(*nodes), nmask, nlongs*sizeof(unsigned long)))
 		return -EFAULT;
 	nodes_addr(*nodes)[nlongs-1] &= endmask;
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are

mm-mempolicy-remove-redundant-check-in-get_nodes.patch
mm-mempolicy-fix-the-check-of-nodemask-from-user.patch
mm-mempolicy-add-nodes_empty-check-in-sysc_migrate_pages.patch

