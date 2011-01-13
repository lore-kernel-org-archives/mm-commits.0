From: akpm@linux-foundation.org
Subject: [folded] w1-ds2423-counter-driver-and-documentation-fix.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:28:49 -0800
Message-ID: <201101130028.p0D0SneH012561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542Ab1AMA3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:29:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, johnpol@2ka.mipt.ru, lamikr@pilppa.org, mm-commits@vger.kernel.org


The patch titled
     w1: fix ds2423 build, needs to select CRC16
has been removed from the -mm tree.  Its filename was
     w1-ds2423-counter-driver-and-documentation-fix.patch

This patch was dropped because it was folded into w1-ds2423-counter-driver-and-documentation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: fix ds2423 build, needs to select CRC16
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix w1_ds2423 build:  needs to select CRC16.

w1_ds2423.c:(.text+0x9971d): undefined reference to `crc16'
w1_ds2423.c:(.text+0x9973a): undefined reference to `crc16'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mika Laitio <lamikr@pilppa.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/w1/slaves/Kconfig~w1-ds2423-counter-driver-and-documentation-fix drivers/w1/slaves/Kconfig
--- a/drivers/w1/slaves/Kconfig~w1-ds2423-counter-driver-and-documentation-fix
+++ a/drivers/w1/slaves/Kconfig
@@ -18,6 +18,7 @@ config W1_SLAVE_SMEM
 
 config W1_SLAVE_DS2423
 	tristate "Counter 1-wire device (DS2423)"
+	select CRC16
 	help
 	  If you enable this you can read the counter values available
 	  in the DS2423 chipset from the w1_slave file under the
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
uml-mmapper_kern-needs-module_license.patch
kernel-clean-up-use_generic_smp_helpers.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
gpio_rdc321x-select-mfd_support-to-squelch-kconfig-warning.patch
gpio_vx855-eliminate-kconfig-dependency-warning.patch
documentation-email-clientstxt-warn-about-word-wrap-bug-in-kmail.patch
update-thunderbird-docs-with-wordwrap-plugin.patch
w1-ds2423-counter-driver-and-documentation.patch

