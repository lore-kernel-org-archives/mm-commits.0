From: akpm@linux-foundation.org
Subject: [merged] drm-fix-lock_test_with_return-macro.patch removed from -mm tree
Date: Mon, 15 Jun 2009 12:01:23 -0700
Message-ID: <200906151901.n5FJ1N03022816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932181AbZFOTBX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 15:01:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drm: fix LOCK_TEST_WITH_RETURN macro
has been removed from the -mm tree.  Its filename was
     drm-fix-lock_test_with_return-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: fix LOCK_TEST_WITH_RETURN macro
From: Roel Kluin <roel.kluin@gmail.com>

When this macro isn't called with 'file_priv' this will result in a build
failure.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/drm/drmP.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN include/drm/drmP.h~drm-fix-lock_test_with_return-macro include/drm/drmP.h
--- a/include/drm/drmP.h~drm-fix-lock_test_with_return-macro
+++ a/include/drm/drmP.h
@@ -237,15 +237,15 @@ struct drm_device;
  * \param dev DRM device.
  * \param filp file pointer of the caller.
  */
-#define LOCK_TEST_WITH_RETURN( dev, file_priv )				\
-do {									\
-	if (!_DRM_LOCK_IS_HELD(file_priv->master->lock.hw_lock->lock) ||		\
-	    file_priv->master->lock.file_priv != file_priv)	{			\
+#define LOCK_TEST_WITH_RETURN( dev, _file_priv )				\
+do {										\
+	if (!_DRM_LOCK_IS_HELD(_file_priv->master->lock.hw_lock->lock) ||	\
+	    _file_priv->master->lock.file_priv != _file_priv)	{		\
 		DRM_ERROR( "%s called without lock held, held  %d owner %p %p\n",\
-			   __func__, _DRM_LOCK_IS_HELD(file_priv->master->lock.hw_lock->lock),\
-			   file_priv->master->lock.file_priv, file_priv);		\
-		return -EINVAL;						\
-	}								\
+			   __func__, _DRM_LOCK_IS_HELD(_file_priv->master->lock.hw_lock->lock),\
+			   _file_priv->master->lock.file_priv, _file_priv);	\
+		return -EINVAL;							\
+	}									\
 } while (0)
 
 /**
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
serial-fix-off-by-one-errors.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
usb-mutually-exclusive-port_status.patch
spi-size-of-a-pointer-to-determine-the-size-of-the-pointed-to-type.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

