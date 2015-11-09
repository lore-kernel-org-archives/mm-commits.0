From: akpm@linux-foundation.org
Subject: + remove-abs64-fix-fix-fix-fix.patch added to -mm tree
Date: Mon, 09 Nov 2015 14:16:49 -0800
Message-ID: <56411b51.+/DYnjMViOyndH2T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbbKIWQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 17:16:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: remove-abs64-fix-fix-fix-fix
has been added to the -mm tree.  Its filename is
     remove-abs64-fix-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/remove-abs64-fix-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/remove-abs64-fix-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: remove-abs64-fix-fix-fix-fix

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_irq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/drm_irq.c~remove-abs64-fix-fix-fix-fix drivers/gpu/drm/drm_irq.c
--- a/drivers/gpu/drm/drm_irq.c~remove-abs64-fix-fix-fix-fix
+++ a/drivers/gpu/drm/drm_irq.c
@@ -261,7 +261,7 @@ static void vblank_disable_and_save(stru
 	 * available. In that case we can't account for this and just
 	 * hope for the best.
 	 */
-	if (vblrc && (abs64(diff_ns) > 1000000))
+	if (vblrc && (abs(diff_ns) > 1000000))
 		store_vblank(dev, pipe, 1, &tvblank);
 
 	spin_unlock_irqrestore(&dev->vblank_time_lock, irqflags);
@@ -1772,7 +1772,7 @@ bool drm_handle_vblank(struct drm_device
 	 * e.g., due to spurious vblank interrupts. We need to
 	 * ignore those for accounting.
 	 */
-	if (abs64(diff_ns) > DRM_REDUNDANT_VBLIRQ_THRESH_NS)
+	if (abs(diff_ns) > DRM_REDUNDANT_VBLIRQ_THRESH_NS)
 		store_vblank(dev, pipe, 1, &tvblank);
 	else
 		DRM_DEBUG("crtc %u: Redundant vblirq ignored. diff_ns = %d\n",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
remove-abs64-fix-fix-fix.patch
remove-abs64-fix-fix-fix-fix.patch

