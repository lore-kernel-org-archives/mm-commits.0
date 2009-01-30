From: akpm@linux-foundation.org
Subject: + drm-fix-lock_test_with_return-macro.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:08:02 -0800
Message-ID: <200901302008.n0UK82sO029264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753984AbZA3UId (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:08:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com


The patch titled
     drm: fix LOCK_TEST_WITH_RETURN macro
has been added to the -mm tree.  Its filename is
     drm-fix-lock_test_with_return-macro.patch

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
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
paride-pgc-xs-confusion.patch
virtio-fix-bad_ring-start_us-and-end_use-macros.patch
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
ufs-sector_t-cannot-be-negative.patch

