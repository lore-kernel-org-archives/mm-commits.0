From: akpm@linux-foundation.org
Subject: - mn10300-use-the-common-ascii-hex-helpers.patch removed from -mm tree
Date: Wed, 14 May 2008 10:42:04 -0700
Message-ID: <200805141742.m4EHg4xP012749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755386AbYENRml (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 13:42:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: use the common ascii hex helpers
has been removed from the -mm tree.  Its filename was
     mn10300-use-the-common-ascii-hex-helpers.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/gdb-stub.c |  108 +++++++++++++------------------
 1 file changed, 46 insertions(+), 62 deletions(-)

diff -puN arch/mn10300/kernel/gdb-stub.c~mn10300-use-the-common-ascii-hex-helpers arch/mn10300/kernel/gdb-stub.c
--- a/arch/mn10300/kernel/gdb-stub.c~mn10300-use-the-common-ascii-hex-helpers
+++ a/arch/mn10300/kernel/gdb-stub.c
@@ -163,8 +163,6 @@ static char	input_buffer[BUFMAX];
 static char	output_buffer[BUFMAX];
 static char	trans_buffer[BUFMAX];
 
-static const char hexchars[] = "0123456789abcdef";
-
 struct gdbstub_bkpt {
 	u8	*addr;		/* address of breakpoint */
 	u8	len;		/* size of breakpoint */
@@ -363,8 +361,8 @@ static int putpacket(char *buffer)
 		}
 
 		gdbstub_io_tx_char('#');
-		gdbstub_io_tx_char(hexchars[checksum >> 4]);
-		gdbstub_io_tx_char(hexchars[checksum & 0xf]);
+		gdbstub_io_tx_char(hex_asc_hi(checksum));
+		gdbstub_io_tx_char(hex_asc_lo(checksum));
 
 	} while (gdbstub_io_rx_char(&ch, 0),
 		 ch == '-' && (gdbstub_io("### GDB Rx NAK\n"), 0),
@@ -822,8 +820,7 @@ unsigned char *mem2hex(const void *_mem,
 	if ((u32) mem & 1 && count >= 1) {
 		if (gdbstub_read_byte(mem, ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
 		mem++;
 		count--;
 	}
@@ -831,10 +828,8 @@ unsigned char *mem2hex(const void *_mem,
 	if ((u32) mem & 3 && count >= 2) {
 		if (gdbstub_read_word(mem, ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
-		*buf++ = hexchars[ch[1] >> 4];
-		*buf++ = hexchars[ch[1] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
+		buf = pack_hex_byte(buf, ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -842,14 +837,10 @@ unsigned char *mem2hex(const void *_mem,
 	while (count >= 4) {
 		if (gdbstub_read_dword(mem, ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
-		*buf++ = hexchars[ch[1] >> 4];
-		*buf++ = hexchars[ch[1] & 0xf];
-		*buf++ = hexchars[ch[2] >> 4];
-		*buf++ = hexchars[ch[2] & 0xf];
-		*buf++ = hexchars[ch[3] >> 4];
-		*buf++ = hexchars[ch[3] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
+		buf = pack_hex_byte(buf, ch[1]);
+		buf = pack_hex_byte(buf, ch[2]);
+		buf = pack_hex_byte(buf, ch[3]);
 		mem += 4;
 		count -= 4;
 	}
@@ -857,10 +848,8 @@ unsigned char *mem2hex(const void *_mem,
 	if (count >= 2) {
 		if (gdbstub_read_word(mem, ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
-		*buf++ = hexchars[ch[1] >> 4];
-		*buf++ = hexchars[ch[1] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
+		buf = pack_hex_byte(buf, ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -868,8 +857,7 @@ unsigned char *mem2hex(const void *_mem,
 	if (count >= 1) {
 		if (gdbstub_read_byte(mem, ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
 	}
 
 	*buf = 0;
@@ -1304,14 +1292,14 @@ static int gdbstub(struct pt_regs *regs,
 		*ptr++ = 'O';
 		ptr = mem2hex(title, ptr, sizeof(title) - 1, 0);
 
-		hx = hexchars[(excep & 0xf000) >> 12];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(excep & 0x0f00) >> 8];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(excep & 0x00f0) >> 4];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(excep & 0x000f)];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hex_asc_hi(excep >> 8);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(excep >> 8);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_hi(excep);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(excep);
+		ptr = pack_hex_byte(ptr, hx);
 
 		ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
 		*ptr = 0;
@@ -1322,22 +1310,22 @@ static int gdbstub(struct pt_regs *regs,
 		*ptr++ = 'O';
 		ptr = mem2hex(tbcberr, ptr, sizeof(tbcberr) - 1, 0);
 
-		hx = hexchars[(bcberr & 0xf0000000) >> 28];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(bcberr & 0x0f000000) >> 24];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(bcberr & 0x00f00000) >> 20];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(bcberr & 0x000f0000) >> 16];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(bcberr & 0x0000f000) >> 12];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(bcberr & 0x00000f00) >> 8];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(bcberr & 0x000000f0) >> 4];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(bcberr & 0x0000000f)];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hex_asc_hi(excep >> 24);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(excep >> 24);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_hi(excep >> 16);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(excep >> 16);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_hi(excep >> 8);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(excep >> 8);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_hi(excep);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(excep);
+		ptr = pack_hex_byte(ptr, hx);
 
 		ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
 		*ptr = 0;
@@ -1353,14 +1341,12 @@ static int gdbstub(struct pt_regs *regs,
 	 * Send trap type (converted to signal)
 	 */
 	*ptr++ = 'T';
-	*ptr++ = hexchars[sigval >> 4];
-	*ptr++ = hexchars[sigval & 0xf];
+	ptr = pack_hex_byte(ptr, sigval);
 
 	/*
 	 * Send Error PC
 	 */
-	*ptr++ = hexchars[GDB_REGID_PC >> 4];
-	*ptr++ = hexchars[GDB_REGID_PC & 0xf];
+	ptr = pack_hex_byte(ptr, GDB_REGID_PC);
 	*ptr++ = ':';
 	ptr = mem2hex(&regs->pc, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1368,8 +1354,7 @@ static int gdbstub(struct pt_regs *regs,
 	/*
 	 * Send frame pointer
 	 */
-	*ptr++ = hexchars[GDB_REGID_FP >> 4];
-	*ptr++ = hexchars[GDB_REGID_FP & 0xf];
+	ptr = pack_hex_byte(ptr, GDB_REGID_FP);
 	*ptr++ = ':';
 	ptr = mem2hex(&regs->a3, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1378,8 +1363,7 @@ static int gdbstub(struct pt_regs *regs,
 	 * Send stack pointer
 	 */
 	ssp = (unsigned long) (regs + 1);
-	*ptr++ = hexchars[GDB_REGID_SP >> 4];
-	*ptr++ = hexchars[GDB_REGID_SP & 0xf];
+	ptr = pack_hex_byte(ptr, GDB_REGID_SP);
 	*ptr++ = ':';
 	ptr = mem2hex(&ssp, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1399,8 +1383,8 @@ packet_waiting:
 			/* request repeat of last signal number */
 		case '?':
 			output_buffer[0] = 'S';
-			output_buffer[1] = hexchars[sigval >> 4];
-			output_buffer[2] = hexchars[sigval & 0xf];
+			output_buffer[1] = hex_asc_hi(sigval);
+			output_buffer[2] = hex_asc_lo(sigval);
 			output_buffer[3] = 0;
 			break;
 
@@ -1838,8 +1822,8 @@ void gdbstub_exit(int status)
 
 	gdbstub_busy = 1;
 	output_buffer[0] = 'W';
-	output_buffer[1] = hexchars[(status >> 4) & 0x0F];
-	output_buffer[2] = hexchars[status & 0x0F];
+	output_buffer[1] = hex_asc_hi(status);
+	output_buffer[2] = hex_asc_lo(status);
 	output_buffer[3] = 0;
 
 	gdbstub_io_tx_char('$');
@@ -1853,8 +1837,8 @@ void gdbstub_exit(int status)
 	}
 
 	gdbstub_io_tx_char('#');
-	gdbstub_io_tx_char(hexchars[checksum >> 4]);
-	gdbstub_io_tx_char(hexchars[checksum & 0xf]);
+	gdbstub_io_tx_char(hex_asc_hi(checksum));
+	gdbstub_io_tx_char(hex_asc_lo(checksum));
 
 	/* make sure the output is flushed, or else RedBoot might clobber it */
 	gdbstub_io_tx_flush();
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
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
b43-use-the-bitrev-helpers-rather-than-rolling-a-private-one.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
lib-create-common-ascii-hex-array.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
sh-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
aacraid-linitc-make-aac_show_serial_number-static.patch

