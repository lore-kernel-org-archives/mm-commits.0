From: akpm@linux-foundation.org
Subject: +
 drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b.patch added to -mm tree
Date: Thu, 17 Apr 2014 12:32:56 -0700
Message-ID: <53502c68.JGRq45ZMeWufgC8/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaDQTc5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 15:32:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, bskeggs@redhat.com, airlied@redhat.com, saproj@gmail.com

Subject: + drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b.patch added to -mm tree
To: saproj@gmail.com,airlied@redhat.com,bskeggs@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 12:32:56 -0700


The patch titled
     Subject: drm/nouveau/bios: fix a bit shift error introduced by 457e77b
has been added to the -mm tree.  Its filename is
     drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergei Antonov <saproj@gmail.com>
Subject: drm/nouveau/bios: fix a bit shift error introduced by 457e77b

457e77b26428ab4a24 ("drm/nouveau/bios: add more checks to PRAMIN image
fetching") added two checks applied to a value received from nv_rd32(bios,
0x619f04).  But after this new piece of code is executed, the addr local
variable does not hold the same value it used to hold before the commit. 
Here is what is was assigned in the original code:

	(u64)(nv_rd32(bios, 0x619f04) & 0xffffff00) << 8

in the committed code it ends up with this value:
	(u64)(nv_rd32(bios, 0x619f04) >> 8) << 8

These expressions are obviously not equivalent.

My Nvidia video card does not show anything on the display when I boot a
kernel containing this commit.

The patch fixes the code so that the new checks are still done, but the
side effect of an incorrect addr value is gone.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/core/subdev/bios/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/nouveau/core/subdev/bios/base.c~drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b drivers/gpu/drm/nouveau/core/subdev/bios/base.c
--- a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c~drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b
+++ a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
@@ -109,7 +109,7 @@ nouveau_bios_shadow_pramin(struct nouvea
 			return;
 		}
 
-		addr = (u64)(addr >> 8) << 8;
+		addr = (u64)(addr & 0xffffff00) << 8;
 		if (!addr) {
 			addr  = (u64)nv_rd32(bios, 0x001700) << 16;
 			addr += 0xf0000;
_

Patches currently in -mm which might be from saproj@gmail.com are

drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b.patch

