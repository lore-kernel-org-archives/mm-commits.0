From: akpm@linux-foundation.org
Subject: - radeonfb-fix-copyarea-for-r300-and-later.patch removed from -mm tree
Date: Wed, 06 Aug 2008 20:31:36 -0700
Message-ID: <200808070331.m773VaUn029574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751395AbYHGDbu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 23:31:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, benh@kernel.crashing.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     radeonfb: fix copyarea for R300 and later
has been removed from the -mm tree.  Its filename was
     radeonfb-fix-copyarea-for-r300-and-later.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb: fix copyarea for R300 and later
From: David Miller <davem@davemloft.net>

Fixes a boot-time hang on sparc64.

For current chips we need to make sure the DSTCACHE_CTLSTAT and WAIT_UNTIL
registers are properly setup.  If not, a sequence of copyarea operations
can result in the 2D raster processor hanging.  Here is a trace on an
RV370 (PCI device ID 0x5b64), it records the RBBM_STATUS register, then
the source x/y, destination x/y, and width/height used for the copy:

----------------------------------------
radeonfb_prim_copyarea: STATUS[00000140] src[210:70] dst[210:60] wh[a0:10]
radeonfb_prim_copyarea: STATUS[00000140] src[2b8:70] dst[2b8:60] wh[88:10]
radeonfb_prim_copyarea: STATUS[00000140] src[348:70] dst[348:60] wh[40:10]
radeonfb_prim_copyarea: STATUS[80020140] src[390:70] dst[390:60] wh[88:10]
radeonfb_prim_copyarea: STATUS[8002613f] src[40:80] dst[40:70] wh[28:10]
radeonfb_prim_copyarea: STATUS[80026139] src[a8:80] dst[a8:70] wh[38:10]
radeonfb_prim_copyarea: STATUS[80026133] src[e8:80] dst[e8:70] wh[80:10]
radeonfb_prim_copyarea: STATUS[8002612d] src[170:80] dst[170:70] wh[30:10]
radeonfb_prim_copyarea: STATUS[80026127] src[1a8:80] dst[1a8:70] wh[8:10]
radeonfb_prim_copyarea: STATUS[80026121] src[1b8:80] dst[1b8:70] wh[88:10]
radeonfb_prim_copyarea: STATUS[8002611b] src[248:80] dst[248:70] wh[68:10]
----------------------------------------

When things are going fine the copies complete before the next ROP is even
issued, but all of a sudden the 2D unit becomes active (bit 17 in
RBBM_STATUS) and the FIFO retry (bit 13) and FIFO pipeline busy (bit 14)
are set as well.  The FIFO begins to backup until it becomes full.

What happens next is the radeon_fifo_wait() times out, and we access the
chip illegally leading to a bus error which usually wedges the box.  None
of this makes it to the console screen, of course :-) radeon_fifo_wait()
should be modified to reset the accelerator when this timeout happens
instead of programming the chip anyways.

----------------------------------------
radeonfb: FIFO Timeout !
ERROR(0): Cheetah error trap taken afsr[0010080005000000] afar[000007f900800e40] TL1(0)
ERROR(0): TPC[595114] TNPC[595118] O7[459788] TSTATE[11009601]
ERROR(0): TPC<radeonfb_copyarea+0xfc/0x248>
ERROR(0): M_SYND(0),  E_SYND(0), Privileged
ERROR(0): Highest priority error (0000080000000000) "Bus error response from system bus"
ERROR(0): D-cache idx[0] tag[0000000000000000] utag[0000000000000000] stag[0000000000000000]
ERROR(0): D-cache data0[0000000000000000] data1[0000000000000000] data2[0000000000000000] data3[0000000000000000]
ERROR(0): I-cache idx[0] tag[0000000000000000] utag[0000000000000000] stag[0000000000000000] u[0000000000000000] l[00\

ERROR(0): I-cache INSN0[0000000000000000] INSN1[0000000000000000] INSN2[0000000000000000] INSN3[0000000000000000]
ERROR(0): I-cache INSN4[0000000000000000] INSN5[0000000000000000] INSN6[0000000000000000] INSN7[0000000000000000]
ERROR(0): E-cache idx[800e40] tag[000000000e049f4c]
ERROR(0): E-cache data0[fffff8127d300180] data1[00000000004b5384] data2[0000000000000000] data3[0000000000000000]
Kernel panic - not syncing: Irrecoverable deferred error trap.
----------------------------------------

Another quirk is that these copyarea calls will not happen until the first
drivers/char/vt.c:redraw_screen() occurs.  This will only happen if you 1)
VC switch or 2) run "consolechars" or 3) unblank the screen.

This seems to happen because until a redraw_screen() the screen scrolling
method used by fbcon is not finalized yet.  I've seen this with other fb
drivers too.

So if all you do is boot straight into X you will never see this bug on
the relevant chips.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_accel.c |    4 ++++
 include/video/radeon.h           |    4 ++++
 2 files changed, 8 insertions(+)

diff -puN drivers/video/aty/radeon_accel.c~radeonfb-fix-copyarea-for-r300-and-later drivers/video/aty/radeon_accel.c
--- a/drivers/video/aty/radeon_accel.c~radeonfb-fix-copyarea-for-r300-and-later
+++ a/drivers/video/aty/radeon_accel.c
@@ -116,6 +116,10 @@ static void radeonfb_prim_copyarea(struc
 	OUTREG(DP_CNTL, (xdir>=0 ? DST_X_LEFT_TO_RIGHT : 0)
 			| (ydir>=0 ? DST_Y_TOP_TO_BOTTOM : 0));
 
+	radeon_fifo_wait(2);
+	OUTREG(DSTCACHE_CTLSTAT, RB2D_DC_FLUSH_ALL);
+	OUTREG(WAIT_UNTIL, (WAIT_2D_IDLECLEAN | WAIT_DMA_GUI_IDLE));
+
 	radeon_fifo_wait(3);
 	OUTREG(SRC_Y_X, (sy << 16) | sx);
 	OUTREG(DST_Y_X, (dy << 16) | dx);
diff -puN include/video/radeon.h~radeonfb-fix-copyarea-for-r300-and-later include/video/radeon.h
--- a/include/video/radeon.h~radeonfb-fix-copyarea-for-r300-and-later
+++ a/include/video/radeon.h
@@ -742,6 +742,10 @@
 #define SOFT_RESET_RB           		   (1 <<  6)
 #define SOFT_RESET_HDP          		   (1 <<  7)
 
+/* WAIT_UNTIL bit constants */
+#define WAIT_DMA_GUI_IDLE			   (1 << 9)
+#define WAIT_2D_IDLECLEAN			   (1 << 16)
+
 /* SURFACE_CNTL bit consants */
 #define SURF_TRANSLATION_DIS			   (1 << 8)
 #define NONSURF_AP0_SWP_16BPP			   (1 << 20)
_

Patches currently in -mm which might be from davem@davemloft.net are

radeonfb-fix-engine-hangs-and-cache-flushing.patch
radeonfb-fix-copyarea-for-r300-and-later.patch
linux-next.patch
configure-out-igmp-support.patch
sunrpc-do-not-pin-sunrpc-module-in-the-memory.patch
lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal.patch
lockdep-fix-combinatorial-explosion-in-lock-subgraph-traversal-fix.patch
lockdep-lock_set_subclass-reset-a-held-locks-subclass.patch
lockdep-re-annotate-scheduler-runqueues.patch
git-sparc64.patch
docsrc-fix-ifenslave-type.patch
ali-m7101-pmu-also-available-on-sun-netras-too.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
sparc64-use-iommu_num_pages-function-in-iommu-code.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

