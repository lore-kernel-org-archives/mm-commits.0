From: akpm@linux-foundation.org
Subject: - spufs-fix-read-and-write-for-decr_status-file.patch removed from -mm tree
Date: Sat, 21 Jul 2007 03:25:38 -0700
Message-ID: <200707211025.l6LAPcr7012010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47891 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933252AbXGUK0T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Jul 2007 06:26:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Masato.Noguchi@jp.sony.com, benh@kernel.crashing.org, jk@ozlabs.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     spufs: fix read and write for decr_status file
has been removed from the -mm tree.  Its filename was
     spufs-fix-read-and-write-for-decr_status-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spufs: fix read and write for decr_status file
From: Masato Noguchi <Masato.Noguchi@jp.sony.com>

The decr_status in the LSCSA is valid only in the sequence of context restore.
 Thus, it's nonsense to read and/or write it through spufs.

This patch changes decr_status node to access MFC_CNTL[Ds] in the CSA.

Signed-off-by: Masato Noguchi <Masato.Noguchi@jp.sony.com>
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/file.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/file.c~spufs-fix-read-and-write-for-decr_status-file arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~spufs-fix-read-and-write-for-decr_status-file
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -1651,17 +1651,21 @@ DEFINE_SIMPLE_ATTRIBUTE(spufs_decr_ops, 
 static void spufs_decr_status_set(void *data, u64 val)
 {
 	struct spu_context *ctx = data;
-	struct spu_lscsa *lscsa = ctx->csa.lscsa;
 	spu_acquire_saved(ctx);
-	lscsa->decr_status.slot[0] = (u32) val;
+	if (val)
+		ctx->csa.priv2.mfc_control_RW |= MFC_CNTL_DECREMENTER_RUNNING;
+	else
+		ctx->csa.priv2.mfc_control_RW &= ~MFC_CNTL_DECREMENTER_RUNNING;
 	spu_release_saved(ctx);
 }
 
 static u64 __spufs_decr_status_get(void *data)
 {
 	struct spu_context *ctx = data;
-	struct spu_lscsa *lscsa = ctx->csa.lscsa;
-	return lscsa->decr_status.slot[0];
+	if (ctx->csa.priv2.mfc_control_RW & MFC_CNTL_DECREMENTER_RUNNING)
+		return SPU_DECR_STATUS_RUNNING;
+	else
+		return 0;
 }
 
 static u64 spufs_decr_status_get(void *data)
_

Patches currently in -mm which might be from Masato.Noguchi@jp.sony.com are

origin.patch
