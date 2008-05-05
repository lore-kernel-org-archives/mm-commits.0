From: akpm@linux-foundation.org
Subject: - 9p-use-correct-type-for-processor-flags.patch removed from -mm tree
Date: Mon, 05 May 2008 12:17:12 -0700
Message-ID: <200805051917.m45JHCqB000439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbYEETRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:17:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, ericvh@gmail.com, lucho@ionkov.net, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     9p: use correct type for processor flags
has been removed from the -mm tree.  Its filename was
     9p-use-correct-type-for-processor-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 9p: use correct type for processor flags
From: Steven Rostedt <rostedt@goodmis.org>

Some files in the net/9p directory uses "int" for flags.  This can cause hard
to find bugs on some architectures.  This patch converts the flags to use
"long" instead.

This bug was discovered by doing an allyesconfig make on the -rt kernel where
checks are done to ensure all flags are of size sizeof(long).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/9p/trans_virtio.c |    2 +-
 net/9p/util.c         |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN net/9p/trans_virtio.c~9p-use-correct-type-for-processor-flags net/9p/trans_virtio.c
--- a/net/9p/trans_virtio.c~9p-use-correct-type-for-processor-flags
+++ a/net/9p/trans_virtio.c
@@ -134,7 +134,7 @@ static void p9_virtio_close(struct p9_tr
 {
 	struct virtio_chan *chan = trans->priv;
 	int count;
-	unsigned int flags;
+	unsigned long flags;
 
 	spin_lock_irqsave(&chan->lock, flags);
 	p9_idpool_destroy(chan->tagpool);
diff -puN net/9p/util.c~9p-use-correct-type-for-processor-flags net/9p/util.c
--- a/net/9p/util.c~9p-use-correct-type-for-processor-flags
+++ a/net/9p/util.c
@@ -71,7 +71,7 @@ int p9_idpool_get(struct p9_idpool *p)
 {
 	int i = 0;
 	int error;
-	unsigned int flags;
+	unsigned long flags;
 
 retry:
 	if (idr_pre_get(&p->pool, GFP_KERNEL) == 0)
@@ -102,7 +102,7 @@ EXPORT_SYMBOL(p9_idpool_get);
 
 void p9_idpool_put(int id, struct p9_idpool *p)
 {
-	unsigned int flags;
+	unsigned long flags;
 	spin_lock_irqsave(&p->lock, flags);
 	idr_remove(&p->pool, id);
 	spin_unlock_irqrestore(&p->lock, flags);
_

Patches currently in -mm which might be from rostedt@goodmis.org are

linux-next.patch
fix-irq-flags-in-mac80211-code.patch
fix-irq-flags-in-saa7134.patch
fix-irq-flags-in-rtc-ds1511.patch
fix-irq-flags-for-iuu_phoenixc.patch
git-v9fs.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch

