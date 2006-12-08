From: akpm@osdl.org
Subject: - video-sis-remove-unnecessary-variables-in-sis_ddc2delay.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:07 -0800
Message-ID: <200612082013.kB8KD7Io003062@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59444 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946727AbWLHUNQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:13:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@cs.washington.edu, adaplas@pol.net, jesper.juhl@gmail.com, thomas@winischhofer.net, mm-commits@vger.kernel.org


The patch titled
     video SiS: remove unnecessary variables in SiS_DDC2Delay
has been removed from the -mm tree.  Its filename was
     video-sis-remove-unnecessary-variables-in-sis_ddc2delay.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: video SiS: remove unnecessary variables in SiS_DDC2Delay
From: David Rientjes <rientjes@cs.washington.edu>

Remove unnecesary iteration and accumulator variables from SiS_DDC2Delay.

Originally spotted by Jesper Juhl <jesper.juhl@gmail.com>.

Cc: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Signed-off-by: David Rientjes <rientjes@cs.washington.edu>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/sis/init301.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/video/sis/init301.c~video-sis-remove-unnecessary-variables-in-sis_ddc2delay drivers/video/sis/init301.c
--- a/drivers/video/sis/init301.c~video-sis-remove-unnecessary-variables-in-sis_ddc2delay
+++ a/drivers/video/sis/init301.c
@@ -445,11 +445,8 @@ SiS_CR36BIOSWord23d(struct SiS_Private *
 void
 SiS_DDC2Delay(struct SiS_Private *SiS_Pr, unsigned int delaytime)
 {
-   unsigned int i, j;
-
-   for(i = 0; i < delaytime; i++) {
-      j += SiS_GetReg(SiS_Pr->SiS_P3c4,0x05);
-   }
+   while (delaytime-- > 0)
+      SiS_GetReg(SiS_Pr->SiS_P3c4, 0x05);
 }
 
 #if defined(SIS300) || defined(SIS315H)
_

Patches currently in -mm which might be from rientjes@cs.washington.edu are

origin.patch
video-sis-remove-unnecessary-variables-in-sis_ddc2delay.patch
hrtimers-clean-up-locking-fix.patch

