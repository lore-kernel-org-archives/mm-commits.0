From: akpm@linux-foundation.org
Subject: + blackfin-video-driver-fix-bug-when-opening-reading-mmaping-bf54x-and-bf52x-framebuffer-simultaneously.patch added to -mm tree
Date: Thu, 27 Mar 2008 12:35:29 -0700
Message-ID: <200803271935.m2RJZTUv018699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756589AbYC0Tfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 15:35:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, adaplas@pol.net, cooloney@kernel.org, geert@linux-m68k.org


The patch titled
     blackfin video driver: fix bug when opening/reading/mmaping BF54x and BF52x framebuffer simultaneously
has been added to the -mm tree.  Its filename is
     blackfin-video-driver-fix-bug-when-opening-reading-mmaping-bf54x-and-bf52x-framebuffer-simultaneously.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
blackfin-video-driver-update-the-bf52x-ezkit-video-framebuffer-driver-according-to-lkml-review.patch
blackfin-video-driver-update-the-bf52x-ezkit-video-framebuffer-driver-according-to-lkml-review-fix.patch
blackfin-video-driver-fix-bug-when-opening-reading-mmaping-bf54x-and-bf52x-framebuffer-simultaneously.patch

