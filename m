From: akpm@linux-foundation.org
Subject: - pm3fb-replace-busy-waiting-with-cpu_relax.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:44:29 -0700
Message-ID: <200710162044.l9GKiTN8016150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52510 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935858AbXJPVHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm3fb: replace busy waiting with cpu_relax
has been removed from the -mm tree.  Its filename was
     pm3fb-replace-busy-waiting-with-cpu_relax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm3fb: replace busy waiting with cpu_relax
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch replaces busy waiting with the cpu_relax() call.  This makes
scrolling faster.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/video/pm3fb.c~pm3fb-replace-busy-waiting-with-cpu_relax drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-replace-busy-waiting-with-cpu_relax
+++ a/drivers/video/pm3fb.c
@@ -110,7 +110,8 @@ static inline void PM3_WRITE_REG(struct 
 
 static inline void PM3_WAIT(struct pm3_par *par, u32 n)
 {
-	while (PM3_READ_REG(par, PM3InFIFOSpace) < n);
+	while (PM3_READ_REG(par, PM3InFIFOSpace) < n)
+		cpu_relax();
 }
 
 static inline void PM3_WRITE_DAC_REG(struct pm3_par *par, unsigned r, u8 v)
@@ -209,8 +210,8 @@ static int pm3fb_sync(struct fb_info *in
 	PM3_WRITE_REG(par, PM3Sync, 0);
 	mb();
 	do {
-		while ((PM3_READ_REG(par, PM3OutFIFOWords)) == 0);
-		rmb();
+		while ((PM3_READ_REG(par, PM3OutFIFOWords)) == 0)
+			cpu_relax();
 	} while ((PM3_READ_REG(par, PM3OutputFifo)) != PM3Sync_Tag);
 
 	return 0;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
