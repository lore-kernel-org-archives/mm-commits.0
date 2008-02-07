From: akpm@linux-foundation.org
Subject: + apanel-fix-kconfig-dependencies.patch added to -mm tree
Date: Wed, 06 Feb 2008 17:00:43 -0800
Message-ID: <200802070100.m1710hGM008777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54424 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760697AbYBGBBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 20:01:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dtor@mail.ru, khali@linux-fr.org, shemminger@linux-foundation.org


The patch titled
     apanel: fix kconfig dependencies
has been added to the -mm tree.  Its filename is
     apanel-fix-kconfig-dependencies.patch

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
Subject: apanel: fix kconfig dependencies
From: Randy Dunlap <randy.dunlap@oracle.com>

Add I2C to config since the driver makes several i2c*() calls.

Add PCI to config because the config selects I2C_I801, which depends
on PCI, but currently config* does not follow dependency chains,
so randconfig can enable INPUT_APANEL even when PCI is not enabled,
which leads to these warnings:
linux-2.6.24-mm1/drivers/i2c/busses/i2c-i801.c:641: error: implicit declaration of function 'pci_request_region'
/linux-2.6.24-mm1/drivers/i2c/busses/i2c-i801.c:681: error: implicit declaration of function 'pci_release_region'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Stephen Hemminger <shemminger@osdl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/misc/Kconfig~apanel-fix-kconfig-dependencies drivers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~apanel-fix-kconfig-dependencies
+++ a/drivers/input/misc/Kconfig
@@ -42,7 +42,7 @@ config INPUT_M68K_BEEP
 
 config INPUT_APANEL
 	tristate "Fujitsu Lifebook Application Panel buttons"
-	depends on X86
+	depends on X86 && I2C && PCI
 	select I2C_I801
 	select INPUT_POLLDEV
 	select CHECK_SIGNATURE
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
docbook-dmapool-fix-fatal-changed-filename.patch
apanel-fix-kconfig-dependencies.patch
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
