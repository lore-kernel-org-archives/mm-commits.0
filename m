From: akpm@linux-foundation.org
Subject: [merged] jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
 removed from -mm tree
Date: Thu, 27 Feb 2014 12:24:06 -0800
Message-ID: <530f9ee6.LTEqgekEvyo4n+s5%akpm__6996.79389731518$1393532662$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaB0UYH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 15:24:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, dwmw2@infradead.org, computersforpeace@gmail.com, artem.bityutskiy@linux.intel.com, lizefan@huawei.com

Subject: [merged] jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch removed from -mm tree
To: lizefan@huawei.com,artem.bityutskiy@linux.intel.com,computersforpeace@gmail.com,dwmw2@infradead.org,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 12:24:06 -0800


The patch titled
     Subject: jffs2: avoid soft-lockup in jffs2_reserve_space_gc()
has been removed from the -mm tree.  Its filename was
     jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: jffs2: avoid soft-lockup in jffs2_reserve_space_gc()

We triggered soft-lockup under stress test on 2.6.34 kernel.

BUG: soft lockup - CPU#1 stuck for 60009ms! [lockf2.test:14488]
...
[<bf09a4d4>] (jffs2_do_reserve_space+0x420/0x440 [jffs2])
[<bf09a528>] (jffs2_reserve_space_gc+0x34/0x78 [jffs2])
[<bf0a1350>] (jffs2_garbage_collect_dnode.isra.3+0x264/0x478 [jffs2])
[<bf0a2078>] (jffs2_garbage_collect_pass+0x9c0/0xe4c [jffs2])
[<bf09a670>] (jffs2_reserve_space+0x104/0x2a8 [jffs2])
[<bf09dc48>] (jffs2_write_inode_range+0x5c/0x4d4 [jffs2])
[<bf097d8c>] (jffs2_write_end+0x198/0x2c0 [jffs2])
[<c00e00a4>] (generic_file_buffered_write+0x158/0x200)
[<c00e14f4>] (__generic_file_aio_write+0x3a4/0x414)
[<c00e15c0>] (generic_file_aio_write+0x5c/0xbc)
[<c012334c>] (do_sync_write+0x98/0xd4)
[<c0123a84>] (vfs_write+0xa8/0x150)
[<c0123d74>] (sys_write+0x3c/0xc0)]

Fix this by adding a cond_resched() in the while loop.

[akpm@linux-foundation.org: don't initialize `ret']
Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/nodemgmt.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN fs/jffs2/nodemgmt.c~jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc fs/jffs2/nodemgmt.c
--- a/fs/jffs2/nodemgmt.c~jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc
+++ a/fs/jffs2/nodemgmt.c
@@ -211,20 +211,25 @@ out:
 int jffs2_reserve_space_gc(struct jffs2_sb_info *c, uint32_t minsize,
 			   uint32_t *len, uint32_t sumsize)
 {
-	int ret = -EAGAIN;
+	int ret;
 	minsize = PAD(minsize);
 
 	jffs2_dbg(1, "%s(): Requested 0x%x bytes\n", __func__, minsize);
 
-	spin_lock(&c->erase_completion_lock);
-	while(ret == -EAGAIN) {
+	while (true) {
+		spin_lock(&c->erase_completion_lock);
 		ret = jffs2_do_reserve_space(c, minsize, len, sumsize);
 		if (ret) {
 			jffs2_dbg(1, "%s(): looping, ret is %d\n",
 				  __func__, ret);
 		}
+		spin_unlock(&c->erase_completion_lock);
+
+		if (ret == -EAGAIN)
+			cond_resched();
+		else
+			break;
 	}
-	spin_unlock(&c->erase_completion_lock);
 	if (!ret)
 		ret = jffs2_prealloc_raw_node_refs(c, c->nextblock, 1);
 
_

Patches currently in -mm which might be from lizefan@huawei.com are

linux-next.patch

