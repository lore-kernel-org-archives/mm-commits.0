Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218A1C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEC9C64F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhBYTiF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:38:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232350AbhBYTfl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E644E64FC0;
        Thu, 25 Feb 2021 19:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280734;
        bh=zztPurT3lESfHzMOlVvMAXX7Lg4w5X36C/HUq+YRiLE=;
        h=Date:From:To:Subject:From;
        b=h0l7UMZgJlqCuKC7dnign+gBXqOtU79efGenyN1FGo/MmEqbapImD29DHwtejaZ7i
         RLhbY8/oKo1X/0fmKtbolg79upPYb9XpMvvwOCXCoEksfmPyKRa+iz8plvQWRQiO9K
         XWwz+4Pzj99ZJ9AdUAkWt5uWYgoZBlX4zldcaIts=
Date:   Thu, 25 Feb 2021 11:18:53 -0800
From:   akpm@linux-foundation.org
To:     ak@linux.intel.com, dave.hansen@intel.com, hannes@cmpxchg.org,
        mgorman@suse.de, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, peterz@infradead.org, riel@surriel.com,
        rientjes@google.com, willy@infradead.org, ying.huang@intel.com
Subject:  [merged]
 numa-balancing-migrate-on-fault-among-multiple-bound-nodes.patch removed
 from -mm tree
Message-ID: <20210225191853._jaN0KVsp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: numa balancing: migrate on fault among multiple bound nodes
has been removed from the -mm tree.  Its filename was
     numa-balancing-migrate-on-fault-among-multiple-bound-nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: numa balancing: migrate on fault among multiple bound nodes

Now, NUMA balancing can only optimize the page placement among the NUMA
nodes if the default memory policy is used.  Because the memory policy
specified explicitly should take precedence.  But this seems too strict in
some situations.  For example, on a system with 4 NUMA nodes, if the
memory of an application is bound to the node 0 and 1, NUMA balancing can
potentially migrate the pages between the node 0 and 1 to reduce
cross-node accessing without breaking the explicit memory binding policy.

So in this patch, we add MPOL_F_NUMA_BALANCING mode flag to
set_mempolicy() when mode is MPOL_BIND.  With the flag specified, NUMA
balancing will be enabled within the thread to optimize the page placement
within the constrains of the specified memory binding policy.  With the
newly added flag, the NUMA balancing control mechanism becomes,

- sysctl knob numa_balancing can enable/disable the NUMA balancing
  globally.

- even if sysctl numa_balancing is enabled, the NUMA balancing will be
  disabled for the memory areas or applications with the explicit memory
  policy by default.

- MPOL_F_NUMA_BALANCING can be used to enable the NUMA balancing for the
  applications when specifying the explicit memory policy (MPOL_BIND).

Various page placement optimization based on the NUMA balancing can be
done with these flags.  As the first step, in this patch, if the memory of
the application is bound to multiple nodes (MPOL_BIND), and in the hint
page fault handler the accessing node are in the policy nodemask, the page
will be tried to be migrated to the accessing node to reduce the
cross-node accessing.

If the newly added MPOL_F_NUMA_BALANCING flag is specified by an
application on an old kernel version without its support, set_mempolicy()
will return -1 and errno will be set to EINVAL.  The application can use
this behavior to run on both old and new kernel versions.

And if the MPOL_F_NUMA_BALANCING flag is specified for the mode other than
MPOL_BIND, set_mempolicy() will return -1 and errno will be set to EINVAL
as before.  Because we don't support optimization based on the NUMA
balancing for these modes.

In the previous version of the patch, we tried to reuse MPOL_MF_LAZY for
mbind().  But that flag is tied to MPOL_MF_MOVE.*, so it seems not a good
API/ABI for the purpose of the patch.

And because it's not clear whether it's necessary to enable NUMA balancing
for a specific memory area inside an application, so we only add the flag
at the thread level (set_mempolicy()) instead of the memory area level
(mbind()).  We can do that when it become necessary.

To test the patch, we run a test case as follows on a 4-node machine with
192 GB memory (48 GB per node).

1. Change pmbench memory accessing benchmark to call set_mempolicy()
   to bind its memory to node 1 and 3 and enable NUMA balancing.  Some
   related code snippets are as follows,

     #include <numaif.h>
     #include <numa.h>

	struct bitmask *bmp;
	int ret;

	bmp = numa_parse_nodestring("1,3");
	ret = set_mempolicy(MPOL_BIND | MPOL_F_NUMA_BALANCING,
			    bmp->maskp, bmp->size + 1);
	/* If MPOL_F_NUMA_BALANCING isn't supported, fall back to MPOL_BIND */
	if (ret < 0 && errno == EINVAL)
		ret = set_mempolicy(MPOL_BIND, bmp->maskp, bmp->size + 1);
	if (ret < 0) {
		perror("Failed to call set_mempolicy");
		exit(-1);
	}

2. Run a memory eater on node 3 to use 40 GB memory before running pmbench.

3. Run pmbench with 64 processes, the working-set size of each process
   is 640 MB, so the total working-set size is 64 * 640 MB = 40 GB.  The
   CPU and the memory (as in step 1.) of all pmbench processes is bound
   to node 1 and 3. So, after CPU usage is balanced, some pmbench
   processes run on the CPUs of the node 3 will access the memory of
   the node 1.

4. After the pmbench processes run for 100 seconds, kill the memory
   eater.  Now it's possible for some pmbench processes to migrate
   their pages from node 1 to node 3 to reduce cross-node accessing.

Test results show that, with the patch, the pages can be migrated from
node 1 to node 3 after killing the memory eater, and the pmbench score
can increase about 17.5%.

Link: https://lkml.kernel.org/r/20210120061235.148637-2-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/mempolicy.h |    4 +++-
 mm/mempolicy.c                 |   16 ++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/mempolicy.h~numa-balancing-migrate-on-fault-among-multiple-bound-nodes
+++ a/include/uapi/linux/mempolicy.h
@@ -28,12 +28,14 @@ enum {
 /* Flags for set_mempolicy */
 #define MPOL_F_STATIC_NODES	(1 << 15)
 #define MPOL_F_RELATIVE_NODES	(1 << 14)
+#define MPOL_F_NUMA_BALANCING	(1 << 13) /* Optimize with NUMA balancing if possible */
 
 /*
  * MPOL_MODE_FLAGS is the union of all possible optional mode flags passed to
  * either set_mempolicy() or mbind().
  */
-#define MPOL_MODE_FLAGS	(MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES)
+#define MPOL_MODE_FLAGS							\
+	(MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES | MPOL_F_NUMA_BALANCING)
 
 /* Flags for get_mempolicy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
--- a/mm/mempolicy.c~numa-balancing-migrate-on-fault-among-multiple-bound-nodes
+++ a/mm/mempolicy.c
@@ -875,6 +875,16 @@ static long do_set_mempolicy(unsigned sh
 		goto out;
 	}
 
+	if (flags & MPOL_F_NUMA_BALANCING) {
+		if (new && new->mode == MPOL_BIND) {
+			new->flags |= (MPOL_F_MOF | MPOL_F_MORON);
+		} else {
+			ret = -EINVAL;
+			mpol_put(new);
+			goto out;
+		}
+	}
+
 	ret = mpol_set_nodemask(new, nodes, scratch);
 	if (ret) {
 		mpol_put(new);
@@ -2486,6 +2496,12 @@ int mpol_misplaced(struct page *page, st
 		break;
 
 	case MPOL_BIND:
+		/* Optimize placement among multiple nodes via NUMA balancing */
+		if (pol->flags & MPOL_F_MORON) {
+			if (node_isset(thisnid, pol->v.nodes))
+				break;
+			goto out;
+		}
 
 		/*
 		 * allows binding to multiple nodes.
_

Patches currently in -mm which might be from ying.huang@intel.com are


