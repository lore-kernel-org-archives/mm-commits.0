From: akpm@linux-foundation.org
Subject: + scsi-megaraid-fix-format-overflow-warning.patch added to -mm
 tree
Date: Wed, 19 Jul 2017 14:50:14 -0700
Message-ID: <596fd416.VmNDrFi4oebxckpy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34104 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755060AbdGSVuP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 17:50:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: megaraid: fix format-overflow warning
has been added to the -mm tree.  Its filename is
     scsi-megaraid-fix-format-overflow-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scsi-megaraid-fix-format-overflow-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scsi-megaraid-fix-format-overflow-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: scsi: megaraid: fix format-overflow warning

gcc-7 complains that the firmware version strings might overflow
for some values:

drivers/scsi/megaraid.c: In function 'megaraid_probe_one':
drivers/scsi/megaraid.c:314:33: error: '%d' directive writing between 1 and 2 bytes into a region of size between 1 and 2 [-Werror=format-overflow=]
drivers/scsi/megaraid.c:314:33: note: directive argument in the range [0, 15]
drivers/scsi/megaraid.c:314:3: note: 'sprintf' output between 7 and 9 bytes into a destination of size 7
drivers/scsi/megaraid.c:320:35: error: '%d' directive writing between 1 and 2 bytes into a region of size between 1 and 2 [-Werror=format-overflow=]
drivers/scsi/megaraid.c:320:35: note: directive argument in the range [0, 15]
drivers/scsi/megaraid.c:320:3: note: 'sprintf' output between 7 and 9 bytes into a destination of size 7

This makes the code use a truncating snprintf() instead, which shuts
up that warning.

Link: http://lkml.kernel.org/r/20170714120720.906842-3-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/megaraid.c~scsi-megaraid-fix-format-overflow-warning drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~scsi-megaraid-fix-format-overflow-warning
+++ a/drivers/scsi/megaraid.c
@@ -311,13 +311,15 @@ mega_query_adapter(adapter_t *adapter)
 	   right 8 bits making them zero. This 0 value was hardcoded to fix
 	   sparse warnings. */
 	if (adapter->product_info.subsysvid == PCI_VENDOR_ID_HP) {
-		sprintf (adapter->fw_version, "%c%d%d.%d%d",
+		snprintf(adapter->fw_version, sizeof(adapter->fw_version),
+			 "%c%d%d.%d%d",
 			 adapter->product_info.fw_version[2],
 			 0,
 			 adapter->product_info.fw_version[1] & 0x0f,
 			 0,
 			 adapter->product_info.fw_version[0] & 0x0f);
-		sprintf (adapter->bios_version, "%c%d%d.%d%d",
+		snprintf(adapter->bios_version, sizeof(adapter->fw_version),
+			 "%c%d%d.%d%d",
 			 adapter->product_info.bios_version[2],
 			 0,
 			 adapter->product_info.bios_version[1] & 0x0f,
_

Patches currently in -mm which might be from arnd@arndb.de are

kbuild-disable-wformat-truncation-warnings-by-default.patch
scsi-megaraid-fix-format-overflow-warning.patch
scsi-mpt3sas-fix-format-overflow-warning.patch
scsi-fusion-fix-string-overflow-warning.patch
scsi-gdth-avoid-buffer-overflow-warning.patch
scsi-fnic-fix-format-string-overflow-warning.patch
scsi-gdth-increase-the-procfs-event-buffer-size.patch
usbvision-i2c-fix-format-overflow-warning.patch
hwmon-applesmc-fix-format-string-overflow.patch
x86-intel-mid-fix-a-format-string-overflow-warning.patch
platform-x86-alienware-wmi-fix-format-string-overflow-warning.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

