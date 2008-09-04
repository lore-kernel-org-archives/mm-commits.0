From: akpm@linux-foundation.org
Subject: - drivers-net-hp-plus-fix-link-objects.patch removed from -mm tree
Date: Thu, 04 Sep 2008 12:56:21 -0700
Message-ID: <200809041956.m84JuLlG027872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754711AbYIDT5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 15:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, alan@lxorguk.ukuu.org.uk, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/hp-plus: fix link objects
has been removed from the -mm tree.  Its filename was
     drivers-net-hp-plus-fix-link-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/hp-plus: fix link objects
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix hp-plus Makefile object file:

drivers/built-in.o: In function `hpp_open':
hp-plus.c:(.text+0xaf445): undefined reference to `ei_interrupt'
hp-plus.c:(.text+0xaf4ac): undefined reference to `ei_open'
drivers/built-in.o: In function `hpp_close':
hp-plus.c:(.text+0xaf59d): undefined reference to `ei_close'
drivers/built-in.o: In function `hpp_probe1':
hp-plus.c:(.init.text+0x7314): undefined reference to `ei_poll'
drivers/built-in.o: In function `hp_plus_probe':
(.init.text+0x7407): undefined reference to `__alloc_ei_netdev'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/Makefile~drivers-net-hp-plus-fix-link-objects drivers/net/Makefile
--- a/drivers/net/Makefile~drivers-net-hp-plus-fix-link-objects
+++ a/drivers/net/Makefile
@@ -110,7 +110,7 @@ obj-$(CONFIG_EL2) += 3c503.o 8390p.o
 obj-$(CONFIG_NE2000) += ne.o 8390p.o
 obj-$(CONFIG_NE2_MCA) += ne2.o 8390p.o
 obj-$(CONFIG_HPLAN) += hp.o 8390p.o
-obj-$(CONFIG_HPLAN_PLUS) += hp-plus.o 8390p.o
+obj-$(CONFIG_HPLAN_PLUS) += hp-plus.o 8390.o
 obj-$(CONFIG_ULTRA) += smc-ultra.o 8390.o
 obj-$(CONFIG_ULTRAMCA) += smc-mca.o 8390.o
 obj-$(CONFIG_ULTRA32) += smc-ultra32.o 8390.o
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
hid-fix-gyration-build-error.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
ath9k-uses-needs-led_classdev_register.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

