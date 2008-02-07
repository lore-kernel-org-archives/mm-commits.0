From: akpm@linux-foundation.org
Subject: - tdfxfb-fix-section-mismatch-warnings.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:28:38 -0800
Message-ID: <200802070028.m170SJCE007138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34274 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933328AbYBGAqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, adaplas@pol.net, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     tdfxfb: fix section mismatch warnings
has been removed from the -mm tree.  Its filename was
     tdfxfb-fix-section-mismatch-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tdfxfb: fix section mismatch warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

tdfxfb_setup() can be __init.  This fixes the modpost section mismatch
warnings:

WARNING: vmlinux.o(.text+0x4cff9b): Section mismatch: reference to .init.data:mode_option (between 'tdfxfb_setup' and 'getclkMHz')
WARNING: vmlinux.o(.text+0x4cffa8): Section mismatch: reference to .init.data: (between 'tdfxfb_setup' and 'getclkMHz')

[krzysztof.h1@poczta.fm: use __init, not __devinit]
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-fix-section-mismatch-warnings drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-fix-section-mismatch-warnings
+++ a/drivers/video/tdfxfb.c
@@ -1342,7 +1342,7 @@ out_err:
 }
 
 #ifndef MODULE
-static void tdfxfb_setup(char *options)
+static void __init tdfxfb_setup(char *options)
 {
 	char *this_opt;
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
kernel-doc-prevent-duplicate-description-output.patch
kernel-doc-warn-on-badly-formatted-short-description.patch
email-clientstxt-sylpheed-is-ok-at-imap.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
