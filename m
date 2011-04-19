From: akpm@linux-foundation.org
Subject: + drivers-scsi-megaraidc-fix-sparse-warnings.patch added to -mm tree
Date: Tue, 19 Apr 2011 15:01:14 -0700
Message-ID: <201104192201.p3JM1EVx027859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493Ab1DSWBV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 18:01:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, megaraidlinux@lsi.com, viro@ZenIV.linux.org.uk


The patch titled
     drivers/scsi/megaraid.c: fix sparse warnings
has been added to the -mm tree.  Its filename is
     drivers-scsi-megaraidc-fix-sparse-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/megaraid.c: fix sparse warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse warnings of right shift bigger than source value size:

drivers/scsi/megaraid.c:311:65: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:313:65: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:317:67: warning: right shift by bigger than source value
drivers/scsi/megaraid.c:319:67: warning: right shift by bigger than source value

Patch suggestion from email by Al Viro:

"Since both are claimed to be strings, I really suspect that this >> 8 is
misspelled >> 4 and they have a character followed by pair of two-digit
packed decimals in there..."

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-warnings drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-warnings
+++ a/drivers/scsi/megaraid.c
@@ -310,15 +310,15 @@ mega_query_adapter(adapter_t *adapter)
 	if (adapter->product_info.subsysvid == HP_SUBSYS_VID) {
 		sprintf (adapter->fw_version, "%c%d%d.%d%d",
 			 adapter->product_info.fw_version[2],
-			 adapter->product_info.fw_version[1] >> 8,
+			 adapter->product_info.fw_version[1] >> 4,
 			 adapter->product_info.fw_version[1] & 0x0f,
-			 adapter->product_info.fw_version[0] >> 8,
+			 adapter->product_info.fw_version[0] >> 4,
 			 adapter->product_info.fw_version[0] & 0x0f);
 		sprintf (adapter->bios_version, "%c%d%d.%d%d",
 			 adapter->product_info.bios_version[2],
-			 adapter->product_info.bios_version[1] >> 8,
+			 adapter->product_info.bios_version[1] >> 4,
 			 adapter->product_info.bios_version[1] & 0x0f,
-			 adapter->product_info.bios_version[0] >> 8,
+			 adapter->product_info.bios_version[0] >> 4,
 			 adapter->product_info.bios_version[0] & 0x0f);
 	} else {
 		memcpy(adapter->fw_version,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
drivers-staging-olpc_dcon-olpc_dcon_xo_1c-needs-delayh.patch
drivers-leds-leds-pca9532c-add-gpio-capability-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

