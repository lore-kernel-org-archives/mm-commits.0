From: akpm@linux-foundation.org
Subject: [merged] lib-btreec-fix-leak-of-whole-btree-nodes.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 13:05:17 -0700
Message-ID: <5390cd7d.R4344SHug/xMqg0q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaFEUFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, johannes@sipsolutions.net, joern@logfs.org, huangminfei@ucloud.cn

Subject: [merged] lib-btreec-fix-leak-of-whole-btree-nodes.patch removed from -mm tree
To: huangminfei@ucloud.cn,joern@logfs.org,johannes@sipsolutions.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:05:17 -0700


The patch titled
     Subject: lib/btree.c: fix leak of whole btree nodes
has been removed from the -mm tree.  Its filename was
     lib-btreec-fix-leak-of-whole-btree-nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minfei Huang <huangminfei@ucloud.cn>
Subject: lib/btree.c: fix leak of whole btree nodes

I use btree from 3.14-rc2 in my own module.  When the btree module is
removed, a warning arises:

kmem_cache_destroy btree_node: Slab cache still has objects
CPU: 13 PID: 9150 Comm: rmmod Tainted: GF          O 3.14.0-rc2 #1
Hardware name: Inspur NF5270M3/NF5270M3, BIOS CHEETAH_2.1.3 09/10/2013
ffff881ff8643b18 ffff881ffdc23ea8 ffffffff815a4ecc 0000000000000000
ffff881ff8643ac0 ffff881ffdc23ec8 ffffffff811610df 0000000000000880
ffffffffa057da60 ffff881ffdc23ed8 ffffffffa057d57c ffff881ffdc23f78
Call Trace:
[<ffffffff815a4ecc>] dump_stack+0x49/0x5d
[<ffffffff811610df>] kmem_cache_destroy+0xcf/0xe0
[<ffffffffa057d57c>] btree_module_exit+0x10/0x12 [btree]
[<ffffffff810d7948>] SyS_delete_module+0x198/0x1f0
[<ffffffff815aac89>] ? retint_swapgs+0xe/0x13
[<ffffffff810a561d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[<ffffffff812addde>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[<ffffffff815b3652>] system_call_fastpath+0x16/0x1b

The cause is that it doesn't release the last btree node, when height = 1
and fill = 1.

[akpm@linux-foundation.org: remove unneeded test of NULL]
Signed-off-by: Minfei Huang <huangminfei@ucloud.cn>
Cc: Joern Engel <joern@logfs.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/btree.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/btree.c~lib-btreec-fix-leak-of-whole-btree-nodes lib/btree.c
--- a/lib/btree.c~lib-btreec-fix-leak-of-whole-btree-nodes
+++ a/lib/btree.c
@@ -198,6 +198,7 @@ EXPORT_SYMBOL_GPL(btree_init);
 
 void btree_destroy(struct btree_head *head)
 {
+	mempool_free(head->node, head->mempool);
 	mempool_destroy(head->mempool);
 	head->mempool = NULL;
 }
_

Patches currently in -mm which might be from huangminfei@ucloud.cn are

origin.patch
linux-next.patch

