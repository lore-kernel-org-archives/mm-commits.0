From: akpm@linux-foundation.org
Subject: [merged] fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:37 -0700
Message-ID: <20120329191337.7056CA01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:63583 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933748Ab2C2TNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:38 -0400
Received: by yhgm50 with SMTP id m50so303448yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gilad@benyossef.com, a.p.zijlstra@chello.nl, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: only send IPI to invalidate LRU BH when needed
has been removed from the -mm tree.  Its filename was
     fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: fs: only send IPI to invalidate LRU BH when needed

In several code paths, such as when unmounting a file system (but not
only) we send an IPI to ask each cpu to invalidate its local LRU BHs.

For multi-cores systems that have many cpus that may not have any LRU BH
because they are idle or because they have not performed any file system
accesses since last invalidation (e.g.  CPU crunching on high perfomance
computing nodes that write results to shared memory or only using
filesystems that do not use the bh layer.) This can lead to loss of
performance each time someone switches the KVM (the virtual keyboard and
screen type, not the hypervisor) if it has a USB storage stuck in.

This patch attempts to only send an IPI to cpus that have LRU BH.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN fs/buffer.c~fs-only-send-ipi-to-invalidate-lru-bh-when-needed fs/buffer.c
--- a/fs/buffer.c~fs-only-send-ipi-to-invalidate-lru-bh-when-needed
+++ a/fs/buffer.c
@@ -1384,10 +1384,23 @@ static void invalidate_bh_lru(void *arg)
 	}
 	put_cpu_var(bh_lrus);
 }
+
+static bool has_bh_in_lru(int cpu, void *dummy)
+{
+	struct bh_lru *b = per_cpu_ptr(&bh_lrus, cpu);
+	int i;
 	
+	for (i = 0; i < BH_LRU_SIZE; i++) {
+		if (b->bhs[i])
+			return 1;
+	}
+
+	return 0;
+}
+
 void invalidate_bh_lrus(void)
 {
-	on_each_cpu(invalidate_bh_lru, NULL, 1);
+	on_each_cpu_cond(has_bh_in_lru, invalidate_bh_lru, NULL, 1, GFP_KERNEL);
 }
 EXPORT_SYMBOL_GPL(invalidate_bh_lrus);
 
_

Patches currently in -mm which might be from gilad@benyossef.com are

origin.patch

