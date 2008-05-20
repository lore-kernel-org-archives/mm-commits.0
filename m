From: akpm@linux-foundation.org
Subject: - drm-radeon-radeon_enable_vblank-should-return-negative-error.patch removed from -mm tree
Date: Tue, 20 May 2008 14:14:06 -0700
Message-ID: <200805202114.m4KLE6rK011436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763308AbYETVYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:24:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, airlied@redhat.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     drm/radeon: radeon_enable_vblank should return negative error
has been removed from the -mm tree.  Its filename was
     drm-radeon-radeon_enable_vblank-should-return-negative-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm/radeon: radeon_enable_vblank should return negative error
From: Marcin Slusarz <marcin.slusarz@gmail.com>

radeon_enable_vblank <- drm_vblank_get <- drm_wait_vblank and
drm_wait_vblank returns negative values on error.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/radeon_irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/drm/radeon_irq.c~drm-radeon-radeon_enable_vblank-should-return-negative-error drivers/char/drm/radeon_irq.c
--- a/drivers/char/drm/radeon_irq.c~drm-radeon-radeon_enable_vblank-should-return-negative-error
+++ a/drivers/char/drm/radeon_irq.c
@@ -59,7 +59,7 @@ int radeon_enable_vblank(struct drm_devi
 	default:
 		DRM_ERROR("tried to enable vblank on non-existent crtc %d\n",
 			  crtc);
-		return EINVAL;
+		return -EINVAL;
 	}
 
 	return 0;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
linux-next.patch
net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch
vfs-fix-err_ptr-abuse-in-generic_readlink.patch
ntfs-le_add_cpu-conversion.patch

