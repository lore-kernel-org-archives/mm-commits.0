From: akpm@linux-foundation.org
Subject: - frv-use-the-common-ascii-hex-helpers.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:15:37 -0700
Message-ID: <200807262115.m6QLFbQb019754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757665AbYGZVP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:15:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: use the common ascii hex helpers
has been removed from the -mm tree.  Its filename was
     frv-use-the-common-ascii-hex-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/gdb-stub.c |   88 ++++++++++++++---------------------
 1 file changed, 36 insertions(+), 52 deletions(-)

diff -puN arch/frv/kernel/gdb-stub.c~frv-use-the-common-ascii-hex-helpers arch/frv/kernel/gdb-stub.c
--- a/arch/frv/kernel/gdb-stub.c~frv-use-the-common-ascii-hex-helpers
+++ a/arch/frv/kernel/gdb-stub.c
@@ -182,8 +182,6 @@ extern volatile u32 __attribute__((secti
 static char	input_buffer[BUFMAX];
 static char	output_buffer[BUFMAX];
 
-static const char hexchars[] = "0123456789abcdef";
-
 static const char *regnames[] = {
 	"PSR ", "ISR ", "CCR ", "CCCR",
 	"LR  ", "LCR ", "PC  ", "_stt",
@@ -383,8 +381,8 @@ static int gdbstub_send_packet(char *buf
 		}
 
 		gdbstub_tx_char('#');
-		gdbstub_tx_char(hexchars[checksum >> 4]);
-		gdbstub_tx_char(hexchars[checksum & 0xf]);
+		gdbstub_tx_char(hex_asc_hi(checksum));
+		gdbstub_tx_char(hex_asc_lo(checksum));
 
 	} while (gdbstub_rx_char(&ch,0),
 #ifdef GDBSTUB_DEBUG_PROTOCOL
@@ -674,8 +672,7 @@ static unsigned char *mem2hex(const void
 	if ((uint32_t)mem&1 && count>=1) {
 		if (!gdbstub_read_byte(mem,ch))
 			return NULL;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
 		mem++;
 		count--;
 	}
@@ -683,10 +680,8 @@ static unsigned char *mem2hex(const void
 	if ((uint32_t)mem&3 && count>=2) {
 		if (!gdbstub_read_word(mem,(uint16_t *)ch))
 			return NULL;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
-		*buf++ = hexchars[ch[1] >> 4];
-		*buf++ = hexchars[ch[1] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
+		buf = pack_hex_byte(buf, ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -694,14 +689,10 @@ static unsigned char *mem2hex(const void
 	while (count>=4) {
 		if (!gdbstub_read_dword(mem,(uint32_t *)ch))
 			return NULL;
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
@@ -709,10 +700,8 @@ static unsigned char *mem2hex(const void
 	if (count>=2) {
 		if (!gdbstub_read_word(mem,(uint16_t *)ch))
 			return NULL;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
-		*buf++ = hexchars[ch[1] >> 4];
-		*buf++ = hexchars[ch[1] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
+		buf = pack_hex_byte(buf, ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -720,8 +709,7 @@ static unsigned char *mem2hex(const void
 	if (count>=1) {
 		if (!gdbstub_read_byte(mem,ch))
 			return NULL;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
 	}
 
 	*buf = 0;
@@ -1471,22 +1459,22 @@ void gdbstub(int sigval)
 		*ptr++ = 'O';
 		ptr = mem2hex(title, ptr, sizeof(title) - 1,0);
 
-		hx = hexchars[(brr & 0xf0000000) >> 28];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(brr & 0x0f000000) >> 24];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(brr & 0x00f00000) >> 20];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(brr & 0x000f0000) >> 16];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(brr & 0x0000f000) >> 12];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(brr & 0x00000f00) >> 8];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(brr & 0x000000f0) >> 4];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(brr & 0x0000000f)];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hex_asc_hi(brr >> 24);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(brr >> 24);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_hi(brr >> 16);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(brr >> 16);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_hi(brr >> 8);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(brr >> 8);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_hi(brr);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(brr);
+		ptr = pack_hex_byte(ptr, hx);
 
 		ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
 		*ptr = 0;
@@ -1500,12 +1488,10 @@ void gdbstub(int sigval)
 
 	/* Send trap type (converted to signal) */
 	*ptr++ = 'T';
-	*ptr++ = hexchars[sigval >> 4];
-	*ptr++ = hexchars[sigval & 0xf];
+	ptr = pack_hex_byte(ptr, sigval);
 
 	/* Send Error PC */
-	*ptr++ = hexchars[GDB_REG_PC >> 4];
-	*ptr++ = hexchars[GDB_REG_PC & 0xf];
+	ptr = pack_hex_byte(ptr, GDB_REG_PC);
 	*ptr++ = ':';
 	ptr = mem2hex(&__debug_frame->pc, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1513,8 +1499,7 @@ void gdbstub(int sigval)
 	/*
 	 * Send frame pointer
 	 */
-	*ptr++ = hexchars[GDB_REG_FP >> 4];
-	*ptr++ = hexchars[GDB_REG_FP & 0xf];
+	ptr = pack_hex_byte(ptr, GDB_REG_FP);
 	*ptr++ = ':';
 	ptr = mem2hex(&__debug_frame->fp, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1522,8 +1507,7 @@ void gdbstub(int sigval)
 	/*
 	 * Send stack pointer
 	 */
-	*ptr++ = hexchars[GDB_REG_SP >> 4];
-	*ptr++ = hexchars[GDB_REG_SP & 0xf];
+	ptr = pack_hex_byte(ptr, GDB_REG_SP);
 	*ptr++ = ':';
 	ptr = mem2hex(&__debug_frame->sp, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1548,8 +1532,8 @@ void gdbstub(int sigval)
 			/* request repeat of last signal number */
 		case '?':
 			output_buffer[0] = 'S';
-			output_buffer[1] = hexchars[sigval >> 4];
-			output_buffer[2] = hexchars[sigval & 0xf];
+			output_buffer[1] = hex_asc_hi(sigval);
+			output_buffer[2] = hex_asc_lo(sigval);
 			output_buffer[3] = 0;
 			break;
 
@@ -2059,8 +2043,8 @@ void gdbstub_exit(int status)
 	}
 
 	gdbstub_tx_char('#');
-	gdbstub_tx_char(hexchars[checksum >> 4]);
-	gdbstub_tx_char(hexchars[checksum & 0xf]);
+	gdbstub_tx_char(hex_asc_hi(checksum));
+	gdbstub_tx_char(hex_asc_lo(checksum));
 
 	/* make sure the output is flushed, or else RedBoot might clobber it */
 	gdbstub_tx_char('-');
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

