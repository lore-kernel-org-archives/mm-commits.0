From: akpm@linux-foundation.org
Subject: + fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch added to -mm tree
Date: Fri, 27 Jan 2012 16:15:49 -0800
Message-ID: <20120128001549.DD5ECA043A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:37894 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab2A1APu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 19:15:50 -0500
Received: by ggnk1 with SMTP id k1so229726ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 16:15:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gilad@benyossef.com, a.p.zijlstra@chello.nl, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs: only send IPI to invalidate LRU BH when needed
has been added to the -mm tree.  Its filename is
     fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: fs: only send IPI to invalidate LRU BH when needed

Patches currently in -mm which might be from gilad@benyossef.com are

smp-introduce-a-generic-on_each_cpu_mask-function.patch
arm-move-arm-over-to-generic-on_each_cpu_mask.patch
tile-move-tile-to-use-generic-on_each_cpu_mask.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch

