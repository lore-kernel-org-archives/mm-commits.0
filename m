From: akpm@linux-foundation.org
Subject: + drivers-s390-move-static-and-inline-before-return-type.patch
 added to -mm tree
Date: Wed, 05 Jul 2017 13:45:26 -0700
Message-ID: <595d4fe6.D6pYYkRH9+Mvl6qN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753454AbdGEUpc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 16:45:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, heiko.carstens@de.ibm.com, jwi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, ubraun@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers: s390: move static and inline before return type
has been added to the -mm tree.  Its filename is
     drivers-s390-move-static-and-inline-before-return-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-s390-move-static-and-inline-before-return-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-s390-move-static-and-inline-before-return-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: drivers: s390: move static and inline before return type

Make the code like the rest of the kernel.

Link: http://lkml.kernel.org/r/3f980cd89084ae09716353aba3171e4b3815e690.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Julian Wiedmann <jwi@linux.vnet.ibm.com>
Cc: Ursula Braun <ubraun@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/net/ctcm_main.c    |    2 +-
 drivers/s390/net/qeth_l3_main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/s390/net/ctcm_main.c~drivers-s390-move-static-and-inline-before-return-type drivers/s390/net/ctcm_main.c
--- a/drivers/s390/net/ctcm_main.c~drivers-s390-move-static-and-inline-before-return-type
+++ a/drivers/s390/net/ctcm_main.c
@@ -1115,7 +1115,7 @@ static const struct net_device_ops ctcm_
 	.ndo_start_xmit		= ctcmpc_tx,
 };
 
-void static ctcm_dev_setup(struct net_device *dev)
+static void ctcm_dev_setup(struct net_device *dev)
 {
 	dev->type = ARPHRD_SLIP;
 	dev->tx_queue_len = 100;
diff -puN drivers/s390/net/qeth_l3_main.c~drivers-s390-move-static-and-inline-before-return-type drivers/s390/net/qeth_l3_main.c
--- a/drivers/s390/net/qeth_l3_main.c~drivers-s390-move-static-and-inline-before-return-type
+++ a/drivers/s390/net/qeth_l3_main.c
@@ -2408,7 +2408,7 @@ static int qeth_l3_do_ioctl(struct net_d
 	return rc;
 }
 
-int inline qeth_l3_get_cast_type(struct qeth_card *card, struct sk_buff *skb)
+inline int qeth_l3_get_cast_type(struct qeth_card *card, struct sk_buff *skb)
 {
 	int cast_type = RTN_UNSPEC;
 	struct neighbour *n = NULL;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
checkpatch-improve-tests-for-multiple-line-function-definitions.patch
checkpatch-improve-macro-reuse-test.patch
checkpatch-improve-multi-line-alignment-test.patch
checkpatch-improve-the-storage_class-test.patch
arm-kvm-move-asmlinkage-before-type.patch
arm-hp-jornada-7xx-move-inline-before-return-type.patch
cris-gpio-move-inline-before-return-type.patch
frv-tlbflush-move-asmlinkage-before-return-type.patch
ia64-move-inline-before-return-type.patch
ia64-sn-pci-move-inline-before-type.patch
m68k-coldfire-move-inline-before-return-type.patch
mips-smp-move-asmlinkage-before-return-type.patch
sh-move-inline-before-return-type.patch
x86-efi-move-asmlinkage-before-return-type.patch
drivers-s390-move-static-and-inline-before-return-type.patch
drivers-tty-serial-move-inline-before-return-type.patch
usb-serial-safe_serial-move-__inline__-before-return-type.patch
video-fbdev-intelfb-move-inline-before-return-type.patch
video-fbdev-omap-move-inline-before-return-type.patch
arm-samsung-usb-ohci-move-inline-before-return-type.patch
alsa-opl4-move-inline-before-return-type.patch

