From: akpm@linux-foundation.org
Subject: - pm2fb-memclock-setting-corrections.patch removed from -mm tree
Date: Tue, 08 May 2007 20:02:35 -0700
Message-ID: <200705090302.l4932Z3F010853@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033299AbXEIDCi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:02:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm2fb: memclock setting corrections
has been removed from the -mm tree.  Its filename was
     pm2fb-memclock-setting-corrections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 insertions(+), 2 deletions(-)

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

origin.patch
