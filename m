From: akpm@linux-foundation.org
Subject: [merged] drivers-gpu-drm-radeon-radeon_atombiosc-range-check-issues.patch removed from -mm tree
Date: Thu, 06 May 2010 12:08:45 -0400
Message-ID: <201005061910.o46JAFbu008510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123Ab0EFTKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 15:10:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, airlied@linux.ie, alexdeucher@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/gpu/drm/radeon/radeon_atombios.c: range check issues
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-radeon-radeon_atombiosc-range-check-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpu/drm/radeon/radeon_atombios.c: range check issues
From: Dan Carpenter <error27@gmail.com>

This change makes the array larger, "MAX_SUPPORTED_TV_TIMING_V1_2" is 3
and the original size "MAX_SUPPORTED_TV_TIMING" is 2.

Also there were checks that were off by one.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Acked-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/atombios.h        |    2 +-
 drivers/gpu/drm/radeon/radeon_atombios.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/gpu/drm/radeon/atombios.h~drivers-gpu-drm-radeon-radeon_atombiosc-range-check-issues drivers/gpu/drm/radeon/atombios.h
--- a/drivers/gpu/drm/radeon/atombios.h~drivers-gpu-drm-radeon-radeon_atombiosc-range-check-issues
+++ a/drivers/gpu/drm/radeon/atombios.h
@@ -2912,7 +2912,7 @@ typedef struct _ATOM_ANALOG_TV_INFO_V1_2
   UCHAR                    ucTV_BootUpDefaultStandard; 
   UCHAR                    ucExt_TV_ASIC_ID;
   UCHAR                    ucExt_TV_ASIC_SlaveAddr;
-  ATOM_DTD_FORMAT          aModeTimings[MAX_SUPPORTED_TV_TIMING];
+  ATOM_DTD_FORMAT          aModeTimings[MAX_SUPPORTED_TV_TIMING_V1_2];
 }ATOM_ANALOG_TV_INFO_V1_2;
 
 typedef struct _ATOM_DPCD_INFO
diff -puN drivers/gpu/drm/radeon/radeon_atombios.c~drivers-gpu-drm-radeon-radeon_atombiosc-range-check-issues drivers/gpu/drm/radeon/radeon_atombios.c
--- a/drivers/gpu/drm/radeon/radeon_atombios.c~drivers-gpu-drm-radeon-radeon_atombiosc-range-check-issues
+++ a/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1264,7 +1264,7 @@ bool radeon_atom_get_tv_timings(struct r
 	switch (crev) {
 	case 1:
 		tv_info = (ATOM_ANALOG_TV_INFO *)(mode_info->atom_context->bios + data_offset);
-		if (index > MAX_SUPPORTED_TV_TIMING)
+		if (index >= MAX_SUPPORTED_TV_TIMING)
 			return false;
 
 		mode->crtc_htotal = le16_to_cpu(tv_info->aModeTimings[index].usCRTC_H_Total);
@@ -1302,7 +1302,7 @@ bool radeon_atom_get_tv_timings(struct r
 		break;
 	case 2:
 		tv_info_v1_2 = (ATOM_ANALOG_TV_INFO_V1_2 *)(mode_info->atom_context->bios + data_offset);
-		if (index > MAX_SUPPORTED_TV_TIMING_V1_2)
+		if (index >= MAX_SUPPORTED_TV_TIMING_V1_2)
 			return false;
 
 		dtd_timings = &tv_info_v1_2->aModeTimings[index];
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
mm-document-follow_page.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch
fs-sysv-dereferencing-err_ptr.patch

