From: akpm@linux-foundation.org
Subject: [alternative-merged] jbd-remove-dependency-on-__gfp_nofail.patch removed from -mm tree
Date: Fri, 27 May 2011 15:56:43 -0700
Message-ID: <201105272256.p4RMuhS3026343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754130Ab1E0W4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 18:56:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, adilger@sun.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     jbd: remove dependency on __GFP_NOFAIL
has been removed from the -mm tree.  Its filename was
     jbd-remove-dependency-on-__gfp_nofail.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: remove dependency on __GFP_NOFAIL
From: David Rientjes <rientjes@google.com>

The kzalloc() in start_this_handle() is failable, so remove __GFP_NOFAIL
from its mask.

If this is in the direct reclaim path, then current has PF_MEMALLOC which
allows it to allocate with memory reserves in lowmem situations.

Using GFP_NOFS with __GFP_NOFAIL is always dangerous because the oom
killer cannot be invoked for GFP_NOFS, so the potential for infinitely
looping in the page allocator is even greater the way it is currently
written.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/transaction.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/jbd/transaction.c~jbd-remove-dependency-on-__gfp_nofail fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-remove-dependency-on-__gfp_nofail
+++ a/fs/jbd/transaction.c
@@ -99,8 +99,7 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = kzalloc(sizeof(*new_transaction),
-						GFP_NOFS|__GFP_NOFAIL);
+		new_transaction = kzalloc(sizeof(*new_transaction), GFP_NOFS);
 		if (!new_transaction) {
 			ret = -ENOMEM;
 			goto out;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-increase-reclaim_distance-to-30.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

