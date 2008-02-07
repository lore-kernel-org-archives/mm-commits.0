From: akpm@linux-foundation.org
Subject: - percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:42 -0800
Message-ID: <200802070022.m170MNEU006416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935130AbYBGApw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, clameter@sgi.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     PERCPU : __percpu_alloc_mask() can dynamically size percpu_data storage
has been removed from the -mm tree.  Its filename was
     percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PERCPU : __percpu_alloc_mask() can dynamically size percpu_data storage
From: Eric Dumazet <dada1@cosmosbay.com>

Instead of allocating a fix sized array of NR_CPUS pointers for percpu_data,
we can use nr_cpu_ids, which is generally < NR_CPUS.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |    2 +-
 mm/allocpercpu.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/percpu.h~percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data include/linux/percpu.h
--- a/include/linux/percpu.h~percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data
+++ a/include/linux/percpu.h
@@ -54,7 +54,7 @@
 #ifdef CONFIG_SMP
 
 struct percpu_data {
-	void *ptrs[NR_CPUS];
+	void *ptrs[1];
 };
 
 #define __percpu_disguise(pdata) (struct percpu_data *)~(unsigned long)(pdata)
diff -puN mm/allocpercpu.c~percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data mm/allocpercpu.c
--- a/mm/allocpercpu.c~percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data
+++ a/mm/allocpercpu.c
@@ -98,7 +98,7 @@ EXPORT_SYMBOL_GPL(__percpu_populate_mask
  */
 void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask)
 {
-	void *pdata = kzalloc(sizeof(struct percpu_data), gfp);
+	void *pdata = kzalloc(nr_cpu_ids * sizeof(void *), gfp);
 	void *__pdata = __percpu_disguise(pdata);
 
 	if (unlikely(!pdata))
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
