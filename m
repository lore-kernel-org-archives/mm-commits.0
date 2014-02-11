From: akpm@linux-foundation.org
Subject: + jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch added
 to -mm tree
Date: Tue, 11 Feb 2014 15:56:26 -0800
Message-ID: <52fab8aa.Y5xmJakoYYxYdPXV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaBKX41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 18:56:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, dwmw2@infradead.org, lizefan@huawei.com

Subject: + jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch added to -mm tree
To: lizefan@huawei.com,dwmw2@infradead.org,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 15:56:26 -0800


The patch titled
     Subject: jffs2: avoid soft-lockup in jffs2_reserve_space_gc()
has been added to the -mm tree.  Its filename is
     jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: <stable@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/nodemgmt.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN fs/jffs2/nodemgmt.c~jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc fs/jffs2/nodemgmt.c
--- a/fs/jffs2/nodemgmt.c~jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc
+++ a/fs/jffs2/nodemgmt.c
@@ -216,15 +216,20 @@ int jffs2_reserve_space_gc(struct jffs2_
 
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

jffs2-fix-unbalanced-locking.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc-fix.patch
jffs2-remove-wait-queue-after-schedule.patch
linux-next.patch

