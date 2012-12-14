From: akpm@linux-foundation.org
Subject: [merged] init-use-n_memory-instead-n_high_memory.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:28:41 -0800
Message-ID: <20121214232841.B302E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:59737 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2LNX2n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:28:43 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so409770vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:28:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init: use N_MEMORY instead N_HIGH_MEMORY
has been removed from the -mm tree.  Its filename was
     init-use-n_memory-instead-n_high_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: init: use N_MEMORY instead N_HIGH_MEMORY

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/main.c~init-use-n_memory-instead-n_high_memory init/main.c
--- a/init/main.c~init-use-n_memory-instead-n_high_memory
+++ a/init/main.c
@@ -857,7 +857,7 @@ static void __init kernel_init_freeable(
 	/*
 	 * init can allocate pages on any node
 	 */
-	set_mems_allowed(node_states[N_HIGH_MEMORY]);
+	set_mems_allowed(node_states[N_MEMORY]);
 	/*
 	 * init can run on any cpu.
 	 */
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

