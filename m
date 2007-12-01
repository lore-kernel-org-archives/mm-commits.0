From: akpm@linux-foundation.org
Subject: - ps3fb-video-memory-size-cleanups.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:20:45 -0800
Message-ID: <200712010020.lB10KjCQ031716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755864AbXLAAUv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:20:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, mm-commits@vger.kernel.org


The patch titled
     ps3fb: video memory size cleanups
has been removed from the -mm tree.  Its filename was
     ps3fb-video-memory-size-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3fb: video memory size cleanups
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

- Limit video memory size to avoid crossing a 256 MiB boundary in IOIF space.
- Pass the actual amount of video memory used to lv1_gpu_memory_allocate().

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-video-memory-size-cleanups drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-video-memory-size-cleanups
+++ a/drivers/video/ps3fb.c
@@ -51,7 +51,6 @@
 #define L1GPU_DISPLAY_SYNC_HSYNC		1
 #define L1GPU_DISPLAY_SYNC_VSYNC		2
 
-#define DDR_SIZE				(0)	/* used no ddr */
 #define GPU_CMD_BUF_SIZE			(64 * 1024)
 #define GPU_IOIF				(0x0d000000UL)
 #define GPU_ALIGN_UP(x)				_ALIGN_UP((x), 64)
@@ -1060,6 +1059,7 @@ static int __devinit ps3fb_probe(struct 
 	u64 xdr_lpar;
 	int status, res_index;
 	struct task_struct *task;
+	unsigned long max_ps3fb_size;
 
 	status = ps3_open_hv_device(dev);
 	if (status) {
@@ -1085,8 +1085,15 @@ static int __devinit ps3fb_probe(struct 
 
 	ps3fb_set_sync(&dev->core);
 
+	max_ps3fb_size = _ALIGN_UP(GPU_IOIF, 256*1024*1024) - GPU_IOIF;
+	if (ps3fb_videomemory.size > max_ps3fb_size) {
+		dev_info(&dev->core, "Limiting ps3fb mem size to %lu bytes\n",
+			 max_ps3fb_size);
+		ps3fb_videomemory.size = max_ps3fb_size;
+	}
+
 	/* get gpu context handle */
-	status = lv1_gpu_memory_allocate(DDR_SIZE, 0, 0, 0, 0,
+	status = lv1_gpu_memory_allocate(ps3fb_videomemory.size, 0, 0, 0, 0,
 					 &ps3fb.memory_handle, &ddr_lpar);
 	if (status) {
 		dev_err(&dev->core, "%s: lv1_gpu_memory_allocate failed: %d\n",
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
time-fold-__get_realtime_clock_ts-into-getnstimeofday.patch
ps3-checkpatch-drivers-ps3-ps3-sys-managerc.patch
ps3-checkpatch-drivers-ps3-ps3-vuartc.patch
