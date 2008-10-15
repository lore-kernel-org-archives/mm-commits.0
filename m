From: akpm@linux-foundation.org
Subject: - viafb-hwc-hwh-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:53:21 -0700
Message-ID: <200810152353.m9FNrLrB023975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716AbYJOXyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:54:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, JosephChan@via.com.tw, geert@linux-m68k.org, josephchan@via.com.tw, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb-hwc-hwh-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     viafb-hwc-hwh-checkpatch-fixes.patch

This patch was dropped because it was folded into viafb-hwc-hwh.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb-hwc-hwh-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing statements should be on next line
#1022: FILE: drivers/video/via/hw.c:1004:
+	while ((i < NUM_TOTAL_MODETABLE)

ERROR: trailing statements should be on next line
#1041: FILE: drivers/video/via/hw.c:1023:
+	while ((i < NUM_TOTAL_CEA_MODES)

WARNING: suspect code indent for conditional statements
#1048: FILE: drivers/video/via/hw.c:1030:
+		while ((i < NUM_TOTAL_MODETABLE)

total: 2 errors, 1 warnings, 3796 lines checked

./patches/viafb-hwc-hwh.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Joseph Chan <josephchan@via.com.tw>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-hwc-hwh-checkpatch-fixes drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-hwc-hwh-checkpatch-fixes
+++ a/drivers/video/via/hw.c
@@ -1001,9 +1001,10 @@ static int search_mode_setting(int ModeI
 {
 	int i = 0;
 
-	while ((i < NUM_TOTAL_MODETABLE)
-	       && (ModeInfoIndex != CLE266Modes[i].ModeIndex)) i++;
-	if ((i >= NUM_TOTAL_MODETABLE))
+	while ((i < NUM_TOTAL_MODETABLE) &&
+			(ModeInfoIndex != CLE266Modes[i].ModeIndex))
+		i++;
+	if (i >= NUM_TOTAL_MODETABLE)
 		i = 0;
 	return i;
 
@@ -1020,17 +1021,18 @@ struct VideoModeTable *viafb_get_cea_mod
 {
 	struct VideoModeTable *TmpTbl = NULL;
 	int i = 0;
-	while ((i < NUM_TOTAL_CEA_MODES)
-	       && (Index != CEA_HDMI_Modes[i].ModeIndex)) i++;
+	while ((i < NUM_TOTAL_CEA_MODES) &&
+			(Index != CEA_HDMI_Modes[i].ModeIndex))
+		i++;
 	if ((i < NUM_TOTAL_CEA_MODES))
 		TmpTbl = &CEA_HDMI_Modes[i];
 	 else {
 		/*Still use general timing if don't find CEA timing */
 		i = 0;
-		while ((i < NUM_TOTAL_MODETABLE)
-		       && (Index != CLE266Modes[i].ModeIndex))
+		while ((i < NUM_TOTAL_MODETABLE) &&
+				(Index != CLE266Modes[i].ModeIndex))
 		       i++;
-		if ((i >= NUM_TOTAL_MODETABLE))
+		if (i >= NUM_TOTAL_MODETABLE)
 			i = 0;
 		TmpTbl = &CLE266Modes[i];
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
make-taint-bit-reliable-v3.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday.patch
allow-recursion-in-binfmt_script-and-binfmt_misc.patch
autofs4-track-uid-and-gid-of-last-mount-requester.patch
autofs4-add-miscellaneous-device-for-ioctls.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip.patch
viafb-accelc-accelh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-hwc-hwh.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch

