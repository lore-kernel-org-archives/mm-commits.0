Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB832EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011364; cv=none; b=XQ3iEz6ByRXZ0xYWWm8q7pDiIU9jecX34PEHJlpJf4yoaTA1bxI/eO1A7i1ZTO9hHPZxrcWHOdHIdIXolFWjvE68S9teDtCZ8yAGym3I8/POArFCU67YP2q3LccSonBXMuceyAbQPc49pNfYtWRomS0kiJlHBZvevciVhkhJsI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011364; c=relaxed/simple;
	bh=QxQPF24Ho8xScOt9PR51gRz3KVnWJkMmFt9tILB0YwU=;
	h=Date:To:From:Subject:Message-Id; b=qW02oJ/BiqPYXFm7wRIjYwMzFG4wF/UJifpWmx4S4xQsRo7p+dnkKFmdivqxSdI957vzb4ZyU5tFGrbhynuC69fEsmCFUPoQF1l+uqWWyPfuztkX1dzuNuTPYFQU3ZJlaz8YCvyHbKrXDB/O67tHNCQaI/Why8H8ydQwWpwEq1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LLlwCZFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LLlwCZFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3208C4CEE4;
	Mon, 12 May 2025 00:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011364;
	bh=QxQPF24Ho8xScOt9PR51gRz3KVnWJkMmFt9tILB0YwU=;
	h=Date:To:From:Subject:From;
	b=LLlwCZFD4m1/In0I9TP9uYvKVLkVuaonm1mJMJUhkaVCILUeSsn5PTbCoXAMy/ebP
	 uWH2ATm8Wo/zUb8y2im3ECl4e3RyZSXBLyWiYEr98FOP8cQ0zYfjA+7j5Frd/5tG31
	 FKZnDL7FgtgkVmbBfQpZIBXBRYaUBaach55oJ+EI=
Date: Sun, 11 May 2025 17:56:03 -0700
To: mm-commits@vger.kernel.org,mporter@kernel.crashing.org,alex.bou9@gmail.com,linux@treblig.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rapidio-remove-some-dead-defines.patch removed from -mm tree
Message-Id: <20250512005603.F3208C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rapidio: remove some dead defines
has been removed from the -mm tree.  Its filename was
     rapidio-remove-some-dead-defines.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: rapidio: remove some dead defines
Date: Sat, 19 Apr 2025 21:30:11 +0100

Patch series "rapidio deadcoding".

A couple of rapidio deadcoding patches.  The first of these is a repost
and was originally posted almost a year ago
https://lore.kernel.org/all/20240528002515.211366-1-linux@treblig.org/ but
got no answer.  Other than being rebased and a typo fixed, it's not
changed.


This patch (of 2):

'mport_dma_buf', 'rio_mport_dma_map' and 'MPORT_MAX_DMA_BUFS' were added
in the original commit e8de370188d0 ("rapidio: add mport char device
driver") but never used.

'rio_cm_work' was unused since the original commit b6e8d4aa1110 ("rapidio:
add RapidIO channelized messaging driver") but never used.

Remove them.

Link: https://lkml.kernel.org/r/20250419203012.429787-1-linux@treblig.org
Link: https://lkml.kernel.org/r/20250419203012.429787-2-linux@treblig.org
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |   20 --------------------
 drivers/rapidio/rio_cm.c                 |    6 ------
 2 files changed, 26 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-remove-some-dead-defines
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -98,18 +98,6 @@ MODULE_PARM_DESC(dbg_level, "Debugging o
 #endif
 
 /*
- * An internal DMA coherent buffer
- */
-struct mport_dma_buf {
-	void		*ib_base;
-	dma_addr_t	ib_phys;
-	u32		ib_size;
-	u64		ib_rio_base;
-	bool		ib_map;
-	struct file	*filp;
-};
-
-/*
  * Internal memory mapping structure
  */
 enum rio_mport_map_dir {
@@ -131,14 +119,6 @@ struct rio_mport_mapping {
 	struct file *filp;
 };
 
-struct rio_mport_dma_map {
-	int valid;
-	u64 length;
-	void *vaddr;
-	dma_addr_t paddr;
-};
-
-#define MPORT_MAX_DMA_BUFS	16
 #define MPORT_EVENT_DEPTH	10
 
 /*
--- a/drivers/rapidio/rio_cm.c~rapidio-remove-some-dead-defines
+++ a/drivers/rapidio/rio_cm.c
@@ -198,12 +198,6 @@ struct cm_peer {
 	struct rio_dev *rdev;
 };
 
-struct rio_cm_work {
-	struct work_struct work;
-	struct cm_dev *cm;
-	void *data;
-};
-
 struct conn_req {
 	struct list_head node;
 	u32 destid;	/* requester destID */
_

Patches currently in -mm which might be from linux@treblig.org are


