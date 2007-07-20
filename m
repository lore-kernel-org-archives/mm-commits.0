From: akpm@linux-foundation.org
Subject: + spufs-fix-array-size-of-channel-index.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:50:59 -0700
Message-ID: <200707201850.l6KIox9k010868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39075 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761968AbXGTSvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:51:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jk@ozlabs.org, Masato.Noguchi@jp.sony.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     spufs: fix array size of channel index
has been added to the -mm tree.  Its filename is
     spufs-fix-array-size-of-channel-index.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spufs: fix array size of channel index
From: Jeremy Kerr <jk@ozlabs.org>

Based on a fix from Masato Noguchi <Masato.Noguchi@jp.sony.com>.

Remove the (incorrect) array size declarations in the spufs channel arrays,
and use ARRAY_SIZE rather than hardcoded values.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Masato Noguchi <Masato.Noguchi@jp.sony.com>.
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/switch.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/switch.c~spufs-fix-array-size-of-channel-index arch/powerpc/platforms/cell/spufs/switch.c
--- a/arch/powerpc/platforms/cell/spufs/switch.c~spufs-fix-array-size-of-channel-index
+++ a/arch/powerpc/platforms/cell/spufs/switch.c
@@ -616,7 +616,7 @@ static inline void save_ppuint_mb(struct
 static inline void save_ch_part1(struct spu_state *csa, struct spu *spu)
 {
 	struct spu_priv2 __iomem *priv2 = spu->priv2;
-	u64 idx, ch_indices[7] = { 0UL, 3UL, 4UL, 24UL, 25UL, 27UL };
+	u64 idx, ch_indices[] = { 0UL, 3UL, 4UL, 24UL, 25UL, 27UL };
 	int i;
 
 	/* Save, Step 42:
@@ -627,7 +627,7 @@ static inline void save_ch_part1(struct 
 	csa->spu_chnldata_RW[1] = in_be64(&priv2->spu_chnldata_RW);
 
 	/* Save the following CH: [0,3,4,24,25,27] */
-	for (i = 0; i < 7; i++) {
+	for (i = 0; i < ARRAY_SIZE(ch_indices); i++) {
 		idx = ch_indices[i];
 		out_be64(&priv2->spu_chnlcntptr_RW, idx);
 		eieio();
@@ -1091,7 +1091,7 @@ static inline void clear_spu_status(stru
 static inline void reset_ch_part1(struct spu_state *csa, struct spu *spu)
 {
 	struct spu_priv2 __iomem *priv2 = spu->priv2;
-	u64 ch_indices[7] = { 0UL, 3UL, 4UL, 24UL, 25UL, 27UL };
+	u64 ch_indices[] = { 0UL, 3UL, 4UL, 24UL, 25UL, 27UL };
 	u64 idx;
 	int i;
 
@@ -1103,7 +1103,7 @@ static inline void reset_ch_part1(struct
 	out_be64(&priv2->spu_chnldata_RW, 0UL);
 
 	/* Reset the following CH: [0,3,4,24,25,27] */
-	for (i = 0; i < 7; i++) {
+	for (i = 0; i < ARRAY_SIZE(ch_indices); i++) {
 		idx = ch_indices[i];
 		out_be64(&priv2->spu_chnlcntptr_RW, idx);
 		eieio();
@@ -1563,7 +1563,7 @@ static inline void restore_decr_wrapped(
 static inline void restore_ch_part1(struct spu_state *csa, struct spu *spu)
 {
 	struct spu_priv2 __iomem *priv2 = spu->priv2;
-	u64 idx, ch_indices[7] = { 0UL, 3UL, 4UL, 24UL, 25UL, 27UL };
+	u64 idx, ch_indices[] = { 0UL, 3UL, 4UL, 24UL, 25UL, 27UL };
 	int i;
 
 	/* Restore, Step 59:
@@ -1574,7 +1574,7 @@ static inline void restore_ch_part1(stru
 	out_be64(&priv2->spu_chnldata_RW, csa->spu_chnldata_RW[1]);
 
 	/* Restore the following CH: [0,3,4,24,25,27] */
-	for (i = 0; i < 7; i++) {
+	for (i = 0; i < ARRAY_SIZE(ch_indices); i++) {
 		idx = ch_indices[i];
 		out_be64(&priv2->spu_chnlcntptr_RW, idx);
 		eieio();
_

Patches currently in -mm which might be from jk@ozlabs.org are

origin.patch
spufs-avoid-unexpectedly-restaring-mfc-during-context-save.patch
spufs-make-signal-notification-files-readonly-for-nosched-contexts.patch
spufs-remove-spurious-warn_on-for-spu_deactivate-for-nosched-contexts.patch
spufs-add-spu-stats-in-sysfs-and-ctx-stat-file-in-spufs.patch
spufs-make-sure-context-are-scheduled-again-after-spu_acquire_saved.patch
spufs-fix-array-size-of-channel-index.patch
spufs-remove-needless-context-save-restore-code.patch
spufs-fix-decr_status-meanings.patch
spufs-fix-read-and-write-for-decr_status-file.patch
spufs-limit-saving-mfc_cntl-bits.patch
spufs-dont-halt-decrementer-at-restore-step-47.patch
spufs-change-decrementer-restore-timing.patch
spufs-remove-unused-file-argument-from-spufs_run_spu.patch
spufs-use-find_first_bit-instead-of-sched_find_first_bit.patch
