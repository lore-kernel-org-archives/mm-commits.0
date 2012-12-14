From: akpm@linux-foundation.org
Subject: [merged] mmmigrate-use-n_memory-instead-n_high_memory.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:28:20 -0800
Message-ID: <20121214232821.3027E200089@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:38224 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945895Ab2LNX2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:28:23 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so208142eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:28:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,migrate: use N_MEMORY instead N_HIGH_MEMORY
has been removed from the -mm tree.  Its filename was
     mmmigrate-use-n_memory-instead-n_high_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: mm,migrate: use N_MEMORY instead N_HIGH_MEMORY

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mmmigrate-use-n_memory-instead-n_high_memory mm/migrate.c
--- a/mm/migrate.c~mmmigrate-use-n_memory-instead-n_high_memory
+++ a/mm/migrate.c
@@ -1238,7 +1238,7 @@ static int do_pages_move(struct mm_struc
 			if (node < 0 || node >= MAX_NUMNODES)
 				goto out_pm;
 
-			if (!node_state(node, N_HIGH_MEMORY))
+			if (!node_state(node, N_MEMORY))
 				goto out_pm;
 
 			err = -EACCES;
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

