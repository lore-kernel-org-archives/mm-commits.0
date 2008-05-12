From: akpm@linux-foundation.org
Subject: + drm-radeon-radeon_enable_vblank-should-return-negative-error.patch added to -mm tree
Date: Mon, 12 May 2008 16:39:56 -0700
Message-ID: <200805122339.m4CNduTu014950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754663AbYELXlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:41:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, airlied@redhat.com, jbarnes@virtuousgeek.org


The patch titled
     drm/radeon: radeon_enable_vblank should return negative error
has been added to the -mm tree.  Its filename is
     drm-radeon-radeon_enable_vblank-should-return-negative-error.patch

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
Subject: drm/radeon: radeon_enable_vblank should return negative error
From: Marcin Slusarz <marcin.slusarz@gmail.com>

radeon_enable_vblank <- drm_vblank_get <- drm_wait_vblank and
drm_wait_vblank returns negative values on error.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
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

ntfs-le_add_cpu-conversion.patch
drm-radeon-radeon_enable_vblank-should-return-negative-error.patch
cifs-cifssmbposixlock-should-return-einval-on-error.patch
dlm-tcp_connect_to_sock-should-check-for-einval-not-einval.patch
isdn-capi-return-proper-errnos-on-module-init.patch
net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch
s390-char-vmlogrdr-module-initialization-function-should-return-negative-errors.patch

