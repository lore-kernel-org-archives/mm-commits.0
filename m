From: akpm@linux-foundation.org
Subject: - blackfin-video-driver-fix-bug-when-opening-reading-mmaping-bf54x-and-bf52x-framebuffer-simultaneously.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:18:03 -0700
Message-ID: <200803312018.m2VKI311024022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756323AbYCaUTB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:19:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, adaplas@pol.net, cooloney@kernel.org, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     blackfin video driver: fix bug when opening/reading/mmaping BF54x and BF52x framebuffer simultaneously
has been removed from the -mm tree.  Its filename was
     blackfin-video-driver-fix-bug-when-opening-reading-mmaping-bf54x-and-bf52x-framebuffer-simultaneously.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin video driver: fix bug when opening/reading/mmaping BF54x and BF52x framebuffer simultaneously
From: Michael Hennerich <michael.hennerich@analog.com>

http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3974

opening/reading/mmaping BF54x and BF52x framebuffer simultaneously triggers
BUG: failure at mm/nommu.c:470/add_nommu_vma() Add VM_SHARED to the default
vm_flags

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bf54x-lq043fb.c    |    2 +-
 drivers/video/bfin-t350mcqb-fb.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/bf54x-lq043fb.c~blackfin-video-driver-fix-bug-when-opening-reading-mmaping-bf54x-and-bf52x-framebuffer-simultaneously drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~blackfin-video-driver-fix-bug-when-opening-reading-mmaping-bf54x-and-bf52x-framebuffer-simultaneously
+++ a/drivers/video/bf54x-lq043fb.c
@@ -384,7 +384,7 @@ static int bfin_bf54x_fb_mmap(struct fb_
 	 *   Other flags can be set, and are documented in
 	 *   include/linux/mm.h
 	 */
-	vma->vm_flags |= VM_MAYSHARE;
+	vma->vm_flags |=  VM_MAYSHARE | VM_SHARED;
 
 	return 0;
 }
diff -puN drivers/video/bfin-t350mcqb-fb.c~blackfin-video-driver-fix-bug-when-opening-reading-mmaping-bf54x-and-bf52x-framebuffer-simultaneously drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~blackfin-video-driver-fix-bug-when-opening-reading-mmaping-bf54x-and-bf52x-framebuffer-simultaneously
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -302,7 +302,7 @@ static int bfin_t350mcqb_fb_mmap(struct 
 	 *   Other flags can be set, and are documented in
 	 *   include/linux/mm.h
 	 */
-	vma->vm_flags |= VM_MAYSHARE;
+	vma->vm_flags |= VM_MAYSHARE | VM_SHARED;
 
 	return 0;
 }
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

origin.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch

