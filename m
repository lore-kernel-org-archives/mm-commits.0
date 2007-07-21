From: akpm@linux-foundation.org
Subject: - spufs-avoid-unexpectedly-restaring-mfc-during-context-save.patch removed from -mm tree
Date: Sat, 21 Jul 2007 03:25:20 -0700
Message-ID: <200707211025.l6LAPK54011986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48243 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933798AbXGUK0D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Jul 2007 06:26:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: asayama@sm.sony.co.jp, benh@kernel.crashing.org, jk@ozlabs.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     spufs: avoid unexpectedly restaring MFC during context save
has been removed from the -mm tree.  Its filename was
     spufs-avoid-unexpectedly-restaring-mfc-during-context-save.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spufs: avoid unexpectedly restaring MFC during context save
From: Kazunori Asayama <asayama@sm.sony.co.jp>

The current SPU context saving procedure in SPUFS unexpectedly restarts MFC
when halting decrementer, because MFC_CNTL[Dh] is set without MFC_CNTL[Sm]. 
This bug causes, for example, saving broken DMA queues.  Here is a patch to
fix the problem.

Signed-off-by: Kazunori Asayama <asayama@sm.sony.co.jp>
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/switch.c |    3 ++-
 include/asm-powerpc/spu.h                  |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/platforms/cell/spufs/switch.c~spufs-avoid-unexpectedly-restaring-mfc-during-context-save arch/powerpc/platforms/cell/spufs/switch.c
--- a/arch/powerpc/platforms/cell/spufs/switch.c~spufs-avoid-unexpectedly-restaring-mfc-during-context-save
+++ a/arch/powerpc/platforms/cell/spufs/switch.c
@@ -271,7 +271,8 @@ static inline void halt_mfc_decr(struct 
 	 *     Write MFC_CNTL[Dh] set to a '1' to halt
 	 *     the decrementer.
 	 */
-	out_be64(&priv2->mfc_control_RW, MFC_CNTL_DECREMENTER_HALTED);
+	out_be64(&priv2->mfc_control_RW,
+		 MFC_CNTL_DECREMENTER_HALTED | MFC_CNTL_SUSPEND_MASK);
 	eieio();
 }
 
diff -puN include/asm-powerpc/spu.h~spufs-avoid-unexpectedly-restaring-mfc-during-context-save include/asm-powerpc/spu.h
--- a/include/asm-powerpc/spu.h~spufs-avoid-unexpectedly-restaring-mfc-during-context-save
+++ a/include/asm-powerpc/spu.h
@@ -418,6 +418,7 @@ struct spu_priv2 {
 #define MFC_CNTL_RESUME_DMA_QUEUE		(0ull << 0)
 #define MFC_CNTL_SUSPEND_DMA_QUEUE		(1ull << 0)
 #define MFC_CNTL_SUSPEND_DMA_QUEUE_MASK		(1ull << 0)
+#define MFC_CNTL_SUSPEND_MASK			(1ull << 4)
 #define MFC_CNTL_NORMAL_DMA_QUEUE_OPERATION	(0ull << 8)
 #define MFC_CNTL_SUSPEND_IN_PROGRESS		(1ull << 8)
 #define MFC_CNTL_SUSPEND_COMPLETE		(3ull << 8)
_

Patches currently in -mm which might be from asayama@sm.sony.co.jp are

origin.patch
