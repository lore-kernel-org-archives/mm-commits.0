From: akpm@linux-foundation.org
Subject: + spufs-use-find_first_bit-instead-of-sched_find_first_bit.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:51:15 -0700
Message-ID: <200707201851.l6KIpFQb010901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35080 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764166AbXGTSva (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:51:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Masato.Noguchi@jp.sony.com, benh@kernel.crashing.org, jk@ozlabs.org, paulus@samba.org


The patch titled
     spufs: use find_first_bit() instead of sched_find_first_bit()
has been added to the -mm tree.  Its filename is
     spufs-use-find_first_bit-instead-of-sched_find_first_bit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spufs: use find_first_bit() instead of sched_find_first_bit()
From: Masato Noguchi <Masato.Noguchi@jp.sony.com>

spu_sched->bitmap has MAX_PRIO(=140) width in bits.However, since
ff80a77f20f811c0cc5b251d0f657cbc6f788385, sched_find_first_bit() only supports
100-bit bitmaps.

Thus, spu_sched->bitmap should be treated by generic find_first_bit().

Signed-off-by: Masato Noguchi <Masato.Noguchi@jp.sony.com>
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/sched.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/sched.c~spufs-use-find_first_bit-instead-of-sched_find_first_bit arch/powerpc/platforms/cell/spufs/sched.c
--- a/arch/powerpc/platforms/cell/spufs/sched.c~spufs-use-find_first_bit-instead-of-sched_find_first_bit
+++ a/arch/powerpc/platforms/cell/spufs/sched.c
@@ -533,7 +533,7 @@ static struct spu_context *grab_runnable
 	int best;
 
 	spin_lock(&spu_prio->runq_lock);
-	best = sched_find_first_bit(spu_prio->bitmap);
+	best = find_first_bit(spu_prio->bitmap, prio);
 	while (best < prio) {
 		struct list_head *rq = &spu_prio->runq[best];
 
@@ -769,7 +769,6 @@ int __init spu_sched_init(void)
 		INIT_LIST_HEAD(&spu_prio->runq[i]);
 		__clear_bit(i, spu_prio->bitmap);
 	}
-	__set_bit(MAX_PRIO, spu_prio->bitmap);
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		mutex_init(&spu_prio->active_mutex[i]);
 		INIT_LIST_HEAD(&spu_prio->active_list[i]);
_

Patches currently in -mm which might be from Masato.Noguchi@jp.sony.com are

origin.patch
spufs-fix-array-size-of-channel-index.patch
spufs-remove-needless-context-save-restore-code.patch
spufs-fix-decr_status-meanings.patch
spufs-fix-read-and-write-for-decr_status-file.patch
spufs-limit-saving-mfc_cntl-bits.patch
spufs-dont-halt-decrementer-at-restore-step-47.patch
spufs-change-decrementer-restore-timing.patch
spufs-use-find_first_bit-instead-of-sched_find_first_bit.patch
