From: akpm@linux-foundation.org
Subject: + 9p-use-correct-type-for-processor-flags.patch added to -mm tree
Date: Thu, 01 May 2008 14:20:06 -0700
Message-ID: <200805012120.m41LK6Yc025888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760841AbYEAVVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 17:21:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, ericvh@gmail.com, lucho@ionkov.net, srostedt@redhat.com


The patch titled
     9p: use correct type for processor flags
has been added to the -mm tree.  Its filename is
     9p-use-correct-type-for-processor-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
git-sched.patch
9p-use-correct-type-for-processor-flags.patch

