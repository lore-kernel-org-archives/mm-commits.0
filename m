From: akpm@linux-foundation.org
Subject: - wavefront-only-declare-isapnp-on-config_pnp.patch removed from -mm tree
Date: Sun, 06 May 2007 23:47:24 -0700
Message-ID: <200705070647.l476lOtb020390@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbXEGGrp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 02:47:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ambx1@neo.rr.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     wavefront: only declare isapnp on CONFIG_PNP
has been removed from the -mm tree.  Its filename was
     wavefront-only-declare-isapnp-on-config_pnp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: wavefront: only declare isapnp on CONFIG_PNP
From: David Rientjes <rientjes@google.com>

isapnp[] is only used for CONFIG_PNP.  If this configuration option is
not set, do not declare the array.

Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/isa/wavefront/wavefront.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN sound/isa/wavefront/wavefront.c~wavefront-only-declare-isapnp-on-config_pnp sound/isa/wavefront/wavefront.c
--- a/sound/isa/wavefront/wavefront.c~wavefront-only-declare-isapnp-on-config_pnp
+++ a/sound/isa/wavefront/wavefront.c
@@ -40,7 +40,9 @@ MODULE_SUPPORTED_DEVICE("{{Turtle Beach,
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	    /* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	    /* ID for this card */
 static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE;	    /* Enable this card */
+#ifdef CONFIG_PNP
 static int isapnp[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1};
+#endif
 static long cs4232_pcm_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;	/* PnP setup */
 static int cs4232_pcm_irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ; /* 5,7,9,11,12,15 */
 static long cs4232_mpu_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT; /* PnP setup */
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
oom-fix-constraint-deadlock.patch
git-alsa.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
compiler-introduce-__used-and-__maybe_unused.patch
i386-pci-type-may-be-unused.patch
sh-dma-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
frv-gdb-use-__maybe_unused.patch
i386-voyager-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
powerpc-ps3-use-__maybe_unused.patch
i386-mmzone-use-__maybe_unused.patch
