From: akpm@linux-foundation.org
Subject: + md-dm-mpath-hp-sw-depends-on-scsi.patch added to -mm tree
Date: Mon, 05 Nov 2007 23:48:19 -0800
Message-ID: <200711060748.lA67mJLd013001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49131 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbXKFHsZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 02:48:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, neilb@suse.de


The patch titled
     md: dm-mpath-hp-sw depends on scsi
has been added to the -mm tree.  Its filename is
     md-dm-mpath-hp-sw-depends-on-scsi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: dm-mpath-hp-sw depends on scsi
From: Paul Mundt <lethal@linux-sh.org>

With CONFIG_SCSI=n __scsi_print_sense() is never linked in.

drivers/built-in.o: In function `hp_sw_end_io':
dm-mpath-hp-sw.c:(.text+0x914f8): undefined reference to `__scsi_print_sense'

Caught with a randconfig on current git.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/Kconfig~md-dm-mpath-hp-sw-depends-on-scsi drivers/md/Kconfig
--- a/drivers/md/Kconfig~md-dm-mpath-hp-sw-depends-on-scsi
+++ a/drivers/md/Kconfig
@@ -269,7 +269,7 @@ config DM_MULTIPATH_RDAC
 
 config DM_MULTIPATH_HP
         tristate "HP MSA multipath support (EXPERIMENTAL)"
-        depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+        depends on DM_MULTIPATH && BLK_DEV_DM && SCSI && EXPERIMENTAL
         ---help---
           Multipath support for HP MSA (Active/Passive) series hardware.
 
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
git-sh.patch
git-sh64.patch
kernel-printkc-concerns-about-the-console-handover.patch
md-dm-mpath-hp-sw-depends-on-scsi.patch
use-bootmem_exclusive-for-kdump.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch
