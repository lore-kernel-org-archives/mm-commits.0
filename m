From: akpm@linux-foundation.org
Subject: + uwb-fix-kconfig-causing-undefined-references.patch added to -mm tree
Date: Wed, 30 Apr 2008 15:12:27 -0700
Message-ID: <200804302212.m3UMCR5r006111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761704AbYD3WMj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 18:12:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com


The patch titled
     uwb: fix Kconfig causing undefined references
has been added to the -mm tree.  Its filename is
     uwb-fix-kconfig-causing-undefined-references.patch

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
Subject: uwb: fix Kconfig causing undefined references
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix UWB kconfig so that function reference problems are not generated.

next-20080430/drivers/uwb/whc-rc.c:478: undefined reference to `hwarc_filter_event'
next-20080430/drivers/uwb/whc-rc.c:478: undefined reference to `hwarc_filter_cmd'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/uwb/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/uwb/Kconfig~uwb-fix-kconfig-causing-undefined-references drivers/uwb/Kconfig
--- a/drivers/uwb/Kconfig~uwb-fix-kconfig-causing-undefined-references
+++ a/drivers/uwb/Kconfig
@@ -43,6 +43,7 @@ if UWB
 config UWB_WHCI
 	tristate "UWB Radio Control driver for WHCI-compliant cards"
 	depends on PCI
+	depends on UWB_HWA
 	help
 	  This driver enables the radio controller for WHCI cards.
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
basic-braille-screen-reader-support.patch
add-macros-similar-to-min-max-min_t-max_t.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
sysfs-sysfs_update_group-stub-for-config_sysfs=n.patch
docbook-fix-fatal-rapidio-yet-again-and-more-to-come.patch
docbook-fix-vmalloc-missing-parameter-notation.patch
pnp-fix-printk-format-warnings.patch
pnp-fix-printk-format-warnings-fix.patch
pnp-fix-printk-format-warnings-fix-checkpatch-fixes.patch
x86-fix-setup-printk-format-warning.patch
rapidio-fix-docbook-references.patch
rapidio-fix-kernel-doc-problems.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
fix-gregkh-usb-usb-isp1760-hcd-driver.patch
uwb-fix-kconfig-causing-undefined-references.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
profile-likely-unlikely-macros.patch

