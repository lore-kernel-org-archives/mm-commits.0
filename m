From: akpm@linux-foundation.org
Subject: + drm-sis-depends-on-fb_sis.patch added to -mm tree
Date: Thu, 07 Aug 2008 13:10:48 -0700
Message-ID: <200808072010.m77KAmks003065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbYHGUMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 16:12:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, airlied@linux.ie


The patch titled
     drm: sis depends on FB_SIS
has been added to the -mm tree.  Its filename is
     drm-sis-depends-on-fb_sis.patch

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

linux-next.patch
git-kbuild-fixes.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure-fix.patch
git-unionfs.patch
docsrc-build-documentation-sources.patch
docsrc-fix-procfs-example.patch
docsrc-fix-ifenslave-type.patch
docsrc-fix-crc32hash-type.patch
docsrc-fix-getdelays-printk-formats.patch
drm-sis-depends-on-fb_sis.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

