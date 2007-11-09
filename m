From: akpm@linux-foundation.org
Subject: - md-dm-mpath-hp-sw-depends-on-scsi.patch removed from -mm tree
Date: Fri, 09 Nov 2007 11:13:45 -0800
Message-ID: <200711091913.lA9JDjwX028054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50285 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755299AbXKITQx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:16:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: dm-mpath-hp-sw depends on scsi
has been removed from the -mm tree.  Its filename was
     md-dm-mpath-hp-sw-depends-on-scsi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

lib-move-bitmapo-from-lib-y-to-obj-y.patch
git-libata-all.patch
git-sh.patch
kernel-printkc-concerns-about-the-console-handover.patch
use-bootmem_exclusive-for-kdump.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch
