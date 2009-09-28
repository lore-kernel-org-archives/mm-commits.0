From: akpm@linux-foundation.org
Subject: + drm-fix-radeon-warnings-when-config_debug_fs.patch added to -mm tree
Date: Mon, 28 Sep 2009 16:19:31 -0700
Message-ID: <200909282319.n8SNJVu5031505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753463AbZI1XTk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Sep 2009 19:19:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikpe@it.uu.se, airlied@linux.ie


The patch titled
     drm: fix radeon warnings when !CONFIG_DEBUG_FS
has been added to the -mm tree.  Its filename is
     drm-fix-radeon-warnings-when-config_debug_fs.patch

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
Subject: drm: fix radeon warnings when !CONFIG_DEBUG_FS
From: Mikael Pettersson <mikpe@it.uu.se>

Compiling the radeon DRM driver with !CONFIG_DEBUG_FS throws the following
warnings:

drivers/gpu/drm/radeon/radeon_ttm.c: In function 'radeon_ttm_debugfs_init':
drivers/gpu/drm/radeon/radeon_ttm.c:714: warning: unused variable 'i'
drivers/gpu/drm/radeon/radeon_ttm.c: At top level:
drivers/gpu/drm/radeon/radeon_ttm.c:692: warning: 'radeon_mem_types_list' defined but not used
drivers/gpu/drm/radeon/radeon_ttm.c:693: warning: 'radeon_mem_types_names' defined but not used

Fix: move these variables inside the #if defined(CONFIG_DEBUG_FS) block in
radeon_ttm_debugsfs_init(), which is the only place using them.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/radeon_ttm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/gpu/drm/radeon/radeon_ttm.c~drm-fix-radeon-warnings-when-config_debug_fs drivers/gpu/drm/radeon/radeon_ttm.c
--- a/drivers/gpu/drm/radeon/radeon_ttm.c~drm-fix-radeon-warnings-when-config_debug_fs
+++ a/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -689,9 +689,6 @@ struct ttm_backend *radeon_ttm_backend_c
 
 #define RADEON_DEBUGFS_MEM_TYPES 2
 
-static struct drm_info_list radeon_mem_types_list[RADEON_DEBUGFS_MEM_TYPES];
-static char radeon_mem_types_names[RADEON_DEBUGFS_MEM_TYPES][32];
