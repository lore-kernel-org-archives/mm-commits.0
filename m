From: akpm@linux-foundation.org
Subject: - drm-sis-depends-on-fb_sis.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:13:56 -0700
Message-ID: <200808261813.m7QIDubn020055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754664AbYHZSOx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:14:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm: sis depends on FB_SIS
has been removed from the -mm tree.  Its filename was
     drm-sis-depends-on-fb_sis.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: sis depends on FB_SIS
From: Randy Dunlap <randy.dunlap@oracle.com>

drm/sis calls mm functions in fb/sis, so make the former depend
on the latter.

This one happened with FB_SIS=m, AGP_SIS=y, DRM_SYS=y.

sis1.out:sis_mm.c:(.text+0x70014): undefined reference to `sis_free'
sis1.out:sis_mm.c:(.text+0x7002a): undefined reference to `sis_malloc'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/Kconfig~drm-sis-depends-on-fb_sis drivers/gpu/drm/Kconfig
--- a/drivers/gpu/drm/Kconfig~drm-sis-depends-on-fb_sis
+++ a/drivers/gpu/drm/Kconfig
@@ -86,7 +86,7 @@ config DRM_MGA
 
 config DRM_SIS
 	tristate "SiS video cards"
-	depends on DRM && AGP
+	depends on DRM && AGP && FB_SIS
 	help
 	  Choose this option if you have a SiS 630 or compatible video
           chipset. If M is selected the module will be called sis. AGP
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
git-kvm.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-security-testing.patch
ftrace-printk-formatting-infrastructure.patch
git-block.patch
git-pekka.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

