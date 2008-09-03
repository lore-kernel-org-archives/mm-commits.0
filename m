From: akpm@linux-foundation.org
Subject: + drivers-net-hp-plus-fix-link-objects.patch added to -mm tree
Date: Tue, 02 Sep 2008 17:55:25 -0700
Message-ID: <200809030055.m830tP34021695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754405AbYICA4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 20:56:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, alan@lxorguk.ukuu.org.uk, jeff@garzik.org


The patch titled
     drivers/net/hp-plus: fix link objects
has been added to the -mm tree.  Its filename is
     drivers-net-hp-plus-fix-link-objects.patch

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
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
drivers-net-hp-plus-fix-link-objects.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
ath9k-uses-needs-led_classdev_register.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

