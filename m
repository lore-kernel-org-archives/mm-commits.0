From: akpm@linux-foundation.org
Subject: [merged] mips-zero-out-pg_data_t-when-its-allocated.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:18:58 -0700
Message-ID: <20120801201858.D4B221E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab2HAUS7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:18:59 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:18:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ralf@linux-mips.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: zero out pg_data_t when it's allocated
has been removed from the -mm tree.  Its filename was
     mips-zero-out-pg_data_t-when-its-allocated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mips: zero out pg_data_t when it's allocated

This patch is preparation for the next patch which removes the zeroing of
the pg_data_t in core MM.  All archs except MIPS already do this.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Tejun Heo <tj@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/sgi-ip27/ip27-memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/mips/sgi-ip27/ip27-memory.c~mips-zero-out-pg_data_t-when-its-allocated arch/mips/sgi-ip27/ip27-memory.c
--- a/arch/mips/sgi-ip27/ip27-memory.c~mips-zero-out-pg_data_t-when-its-allocated
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -401,6 +401,7 @@ static void __init node_mem_init(cnodeid
 	 * Allocate the node data structures on the node first.
 	 */
 	__node_data[node] = __va(slot_freepfn << PAGE_SHIFT);
+	memset(__node_data[node], 0, PAGE_SIZE);
 
 	NODE_DATA(node)->bdata = &bootmem_node_data[node];
 	NODE_DATA(node)->node_start_pfn = start_pfn;
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-__gfp_no_kswapd.patch
remove-__gfp_no_kswapd-fixes-fix.patch

