From: akpm@linux-foundation.org
Subject: + percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch added to -mm tree
Date: Mon, 19 Nov 2007 16:27:07 -0800
Message-ID: <200711200027.lAK0R7ke004354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998AbXKTA2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 19:28:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, clameter@sgi.com, davem@davemloft.net


The patch titled
     PERCPU : __percpu_alloc_mask() can dynamically size percpu_data storage
has been added to the -mm tree.  Its filename is
     percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -34,7 +34,7 @@
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

git-net.patch
nr_open-should-be-raised-a-litle-bit.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
