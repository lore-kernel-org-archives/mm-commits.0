From: akpm@linux-foundation.org
Subject: - kgdb-use-the-common-ascii-hex-helpers.patch removed from -mm tree
Date: Thu, 05 Jun 2008 11:21:51 -0700
Message-ID: <200806051821.m55ILpI6023258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761083AbYFESWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 14:22:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jason.wessel@windriver.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kgdb: use the common ascii hex helpers
has been removed from the -mm tree.  Its filename was
     kgdb-use-the-common-ascii-hex-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kgdb: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/kgdbts.c |    5 ++---
 kernel/kgdb.c         |   10 ++++------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff -puN drivers/misc/kgdbts.c~kgdb-use-the-common-ascii-hex-helpers drivers/misc/kgdbts.c
--- a/drivers/misc/kgdbts.c~kgdb-use-the-common-ascii-hex-helpers
+++ a/drivers/misc/kgdbts.c
@@ -119,7 +119,6 @@
 	} while (0)
 #define MAX_CONFIG_LEN		40
 
-static const char hexchars[] = "0123456789abcdef";
 static struct kgdb_io kgdbts_io_ops;
 static char get_buf[BUFMAX];
 static int get_buf_cnt;
@@ -619,8 +618,8 @@ static void fill_get_buf(char *buf)
 		count++;
 	}
 	strcat(get_buf, "#");
-	get_buf[count + 2] = hexchars[checksum >> 4];
-	get_buf[count + 3] = hexchars[checksum & 0xf];
+	get_buf[count + 2] = hex_asc_hi(checksum);
+	get_buf[count + 3] = hex_asc_lo(checksum);
 	get_buf[count + 4] = '\0';
 	v2printk("get%i: %s\n", ts.idx, get_buf);
 }
diff -puN kernel/kgdb.c~kgdb-use-the-common-ascii-hex-helpers kernel/kgdb.c
--- a/kernel/kgdb.c~kgdb-use-the-common-ascii-hex-helpers
+++ a/kernel/kgdb.c
@@ -228,8 +228,6 @@ void __weak kgdb_disable_hw_debug(struct
  * GDB remote protocol parser:
  */
 
-static const char	hexchars[] = "0123456789abcdef";
-
 static int hex(char ch)
 {
 	if ((ch >= 'a') && (ch <= 'f'))
@@ -317,8 +315,8 @@ static void put_packet(char *buffer)
 		}
 
 		kgdb_io_ops->write_char('#');
-		kgdb_io_ops->write_char(hexchars[checksum >> 4]);
-		kgdb_io_ops->write_char(hexchars[checksum & 0xf]);
+		kgdb_io_ops->write_char(hex_asc_hi(checksum));
+		kgdb_io_ops->write_char(hex_asc_lo(checksum));
 		if (kgdb_io_ops->flush)
 			kgdb_io_ops->flush();
 
@@ -479,8 +477,8 @@ static void error_packet(char *pkt, int 
 {
 	error = -error;
 	pkt[0] = 'E';
-	pkt[1] = hexchars[(error / 10)];
-	pkt[2] = hexchars[(error % 10)];
+	pkt[1] = hex_asc[(error / 10)];
+	pkt[2] = hex_asc[(error % 10)];
 	pkt[3] = '\0';
 }
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

lib-export-bitrev16.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
bluetooth-hci_bcspc-small-cleanups-api-users.patch
bluetooth-hci_bcspc-small-cleanups-api-users-fix.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
usb-cp2101c-fix-sparse-signedness-mismatch-warnings.patch
usb-speedtchc-fix-sparse-shadowed-variable-warning.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

