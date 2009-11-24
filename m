From: akpm@linux-foundation.org
Subject: + proc_fops-convert-cpia.patch added to -mm tree
Date: Tue, 24 Nov 2009 12:50:55 -0800
Message-ID: <200911242050.nAOKothg016297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932855AbZKXUu5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 15:50:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, mchehab@infradead.org


The patch titled
     proc_fops: convert cpia
has been added to the -mm tree.  Its filename is
     proc_fops-convert-cpia.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc_fops: convert cpia
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cpia.c |  211 +++++++++++++++++------------------
 1 file changed, 104 insertions(+), 107 deletions(-)

diff -puN drivers/media/video/cpia.c~proc_fops-convert-cpia drivers/media/video/cpia.c
--- a/drivers/media/video/cpia.c~proc_fops-convert-cpia
+++ a/drivers/media/video/cpia.c
@@ -32,6 +32,7 @@
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
 #include <linux/ctype.h>
@@ -244,72 +245,67 @@ static void rvfree(void *mem, unsigned l
 #ifdef CONFIG_PROC_FS
 static struct proc_dir_entry *cpia_proc_root=NULL;
 
-static int cpia_read_proc(char *page, char **start, off_t off,
-			  int count, int *eof, void *data)
+static int cpia_proc_show(struct seq_file *m, void *v)
 {
-	char *out = page;
-	int len, tmp;
-	struct cam_data *cam = data;
+	struct cam_data *cam = m->private;
+	int tmp;
 	char tmpstr[29];
 
-	/* IMPORTANT: This output MUST be kept under PAGE_SIZE
-	 *            or we need to get more sophisticated. */
-
-	out += sprintf(out, "read-only\n-----------------------\n");
-	out += sprintf(out, "V4L Driver version:       %d.%d.%d\n",
+	seq_printf(m, "read-only\n-----------------------\n");
+	seq_printf(m, "V4L Driver version:       %d.%d.%d\n",
 		       CPIA_MAJ_VER, CPIA_MIN_VER, CPIA_PATCH_VER);
-	out += sprintf(out, "CPIA Version:             %d.%02d (%d.%d)\n",
+	seq_printf(m, "CPIA Version:             %d.%02d (%d.%d)\n",
 		       cam->params.version.firmwareVersion,
 		       cam->params.version.firmwareRevision,
 		       cam->params.version.vcVersion,
 		       cam->params.version.vcRevision);
-	out += sprintf(out, "CPIA PnP-ID:              %04x:%04x:%04x\n",
+	seq_printf(m, "CPIA PnP-ID:              %04x:%04x:%04x\n",
 		       cam->params.pnpID.vendor, cam->params.pnpID.product,
 		       cam->params.pnpID.deviceRevision);
-	out += sprintf(out, "VP-Version:               %d.%d %04x\n",
+	seq_printf(m, "VP-Version:               %d.%d %04x\n",
 		       cam->params.vpVersion.vpVersion,
 		       cam->params.vpVersion.vpRevision,
 		       cam->params.vpVersion.cameraHeadID);
 
-	out += sprintf(out, "system_state:             %#04x\n",
+	seq_printf(m, "system_state:             %#04x\n",
 		       cam->params.status.systemState);
-	out += sprintf(out, "grab_state:               %#04x\n",
+	seq_printf(m, "grab_state:               %#04x\n",
 		       cam->params.status.grabState);
-	out += sprintf(out, "stream_state:             %#04x\n",
+	seq_printf(m, "stream_state:             %#04x\n",
 		       cam->params.status.streamState);
-	out += sprintf(out, "fatal_error:              %#04x\n",
+	seq_printf(m, "fatal_error:              %#04x\n",
 		       cam->params.status.fatalError);
-	out += sprintf(out, "cmd_error:                %#04x\n",
+	seq_printf(m, "cmd_error:                %#04x\n",
 		       cam->params.status.cmdError);
-	out += sprintf(out, "debug_flags:              %#04x\n",
+	seq_printf(m, "debug_flags:              %#04x\n",
 		       cam->params.status.debugFlags);
-	out += sprintf(out, "vp_status:                %#04x\n",
+	seq_printf(m, "vp_status:                %#04x\n",
 		       cam->params.status.vpStatus);
-	out += sprintf(out, "error_code:               %#04x\n",
+	seq_printf(m, "error_code:               %#04x\n",
 		       cam->params.status.errorCode);
 	/* QX3 specific entries */
 	if (cam->params.qx3.qx3_detected) {
-		out += sprintf(out, "button:                   %4d\n",
+		seq_printf(m, "button:                   %4d\n",
 			       cam->params.qx3.button);
-		out += sprintf(out, "cradled:                  %4d\n",
+		seq_printf(m, "cradled:                  %4d\n",
 			       cam->params.qx3.cradled);
 	}
-	out += sprintf(out, "video_size:               %s\n",
+	seq_printf(m, "video_size:               %s\n",
 		       cam->params.format.videoSize == VIDEOSIZE_CIF ?
 		       "CIF " : "QCIF");
-	out += sprintf(out, "roi:                      (%3d, %3d) to (%3d, %3d)\n",
+	seq_printf(m, "roi:                      (%3d, %3d) to (%3d, %3d)\n",
 		       cam->params.roi.colStart*8,
 		       cam->params.roi.rowStart*4,
 		       cam->params.roi.colEnd*8,
 		       cam->params.roi.rowEnd*4);
-	out += sprintf(out, "actual_fps:               %3d\n", cam->fps);
-	out += sprintf(out, "transfer_rate:            %4dkB/s\n",
+	seq_printf(m, "actual_fps:               %3d\n", cam->fps);
+	seq_printf(m, "transfer_rate:            %4dkB/s\n",
 		       cam->transfer_rate);
 
-	out += sprintf(out, "\nread-write\n");
-	out += sprintf(out, "-----------------------  current       min"
+	seq_printf(m, "\nread-write\n");
+	seq_printf(m, "-----------------------  current       min"
 		       "       max   default  comment\n");
-	out += sprintf(out, "brightness:             %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "brightness:             %8d  %8d  %8d  %8d\n",
 		       cam->params.colourParams.brightness, 0, 100, 50);
 	if (cam->params.version.firmwareVersion == 1 &&
 	   cam->params.version.firmwareRevision == 2)
@@ -318,26 +314,26 @@ static int cpia_read_proc(char *page, ch
 	else
 		tmp = 96;
 
-	out += sprintf(out, "contrast:               %8d  %8d  %8d  %8d"
+	seq_printf(m, "contrast:               %8d  %8d  %8d  %8d"
 		       "  steps of 8\n",
 		       cam->params.colourParams.contrast, 0, tmp, 48);
-	out += sprintf(out, "saturation:             %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "saturation:             %8d  %8d  %8d  %8d\n",
 		       cam->params.colourParams.saturation, 0, 100, 50);
 	tmp = (25000+5000*cam->params.sensorFps.baserate)/
 	      (1<<cam->params.sensorFps.divisor);
-	out += sprintf(out, "sensor_fps:             %4d.%03d  %8d  %8d  %8d\n",
+	seq_printf(m, "sensor_fps:             %4d.%03d  %8d  %8d  %8d\n",
 		       tmp/1000, tmp%1000, 3, 30, 15);
-	out += sprintf(out, "stream_start_line:      %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "stream_start_line:      %8d  %8d  %8d  %8d\n",
 		       2*cam->params.streamStartLine, 0,
 		       cam->params.format.videoSize == VIDEOSIZE_CIF ? 288:144,
 		       cam->params.format.videoSize == VIDEOSIZE_CIF ? 240:120);
-	out += sprintf(out, "sub_sample:             %8s  %8s  %8s  %8s\n",
+	seq_printf(m, "sub_sample:             %8s  %8s  %8s  %8s\n",
 		       cam->params.format.subSample == SUBSAMPLE_420 ?
 		       "420" : "422", "420", "422", "422");
-	out += sprintf(out, "yuv_order:              %8s  %8s  %8s  %8s\n",
+	seq_printf(m, "yuv_order:              %8s  %8s  %8s  %8s\n",
 		       cam->params.format.yuvOrder == YUVORDER_YUYV ?
 		       "YUYV" : "UYVY", "YUYV" , "UYVY", "YUYV");
-	out += sprintf(out, "ecp_timing:             %8s  %8s  %8s  %8s\n",
+	seq_printf(m, "ecp_timing:             %8s  %8s  %8s  %8s\n",
 		       cam->params.ecpTiming ? "slow" : "normal", "slow",
 		       "normal", "normal");
 
@@ -346,13 +342,13 @@ static int cpia_read_proc(char *page, ch
 	} else {
 		sprintf(tmpstr, "manual");
 	}
-	out += sprintf(out, "color_balance_mode:     %8s  %8s  %8s"
+	seq_printf(m, "color_balance_mode:     %8s  %8s  %8s"
 		       "  %8s\n",  tmpstr, "manual", "auto", "auto");
-	out += sprintf(out, "red_gain:               %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "red_gain:               %8d  %8d  %8d  %8d\n",
 		       cam->params.colourBalance.redGain, 0, 212, 32);
-	out += sprintf(out, "green_gain:             %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "green_gain:             %8d  %8d  %8d  %8d\n",
 		       cam->params.colourBalance.greenGain, 0, 212, 6);
-	out += sprintf(out, "blue_gain:              %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "blue_gain:              %8d  %8d  %8d  %8d\n",
 		       cam->params.colourBalance.blueGain, 0, 212, 92);
 
 	if (cam->params.version.firmwareVersion == 1 &&
@@ -363,10 +359,10 @@ static int cpia_read_proc(char *page, ch
 		sprintf(tmpstr, "%8d  %8d  %8d", 1, 8, 2);
 
 	if (cam->params.exposure.gainMode == 0)
-		out += sprintf(out, "max_gain:                unknown  %28s"
+		seq_printf(m, "max_gain:                unknown  %28s"
 			       "  powers of 2\n", tmpstr);
 	else
-		out += sprintf(out, "max_gain:               %8d  %28s"
+		seq_printf(m, "max_gain:               %8d  %28s"
 			       "  1,2,4 or 8 \n",
 			       1<<(cam->params.exposure.gainMode-1), tmpstr);
 
@@ -382,12 +378,12 @@ static int cpia_read_proc(char *page, ch
 		sprintf(tmpstr, "unknown");
 		break;
 	}
-	out += sprintf(out, "exposure_mode:          %8s  %8s  %8s"
+	seq_printf(m, "exposure_mode:          %8s  %8s  %8s"
 		       "  %8s\n",  tmpstr, "manual", "auto", "auto");
-	out += sprintf(out, "centre_weight:          %8s  %8s  %8s  %8s\n",
+	seq_printf(m, "centre_weight:          %8s  %8s  %8s  %8s\n",
 		       (2-cam->params.exposure.centreWeight) ? "on" : "off",
 		       "off", "on", "on");
-	out += sprintf(out, "gain:                   %8d  %8d  max_gain  %8d  1,2,4,8 possible\n",
+	seq_printf(m, "gain:                   %8d  %8d  max_gain  %8d  1,2,4,8 possible\n",
 		       1<<cam->params.exposure.gain, 1, 1);
 	if (cam->params.version.firmwareVersion == 1 &&
 	   cam->params.version.firmwareRevision == 2)
@@ -396,7 +392,7 @@ static int cpia_read_proc(char *page, ch
 	else
 		tmp = 510;
 
-	out += sprintf(out, "fine_exp:               %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "fine_exp:               %8d  %8d  %8d  %8d\n",
 		       cam->params.exposure.fineExp*2, 0, tmp, 0);
 	if (cam->params.version.firmwareVersion == 1 &&
 	   cam->params.version.firmwareRevision == 2)
@@ -405,127 +401,122 @@ static int cpia_read_proc(char *page, ch
 	else
 		tmp = MAX_EXP;
 
-	out += sprintf(out, "coarse_exp:             %8d  %8d  %8d"
+	seq_printf(m, "coarse_exp:             %8d  %8d  %8d"
 		       "  %8d\n", cam->params.exposure.coarseExpLo+
 		       256*cam->params.exposure.coarseExpHi, 0, tmp, 185);
-	out += sprintf(out, "red_comp:               %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "red_comp:               %8d  %8d  %8d  %8d\n",
 		       cam->params.exposure.redComp, COMP_RED, 255, COMP_RED);
-	out += sprintf(out, "green1_comp:            %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "green1_comp:            %8d  %8d  %8d  %8d\n",
 		       cam->params.exposure.green1Comp, COMP_GREEN1, 255,
 		       COMP_GREEN1);
-	out += sprintf(out, "green2_comp:            %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "green2_comp:            %8d  %8d  %8d  %8d\n",
 		       cam->params.exposure.green2Comp, COMP_GREEN2, 255,
 		       COMP_GREEN2);
-	out += sprintf(out, "blue_comp:              %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "blue_comp:              %8d  %8d  %8d  %8d\n",
 		       cam->params.exposure.blueComp, COMP_BLUE, 255, COMP_BLUE);
 
-	out += sprintf(out, "apcor_gain1:            %#8x  %#8x  %#8x  %#8x\n",
+	seq_printf(m, "apcor_gain1:            %#8x  %#8x  %#8x  %#8x\n",
 		       cam->params.apcor.gain1, 0, 0xff, 0x1c);
-	out += sprintf(out, "apcor_gain2:            %#8x  %#8x  %#8x  %#8x\n",
+	seq_printf(m, "apcor_gain2:            %#8x  %#8x  %#8x  %#8x\n",
 		       cam->params.apcor.gain2, 0, 0xff, 0x1a);
-	out += sprintf(out, "apcor_gain4:            %#8x  %#8x  %#8x  %#8x\n",
+	seq_printf(m, "apcor_gain4:            %#8x  %#8x  %#8x  %#8x\n",
 		       cam->params.apcor.gain4, 0, 0xff, 0x2d);
-	out += sprintf(out, "apcor_gain8:            %#8x  %#8x  %#8x  %#8x\n",
+	seq_printf(m, "apcor_gain8:            %#8x  %#8x  %#8x  %#8x\n",
 		       cam->params.apcor.gain8, 0, 0xff, 0x2a);
-	out += sprintf(out, "vl_offset_gain1:        %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "vl_offset_gain1:        %8d  %8d  %8d  %8d\n",
 		       cam->params.vlOffset.gain1, 0, 255, 24);
-	out += sprintf(out, "vl_offset_gain2:        %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "vl_offset_gain2:        %8d  %8d  %8d  %8d\n",
 		       cam->params.vlOffset.gain2, 0, 255, 28);
-	out += sprintf(out, "vl_offset_gain4:        %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "vl_offset_gain4:        %8d  %8d  %8d  %8d\n",
 		       cam->params.vlOffset.gain4, 0, 255, 30);
-	out += sprintf(out, "vl_offset_gain8:        %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "vl_offset_gain8:        %8d  %8d  %8d  %8d\n",
 		       cam->params.vlOffset.gain8, 0, 255, 30);
-	out += sprintf(out, "flicker_control:        %8s  %8s  %8s  %8s\n",
+	seq_printf(m, "flicker_control:        %8s  %8s  %8s  %8s\n",
 		       cam->params.flickerControl.flickerMode ? "on" : "off",
 		       "off", "on", "off");
-	out += sprintf(out, "mains_frequency:        %8d  %8d  %8d  %8d"
+	seq_printf(m, "mains_frequency:        %8d  %8d  %8d  %8d"
 		       " only 50/60\n",
 		       cam->mainsFreq ? 60 : 50, 50, 60, 50);
 	if(cam->params.flickerControl.allowableOverExposure < 0)
-		out += sprintf(out, "allowable_overexposure: %4dauto      auto  %8d      auto\n",
+		seq_printf(m, "allowable_overexposure: %4dauto      auto  %8d      auto\n",
 			       -cam->params.flickerControl.allowableOverExposure,
 			       255);
 	else
-		out += sprintf(out, "allowable_overexposure: %8d      auto  %8d      auto\n",
+		seq_printf(m, "allowable_overexposure: %8d      auto  %8d      auto\n",
 			       cam->params.flickerControl.allowableOverExposure,
 			       255);
-	out += sprintf(out, "compression_mode:       ");
+	seq_printf(m, "compression_mode:       ");
 	switch(cam->params.compression.mode) {
 	case CPIA_COMPRESSION_NONE:
-		out += sprintf(out, "%8s", "none");
+		seq_printf(m, "%8s", "none");
 		break;
 	case CPIA_COMPRESSION_AUTO:
-		out += sprintf(out, "%8s", "auto");
+		seq_printf(m, "%8s", "auto");
 		break;
 	case CPIA_COMPRESSION_MANUAL:
-		out += sprintf(out, "%8s", "manual");
+		seq_printf(m, "%8s", "manual");
 		break;
 	default:
-		out += sprintf(out, "%8s", "unknown");
+		seq_printf(m, "%8s", "unknown");
 		break;
 	}
-	out += sprintf(out, "    none,auto,manual      auto\n");
-	out += sprintf(out, "decimation_enable:      %8s  %8s  %8s  %8s\n",
+	seq_printf(m, "    none,auto,manual      auto\n");
+	seq_printf(m, "decimation_enable:      %8s  %8s  %8s  %8s\n",
 		       cam->params.compression.decimation ==
 		       DECIMATION_ENAB ? "on":"off", "off", "on",
 		       "off");
-	out += sprintf(out, "compression_target:    %9s %9s %9s %9s\n",
+	seq_printf(m, "compression_target:    %9s %9s %9s %9s\n",
 		       cam->params.compressionTarget.frTargeting  ==
 		       CPIA_COMPRESSION_TARGET_FRAMERATE ?
 		       "framerate":"quality",
 		       "framerate", "quality", "quality");
-	out += sprintf(out, "target_framerate:       %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "target_framerate:       %8d  %8d  %8d  %8d\n",
 		       cam->params.compressionTarget.targetFR, 1, 30, 15);
-	out += sprintf(out, "target_quality:         %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "target_quality:         %8d  %8d  %8d  %8d\n",
 		       cam->params.compressionTarget.targetQ, 1, 64, 5);
-	out += sprintf(out, "y_threshold:            %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "y_threshold:            %8d  %8d  %8d  %8d\n",
 		       cam->params.yuvThreshold.yThreshold, 0, 31, 6);
-	out += sprintf(out, "uv_threshold:           %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "uv_threshold:           %8d  %8d  %8d  %8d\n",
 		       cam->params.yuvThreshold.uvThreshold, 0, 31, 6);
-	out += sprintf(out, "hysteresis:             %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "hysteresis:             %8d  %8d  %8d  %8d\n",
 		       cam->params.compressionParams.hysteresis, 0, 255, 3);
-	out += sprintf(out, "threshold_max:          %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "threshold_max:          %8d  %8d  %8d  %8d\n",
 		       cam->params.compressionParams.threshMax, 0, 255, 11);
-	out += sprintf(out, "small_step:             %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "small_step:             %8d  %8d  %8d  %8d\n",
 		       cam->params.compressionParams.smallStep, 0, 255, 1);
-	out += sprintf(out, "large_step:             %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "large_step:             %8d  %8d  %8d  %8d\n",
 		       cam->params.compressionParams.largeStep, 0, 255, 3);
-	out += sprintf(out, "decimation_hysteresis:  %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "decimation_hysteresis:  %8d  %8d  %8d  %8d\n",
 		       cam->params.compressionParams.decimationHysteresis,
 		       0, 255, 2);
-	out += sprintf(out, "fr_diff_step_thresh:    %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "fr_diff_step_thresh:    %8d  %8d  %8d  %8d\n",
 		       cam->params.compressionParams.frDiffStepThresh,
 		       0, 255, 5);
-	out += sprintf(out, "q_diff_step_thresh:     %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "q_diff_step_thresh:     %8d  %8d  %8d  %8d\n",
 		       cam->params.compressionParams.qDiffStepThresh,
 		       0, 255, 3);
-	out += sprintf(out, "decimation_thresh_mod:  %8d  %8d  %8d  %8d\n",
+	seq_printf(m, "decimation_thresh_mod:  %8d  %8d  %8d  %8d\n",
 		       cam->params.compressionParams.decimationThreshMod,
 		       0, 255, 2);
 	/* QX3 specific entries */
 	if (cam->params.qx3.qx3_detected) {
-		out += sprintf(out, "toplight:               %8s  %8s  %8s  %8s\n",
+		seq_printf(m, "toplight:               %8s  %8s  %8s  %8s\n",
 			       cam->params.qx3.toplight ? "on" : "off",
 			       "off", "on", "off");
-		out += sprintf(out, "bottomlight:            %8s  %8s  %8s  %8s\n",
+		seq_printf(m, "bottomlight:            %8s  %8s  %8s  %8s\n",
 			       cam->params.qx3.bottomlight ? "on" : "off",
 			       "off", "on", "off");
 	}
 
-	len = out - page;
-	len -= off;
-	if (len < count) {
-		*eof = 1;
-		if (len <= 0) return 0;
-	} else
-		len = count;
-
-	*start = page + off;
-	return len;
+	return 0;
 }
 
+static int cpia_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cpia_proc_show, PDE(inode)->data);
+}
 
-static int match(char *checkstr, char **buffer, unsigned long *count,
+static int match(char *checkstr, char **buffer, size_t *count,
 		 int *find_colon, int *err)
 {
 	int ret, colon_found = 1;
@@ -551,7 +542,7 @@ static int match(char *checkstr, char **
 	return ret;
 }
 
-static unsigned long int value(char **buffer, unsigned long *count, int *err)
+static unsigned long int value(char **buffer, size_t *count, int *err)
 {
 	char *p;
 	unsigned long int ret;
@@ -565,10 +556,10 @@ static unsigned long int value(char **bu
 	return ret;
 }
 
-static int cpia_write_proc(struct file *file, const char __user *buf,
-			   unsigned long count, void *data)
+static ssize_t cpia_proc_write(struct file *file, const char __user *buf,
+			       size_t count, loff_t *pos)
 {
-	struct cam_data *cam = data;
+	struct cam_data *cam = PDE(file->f_path.dentry->d_inode)->data;
 	struct cam_params new_params;
 	char *page, *buffer;
 	int retval, find_colon;
@@ -582,7 +573,7 @@ static int cpia_write_proc(struct file *
 	 * from the comx driver
 	 */
 	if (count > PAGE_SIZE) {
-		printk(KERN_ERR "count is %lu > %d!!!\n", count, (int)PAGE_SIZE);
+		printk(KERN_ERR "count is %zu > %d!!!\n", count, (int)PAGE_SIZE);
 		return -ENOSPC;
 	}
 
@@ -1340,6 +1331,15 @@ out:
 	return retval;
 }
 
+static const struct file_operations cpia_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cpia_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= cpia_proc_write,
+};
+
 static void create_proc_cpia_cam(struct cam_data *cam)
 {
 	char name[5 + 1 + 10 + 1];
@@ -1350,13 +1350,10 @@ static void create_proc_cpia_cam(struct 
 
 	snprintf(name, sizeof(name), "video%d", cam->vdev.num);
 
-	ent = create_proc_entry(name, S_IFREG|S_IRUGO|S_IWUSR, cpia_proc_root);
+	ent = proc_create_data(name, S_IRUGO|S_IWUSR, cpia_proc_root,
+			       &cpia_proc_fops, cam);
 	if (!ent)
 		return;
-
-	ent->data = cam;
-	ent->read_proc = cpia_read_proc;
-	ent->write_proc = cpia_write_proc;
 	/*
 	   size of the proc entry is 3736 bytes for the standard webcam;
 	   the extra features of the QX3 microscope add 189 bytes.
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
proc_fops-convert-av7110.patch
proc_fops-convert-cpia.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
uml-irq-register-race-condition.patch
make-debug_bugverbose-default-to-y.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch

