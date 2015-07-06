From: akpm@linux-foundation.org
Subject: [merged] drm-use-kvfree-in-drm_free_large.patch removed from -mm
 tree
Date: Mon, 06 Jul 2015 12:47:47 -0700
Message-ID: <559adb63.Ytg6u2pHI33uZaxM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbbGFTrr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@kernel.org, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: drm: use kvfree() in drm_free_large()
has been removed from the -mm tree.  Its filename was
     drm-use-kvfree-in-drm_free_large.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pekka Enberg <penberg@kernel.org>
Subject: drm: use kvfree() in drm_free_large()

Use kvfree() instead of open-coding it.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/drm/drm_mem_util.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN include/drm/drm_mem_util.h~drm-use-kvfree-in-drm_free_large include/drm/drm_mem_util.h
--- a/include/drm/drm_mem_util.h~drm-use-kvfree-in-drm_free_large
+++ a/include/drm/drm_mem_util.h
@@ -56,10 +56,7 @@ static __inline__ void *drm_malloc_ab(si
 
 static __inline void drm_free_large(void *ptr)
 {
-	if (!is_vmalloc_addr(ptr))
-		return kfree(ptr);
