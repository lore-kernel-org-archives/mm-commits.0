From: akpm@linux-foundation.org
Subject: - kgdb-use-the-common-ascii-hex-helpers.patch removed from -mm tree
Date: Fri, 02 May 2008 17:08:36 -0700
Message-ID: <200805030008.m4308akH022239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964922AbYECAIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 20:08:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kgdb: use the common ascii hex helpers
has been removed from the -mm tree.  Its filename was
     kgdb-use-the-common-ascii-hex-helpers.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kgdb: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/kgdbts.c |    5 ++---
 kernel/kgdb.c         |   36 +++++++++++-------------------------
 2 files changed, 13 insertions(+), 28 deletions(-)

diff -puN drivers/misc/kgdbts.c~kgdb-use-the-common-ascii-hex-helpers drivers/misc/kgdbts.c
--- a/drivers/misc/kgdbts.c~kgdb-use-the-common-ascii-hex-helpers
+++ a/drivers/misc/kgdbts.c
@@ -118,7 +118,6 @@
 	} while (0)
 #define MAX_CONFIG_LEN		40
 
-static const char hexchars[] = "0123456789abcdef";
 static struct kgdb_io kgdbts_io_ops;
 static char get_buf[BUFMAX];
 static int get_buf_cnt;
@@ -618,8 +617,8 @@ static void fill_get_buf(char *buf)
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
@@ -226,20 +226,6 @@ void __weak kgdb_disable_hw_debug(struct
 /*
  * GDB remote protocol parser:
  */
-
-static const char	hexchars[] = "0123456789abcdef";
-
-static int hex(char ch)
-{
-	if ((ch >= 'a') && (ch <= 'f'))
-		return ch - 'a' + 10;
-	if ((ch >= '0') && (ch <= '9'))
-		return ch - '0';
-	if ((ch >= 'A') && (ch <= 'F'))
-		return ch - 'A' + 10;
-	return -1;
-}
-
 /* scan for the sequence $<data>#<checksum> */
 static void get_packet(char *buffer)
 {
@@ -276,8 +262,8 @@ static void get_packet(char *buffer)
 		buffer[count] = 0;
 
 		if (ch == '#') {
-			xmitcsum = hex(kgdb_io_ops->read_char()) << 4;
-			xmitcsum += hex(kgdb_io_ops->read_char());
+			xmitcsum = hex_to_int(kgdb_io_ops->read_char()) << 4;
+			xmitcsum += hex_to_int(kgdb_io_ops->read_char());
 
 			if (checksum != xmitcsum)
 				/* failed checksum */
@@ -316,8 +302,8 @@ static void put_packet(char *buffer)
 		}
 
 		kgdb_io_ops->write_char('#');
-		kgdb_io_ops->write_char(hexchars[checksum >> 4]);
-		kgdb_io_ops->write_char(hexchars[checksum & 0xf]);
+		kgdb_io_ops->write_char(hex_asc_hi(checksum));
+		kgdb_io_ops->write_char(hex_asc_lo(checksum));
 		if (kgdb_io_ops->flush)
 			kgdb_io_ops->flush();
 
@@ -348,8 +334,8 @@ static void put_packet(char *buffer)
 
 static char *pack_hex_byte(char *pkt, u8 byte)
 {
-	*pkt++ = hexchars[byte >> 4];
-	*pkt++ = hexchars[byte & 0xf];
+	*pkt++ = hex_asc_hi(byte);
+	*pkt++ = hex_asc_lo(byte);
 
 	return pkt;
 }
@@ -427,8 +413,8 @@ int kgdb_hex2mem(char *buf, char *mem, i
 	tmp_hex = tmp_raw - 1;
 	while (tmp_hex >= buf) {
 		tmp_raw--;
-		*tmp_raw = hex(*tmp_hex--);
-		*tmp_raw |= hex(*tmp_hex--) << 4;
+		*tmp_raw = hex_to_int(*tmp_hex--);
+		*tmp_raw |= hex_to_int(*tmp_hex--) << 4;
 	}
 
 	return probe_kernel_write(mem, tmp_raw, count);
@@ -446,7 +432,7 @@ int kgdb_hex2long(char **ptr, long *long
 	*long_val = 0;
 
 	while (**ptr) {
-		hex_val = hex(**ptr);
+		hex_val = hex_to_int(**ptr);
 		if (hex_val < 0)
 			break;
 
@@ -486,8 +472,8 @@ static void error_packet(char *pkt, int 
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

origin.patch
linux-next.patch
misc-fix-integer-as-null-pointer-warnings.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
input-ff-memlessc-use-clamp_val-macro.patch
ata-remove-fit-macro.patch
ide-eliminate-fit-macro.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
ide-use-get_unaligned_-helpers.patch
git-mips.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
net-use-get-put_unaligned_-helpers.patch
bluetooth-use-get-put_unaligned_-helpers.patch
irda-use-get_unaligned_-helpers.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
block-use-get_unaligned_-helpers.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
usb-use-get_unaligned_-helpers.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
wireless-use-get-put_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
kgdb-use-the-common-ascii-hex-helpers.patch
frv-gdb-stubc-use-the-common-ascii-hex-helpers.patch
mn10300-gdb-stubc-use-the-common-ascii-hex-helpers.patch
mips-gdb-stubc-use-the-common-ascii-hex-helpers.patch
sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
isdn-use-the-common-ascii-hex-helpers.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch

