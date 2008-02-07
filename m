From: akpm@linux-foundation.org
Subject: - sound-oss-sb_commonc-fix-casting-warning.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:20:46 -0800
Message-ID: <200802070020.m170KRZX006135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57129 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933999AbYBGAVj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:21:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, jgarzik@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sound/oss/sb_common.c: fix casting warning
has been removed from the -mm tree.  Its filename was
     sound-oss-sb_commonc-fix-casting-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sound/oss/sb_common.c: fix casting warning
From: Jeff Garzik <jeff@garzik.org>

sound/oss/sb_common.c: In function 'probe_sbmpu':
sound/oss/sb_common.c:1231: warning: cast to pointer from integer of different size

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/sb_common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN sound/oss/sb_common.c~sound-oss-sb_commonc-fix-casting-warning sound/oss/sb_common.c
--- a/sound/oss/sb_common.c~sound-oss-sb_commonc-fix-casting-warning
+++ a/sound/oss/sb_common.c
@@ -1228,7 +1228,8 @@ int probe_sbmpu(struct address_info *hw_
 		}
 		attach_mpu401(hw_config, owner);
 		if (last_sb->irq == -hw_config->irq)
-			last_sb->midi_irq_cookie=(void *)hw_config->slots[1];
+			last_sb->midi_irq_cookie =
+				(void *)(long) hw_config->slots[1];
 		return 1;
 	}
 #endif
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-libata-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch
i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
i8k-inspiron-e1705-fix.patch
smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
