From: akpm@linux-foundation.org
Subject: + w1-fix-ds28e04-build-select-crc16.patch added to -mm tree
Date: Wed, 18 Apr 2012 16:05:02 -0700
Message-ID: <20120418230502.B5B3CA0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:34038 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2DRXFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Apr 2012 19:05:05 -0400
Received: by faaa19 with SMTP id a19so385784faa.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Apr 2012 16:05:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, greg@kroah.com, zbr@ioremap.net


The patch titled
     Subject: w1: fix ds28e04 build, select CRC16
has been added to the -mm tree.  Its filename is
     w1-fix-ds28e04-build-select-crc16.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: w1: fix ds28e04 build, select CRC16

Fix build error by selecting CRC16:

ERROR: "crc16" [drivers/w1/slaves/w1_ds28e04.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/w1/slaves/Kconfig~w1-fix-ds28e04-build-select-crc16 drivers/w1/slaves/Kconfig
--- a/drivers/w1/slaves/Kconfig~w1-fix-ds28e04-build-select-crc16
+++ a/drivers/w1/slaves/Kconfig
@@ -97,6 +97,7 @@ config W1_SLAVE_DS2781
 config W1_SLAVE_DS28E04
 	tristate "4096-Bit Addressable 1-Wire EEPROM with PIO (DS28E04-100)"
 	depends on W1
+	select CRC16
 	help
 	  Say Y here if you want to use a 1-wire
 	  4kb EEPROM with PIO family device (DS28E04).
_
Subject: Subject: w1: fix ds28e04 build, select CRC16

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
kmodc-fix-kernel-doc-warning.patch
w1-fix-ds28e04-build-select-crc16.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch
kconfig-update-compression-algorithm-info.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

