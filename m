From: akpm@linux-foundation.org
Subject: - tdfxfb-replace-busy-waiting-with-cpu_relax.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:44:25 -0700
Message-ID: <200710162044.l9GKiPrW016144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935101AbXJPVH2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     tdfxfb: replace busy waiting with cpu_relax
has been removed from the -mm tree.  Its filename was
     tdfxfb-replace-busy-waiting-with-cpu_relax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tdfxfb: replace busy waiting with cpu_relax
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch replaces busy waiting with cpu_relax() call.  This makes scrolling
faster.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-replace-busy-waiting-with-cpu_relax drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-replace-busy-waiting-with-cpu_relax
+++ a/drivers/video/tdfxfb.c
@@ -273,7 +273,8 @@ static inline void banshee_make_room(str
 {
 	/* Note: The Voodoo3's onboard FIFO has 32 slots. This loop
 	 * won't quit if you ask for more. */
- 	while ((tdfx_inl(par, STATUS) & 0x1f) < size - 1) ;
+	while ((tdfx_inl(par, STATUS) & 0x1f) < size - 1)
+		cpu_relax();
 }
  
 static int banshee_wait_idle(struct fb_info *info)
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
