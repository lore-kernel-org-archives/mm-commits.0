From: akpm@linux-foundation.org
Subject: + fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-update.patch added to -mm tree
Date: Thu, 17 Jul 2008 15:12:27 -0700
Message-ID: <200807172212.m6HMCRir009170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183AbYGQWMe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 18:12:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: timur@freescale.com


The patch titled
     fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-update
has been added to the -mm tree.  Its filename is
     fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-update.patch

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
Subject: fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-update
From: Timur Tabi <timur@freescale.com>

Fix printk format specifiers, per Andrew Morton.

Signed-off-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fsl-diu-fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/fsl-diu-fb.c~fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-update drivers/video/fsl-diu-fb.c
--- a/drivers/video/fsl-diu-fb.c~fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-update
+++ a/drivers/video/fsl-diu-fb.c
@@ -295,7 +295,7 @@ static void *fsl_diu_alloc(size_t size, 
 	virt = alloc_pages_exact(size, GFP_DMA | __GFP_ZERO);
 	if (virt) {
 		*phys = virt_to_phys(virt);
-		pr_debug("virt=%p, phys=%llx\n", virt,
+		pr_debug("virt=%p phys=%llx\n", virt,
 			(unsigned long long)*phys);
 	}
 
_

Patches currently in -mm which might be from timur@freescale.com are

origin.patch
mm-add-alloc_pages_exact-and-free_pages_exact.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-update.patch

