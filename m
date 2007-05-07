From: akpm@linux-foundation.org
Subject: + pm2fb-memclock-setting-corrections.patch added to -mm tree
Date: Mon, 07 May 2007 15:26:56 -0700
Message-ID: <200705072226.l47MQuxS006955@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967017AbXEGW1a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 18:27:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm2fb: memclock setting corrections
has been added to the -mm tree.  Its filename is
     pm2fb-memclock-setting-corrections.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm2fb: memclock setting corrections
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch disables a memory clock setting if a board has been initialized by
BIOS.  This allows using the memory clock set by manufacturer of the board.

This patch also sets default clock for 3dlabs Permedia 2V reference board's
clock to 75MHz (BIOS setting for EONtronic Permedia 2Vboard), because the
default 83MHz can be too high.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-memclock-setting-corrections drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-memclock-setting-corrections
+++ a/drivers/video/pm2fb.c
@@ -1141,10 +1141,10 @@ static int __devinit pm2fb_probe(struct 
 		default_par->mem_control, default_par->boot_address,
 		default_par->mem_config);
 
-	default_par->memclock = CVPPC_MEMCLOCK;
 	if(default_par->mem_control == 0 &&
 		default_par->boot_address == 0x31 &&
 		default_par->mem_config == 0x259fffff) {
+		default_par->memclock = CVPPC_MEMCLOCK;
 		default_par->mem_control=0;
 		default_par->boot_address=0x20;
 		default_par->mem_config=0xe6002021;
@@ -1164,7 +1164,7 @@ static int __devinit pm2fb_probe(struct 
 			DPRINTK("We have not been initialized by VGA BIOS "
 				"and are running on an 3dlabs reference board\n");
 			DPRINTK("Initializing card timings manually...\n");
-			default_par->memclock=70000;
+			default_par->memclock=74894;
 		}
 	}
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

skeletonfb-various-corrections.patch
pm2fb-3dlabs-permedia-2v-reference-board-added.patch
pm2fb-permedia-2v-memory-clock-setting.patch
pm2fb-pixclock-setting-restriction.patch
pm2fb-reset-transparency-settings.patch
pm2fb-memclock-setting-corrections.patch
pm2fb-accelerated-fillrect-and-copyarea.patch
skeletonfb-more-corrections.patch
pm2fb-removal-of-pm2fb_par-fields.patch
skeletonfb-improvements.patch
pm2fb-fix-of-jumps-in-pm2fb_probe.patch
