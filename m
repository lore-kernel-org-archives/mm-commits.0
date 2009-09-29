From: akpm@linux-foundation.org
Subject: + fix-drm_fb_helper-warning-when-config_magic_sysrq.patch added to -mm tree
Date: Tue, 29 Sep 2009 13:31:12 -0700
Message-ID: <200909292031.n8TKVCX6024377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753716AbZI2UbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 16:31:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikpe@it.uu.se, airlied@linux.ie


The patch titled
     drm: fix drm_fb_helper warning when !CONFIG_MAGIC_SYSRQ
has been added to the -mm tree.  Its filename is
     fix-drm_fb_helper-warning-when-config_magic_sysrq.patch

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
Subject: drm: fix drm_fb_helper warning when !CONFIG_MAGIC_SYSRQ
From: Mikael Pettersson <mikpe@it.uu.se>

Compiling DRM throws the following warning if MAGIC_SYSRQ is disabled:

drivers/gpu/drm/drm_fb_helper.c:101: warning: 'sysrq_drm_fb_helper_restore_op' defined but not used

Fix: place sysrq_drm_fb_helper_restore_op and associated
definitions inside #ifdef CONFIG_MAGIC_SYSRQ.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_fb_helper.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/gpu/drm/drm_fb_helper.c~fix-drm_fb_helper-warning-when-config_magic_sysrq drivers/gpu/drm/drm_fb_helper.c
--- a/drivers/gpu/drm/drm_fb_helper.c~fix-drm_fb_helper-warning-when-config_magic_sysrq
+++ a/drivers/gpu/drm/drm_fb_helper.c
@@ -280,6 +280,7 @@ void drm_fb_helper_restore(void)
 }
 EXPORT_SYMBOL(drm_fb_helper_restore);
 
+#ifdef CONFIG_MAGIC_SYSRQ
 static void drm_fb_helper_restore_work_fn(struct work_struct *ignored)
 {
 	drm_fb_helper_restore();
@@ -296,6 +297,7 @@ static struct sysrq_key_op sysrq_drm_fb_
 	.help_msg = "force-fb(V)",
 	.action_msg = "Restore framebuffer console",
 };
+#endif
 
 static void drm_fb_helper_on(struct fb_info *info)
 {
_

Patches currently in -mm which might be from mikpe@it.uu.se are

drm-fix-radeon-warnings-when-config_debug_fs.patch
fix-drm_fb_helper-warning-when-config_magic_sysrq.patch

