From: akpm@linux-foundation.org
Subject: [merged] drm-radeon-kms-fix-caching-mode-selection-for-gtt-object.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:28:09 -0700
Message-ID: <200908101928.n7AJS9Fw027180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432AbZHJT2Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:28:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, mm-commits@vger.kernel.org


The patch titled
     drm/radeon/kms: fix caching mode selection for GTT object
has been removed from the -mm tree.  Its filename was
     drm-radeon-kms-fix-caching-mode-selection-for-gtt-object.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

