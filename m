From: akpm@linux-foundation.org
Subject: + drm-radeon-kms-fix-caching-mode-selection-for-gtt-object.patch added to -mm tree
Date: Mon, 03 Aug 2009 13:39:20 -0700
Message-ID: <200908032039.n73KdKrr003810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368AbZHCUkU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 16:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jglisse@redhat.com


The patch titled
     drm/radeon/kms: fix caching mode selection for GTT object
has been added to the -mm tree.  Its filename is
     drm-radeon-kms-fix-caching-mode-selection-for-gtt-object.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm/radeon/kms: fix caching mode selection for GTT object
From: Jerome Glisse <jglisse@redhat.com>

GTT object can either be cached, uncached or wc just let core ttm pick the
best mode according to how the bo driver and GTT memory type was
initialized.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/radeon_object.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/radeon/radeon_object.c~drm-radeon-kms-fix-caching-mode-selection-for-gtt-object drivers/gpu/drm/radeon/radeon_object.c
--- a/drivers/gpu/drm/radeon/radeon_object.c~drm-radeon-kms-fix-caching-mode-selection-for-gtt-object
+++ a/drivers/gpu/drm/radeon/radeon_object.c
@@ -106,7 +106,7 @@ static inline uint32_t radeon_object_fla
 		flags |= TTM_PL_FLAG_VRAM | TTM_PL_FLAG_WC | TTM_PL_FLAG_UNCACHED;
 	}
 	if (domain & RADEON_GEM_DOMAIN_GTT) {
-		flags |= TTM_PL_FLAG_TT | TTM_PL_FLAG_WC | TTM_PL_FLAG_UNCACHED;
+		flags |= TTM_PL_FLAG_TT | TTM_PL_MASK_CACHING;
 	}
 	if (domain & RADEON_GEM_DOMAIN_CPU) {
 		flags |= TTM_PL_FLAG_SYSTEM | TTM_PL_MASK_CACHING;
_

Patches currently in -mm which might be from jglisse@redhat.com are

drm-radeon-kms-fix-caching-mode-selection-for-gtt-object.patch

