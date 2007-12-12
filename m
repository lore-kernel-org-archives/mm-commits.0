From: akpm@linux-foundation.org
Subject: + drm-dont-cast-a-pointer-to-pointer-of-list_head.patch added to -mm tree
Date: Wed, 12 Dec 2007 00:59:24 -0800
Message-ID: <200712120859.lBC8xOjK002091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47542 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756410AbXLLI7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 03:59:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, airlied@linux.ie


The patch titled
     drm: don't cast a pointer to pointer of list_head
has been added to the -mm tree.  Its filename is
     drm-dont-cast-a-pointer-to-pointer-of-list_head.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drm: don't cast a pointer to pointer of list_head
From: Li Zefan <lizf@cn.fujitsu.com>

The casting is safe only when the list_head member is the first member of
the structure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/i915_irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/drm/i915_irq.c~drm-dont-cast-a-pointer-to-pointer-of-list_head drivers/char/drm/i915_irq.c
--- a/drivers/char/drm/i915_irq.c~drm-dont-cast-a-pointer-to-pointer-of-list_head
+++ a/drivers/char/drm/i915_irq.c
@@ -699,7 +699,7 @@ int i915_vblank_swap(struct drm_device *
 
 	spin_lock_irqsave(&dev_priv->swaps_lock, irqflags);
 
-	list_add_tail((struct list_head *)vbl_swap, &dev_priv->vbl_swaps.head);
+	list_add_tail(&vbl_swap->head, &dev_priv->vbl_swaps.head);
 	dev_priv->swaps_pending++;
 
 	spin_unlock_irqrestore(&dev_priv->swaps_lock, irqflags);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

drm-dont-cast-a-pointer-to-pointer-of-list_head.patch
git-hid.patch
git-net.patch
wireless-libertas-dont-cast-a-pointer-to-pointer-of-list_head.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
