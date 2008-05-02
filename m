From: akpm@linux-foundation.org
Subject: + mn10300-gdb-stubc-use-the-common-ascii-hex-helpers.patch added to -mm tree
Date: Fri, 02 May 2008 15:56:44 -0700
Message-ID: <200805022256.m42Mui9k019295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934639AbYEBW5Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 18:57:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     mn10300: gdb-stub.c use the common ascii hex helpers
has been added to the -mm tree.  Its filename is
     mn10300-gdb-stubc-use-the-common-ascii-hex-helpers.patch

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
Subject: mn10300: gdb-stub.c use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/gdb-stub.c |  183 ++++++++++++++-----------------
 1 file changed, 83 insertions(+), 100 deletions(-)

diff -puN arch/mn10300/kernel/gdb-stub.c~mn10300-gdb-stubc-use-the-common-ascii-hex-helpers arch/mn10300/kernel/gdb-stub.c
--- a/arch/mn10300/kernel/gdb-stub.c~mn10300-gdb-stubc-use-the-common-ascii-hex-helpers
+++ a/arch/mn10300/kernel/gdb-stub.c
@@ -163,8 +163,6 @@ static char	input_buffer[BUFMAX];
 static char	output_buffer[BUFMAX];
 static char	trans_buffer[BUFMAX];
 
-static const char hexchars[] = "0123456789abcdef";
-
 struct gdbstub_bkpt {
 	u8	*addr;		/* address of breakpoint */
 	u8	len;		/* size of breakpoint */
@@ -179,27 +177,12 @@ static struct gdbstub_bkpt gdbstub_bkpts
 static void getpacket(char *buffer);
 static int putpacket(char *buffer);
 static int computeSignal(enum exception_code excep);
-static int hex(unsigned char ch);
 static int hexToInt(char **ptr, int *intValue);
 static unsigned char *mem2hex(const void *mem, char *buf, int count,
 			      int may_fault);
 static const char *hex2mem(const char *buf, void *_mem, int count,
 			   int may_fault);
 
-/*
- * Convert ch from a hex digit to an int
- */
-static int hex(unsigned char ch)
-{
-	if (ch >= 'a' && ch <= 'f')
-		return ch - 'a' + 10;
-	if (ch >= '0' && ch <= '9')
-		return ch - '0';
-	if (ch >= 'A' && ch <= 'F')
-		return ch - 'A' + 10;
-	return -1;
-}
-
 #ifdef CONFIG_GDBSTUB_DEBUGGING
 
 void debug_to_serial(const char *p, int n)
@@ -286,12 +269,12 @@ static void getpacket(char *buffer)
 		ret = gdbstub_io_rx_char(&ch, 0);
 		if (ret < 0)
 			error = ret;
-		xmitcsum = hex(ch) << 4;
+		xmitcsum = hex_to_int(ch) << 4;
 
 		ret = gdbstub_io_rx_char(&ch, 0);
 		if (ret < 0)
 			error = ret;
-		xmitcsum |= hex(ch);
+		xmitcsum |= hex_to_int(ch);
 
 		if (error) {
 			if (error == -EIO)
@@ -363,8 +346,8 @@ static int putpacket(char *buffer)
 		}
 
 		gdbstub_io_tx_char('#');
-		gdbstub_io_tx_char(hexchars[checksum >> 4]);
-		gdbstub_io_tx_char(hexchars[checksum & 0xf]);
+		gdbstub_io_tx_char(hex_asc_hi(checksum));
+		gdbstub_io_tx_char(hex_asc_lo(checksum));
 
 	} while (gdbstub_io_rx_char(&ch, 0),
 		 ch == '-' && (gdbstub_io("### GDB Rx NAK\n"), 0),
@@ -394,7 +377,7 @@ static int hexToInt(char **ptr, int *int
 	*intValue = 0;
 
 	while (**ptr) {
-		hexValue = hex(**ptr);
+		hexValue = hex_to_int(**ptr);
 		if (hexValue < 0)
 			break;
 
@@ -822,8 +805,8 @@ unsigned char *mem2hex(const void *_mem,
 	if ((u32) mem & 1 && count >= 1) {
 		if (gdbstub_read_byte(mem, ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
+		*buf++ = hex_asc_hi(ch[0]);
+		*buf++ = hex_asc_lo(ch[0]);
 		mem++;
 		count--;
 	}
@@ -831,10 +814,10 @@ unsigned char *mem2hex(const void *_mem,
 	if ((u32) mem & 3 && count >= 2) {
 		if (gdbstub_read_word(mem, ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
-		*buf++ = hexchars[ch[1] >> 4];
-		*buf++ = hexchars[ch[1] & 0xf];
+		*buf++ = hex_asc_hi(ch[0]);
+		*buf++ = hex_asc_lo(ch[0]);
+		*buf++ = hex_asc_hi(ch[1]);
+		*buf++ = hex_asc_lo(ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -842,14 +825,14 @@ unsigned char *mem2hex(const void *_mem,
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
+		*buf++ = hex_asc_hi(ch[0]);
+		*buf++ = hex_asc_lo(ch[0]);
+		*buf++ = hex_asc_hi(ch[1]);
+		*buf++ = hex_asc_lo(ch[1]);
+		*buf++ = hex_asc_hi(ch[2]);
+		*buf++ = hex_asc_lo(ch[2]);
+		*buf++ = hex_asc_hi(ch[3]);
+		*buf++ = hex_asc_lo(ch[3]);
 		mem += 4;
 		count -= 4;
 	}
@@ -857,10 +840,10 @@ unsigned char *mem2hex(const void *_mem,
 	if (count >= 2) {
 		if (gdbstub_read_word(mem, ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
-		*buf++ = hexchars[ch[1] >> 4];
-		*buf++ = hexchars[ch[1] & 0xf];
+		*buf++ = hex_asc_hi(ch[0]);
+		*buf++ = hex_asc_lo(ch[0]);
+		*buf++ = hex_asc_hi(ch[1]);
+		*buf++ = hex_asc_lo(ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -868,8 +851,8 @@ unsigned char *mem2hex(const void *_mem,
 	if (count >= 1) {
 		if (gdbstub_read_byte(mem, ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
+		*buf++ = hex_asc_hi(ch[0]);
+		*buf++ = hex_asc_lo(ch[0]);
 	}
 
 	*buf = 0;
@@ -892,8 +875,8 @@ const char *hex2mem(const char *buf, voi
 	} ch;
 
 	if ((u32) mem & 1 && count >= 1) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
+		ch.b[0]  = hex_to_int(*buf++) << 4;
+		ch.b[0] |= hex_to_int(*buf++);
 		if (gdbstub_write_byte(ch.val, mem) != 0)
 			return 0;
 		mem++;
@@ -901,10 +884,10 @@ const char *hex2mem(const char *buf, voi
 	}
 
 	if ((u32) mem & 3 && count >= 2) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
-		ch.b[1]  = hex(*buf++) << 4;
-		ch.b[1] |= hex(*buf++);
+		ch.b[0]  = hex_to_int(*buf++) << 4;
+		ch.b[0] |= hex_to_int(*buf++);
+		ch.b[1]  = hex_to_int(*buf++) << 4;
+		ch.b[1] |= hex_to_int(*buf++);
 		if (gdbstub_write_word(ch.val, mem) != 0)
 			return 0;
 		mem += 2;
@@ -912,14 +895,14 @@ const char *hex2mem(const char *buf, voi
 	}
 
 	while (count >= 4) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
-		ch.b[1]  = hex(*buf++) << 4;
-		ch.b[1] |= hex(*buf++);
-		ch.b[2]  = hex(*buf++) << 4;
-		ch.b[2] |= hex(*buf++);
-		ch.b[3]  = hex(*buf++) << 4;
-		ch.b[3] |= hex(*buf++);
+		ch.b[0]  = hex_to_int(*buf++) << 4;
+		ch.b[0] |= hex_to_int(*buf++);
+		ch.b[1]  = hex_to_int(*buf++) << 4;
+		ch.b[1] |= hex_to_int(*buf++);
+		ch.b[2]  = hex_to_int(*buf++) << 4;
+		ch.b[2] |= hex_to_int(*buf++);
+		ch.b[3]  = hex_to_int(*buf++) << 4;
+		ch.b[3] |= hex_to_int(*buf++);
 		if (gdbstub_write_dword(ch.val, mem) != 0)
 			return 0;
 		mem += 4;
@@ -927,10 +910,10 @@ const char *hex2mem(const char *buf, voi
 	}
 
 	if (count >= 2) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
-		ch.b[1]  = hex(*buf++) << 4;
-		ch.b[1] |= hex(*buf++);
+		ch.b[0]  = hex_to_int(*buf++) << 4;
+		ch.b[0] |= hex_to_int(*buf++);
+		ch.b[1]  = hex_to_int(*buf++) << 4;
+		ch.b[1] |= hex_to_int(*buf++);
 		if (gdbstub_write_word(ch.val, mem) != 0)
 			return 0;
 		mem += 2;
@@ -938,8 +921,8 @@ const char *hex2mem(const char *buf, voi
 	}
 
 	if (count >= 1) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
+		ch.b[0]  = hex_to_int(*buf++) << 4;
+		ch.b[0] |= hex_to_int(*buf++);
 		if (gdbstub_write_byte(ch.val, mem) != 0)
 			return 0;
 	}
@@ -1304,14 +1287,14 @@ static int gdbstub(struct pt_regs *regs,
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
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(excep >> 8);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_hi(excep);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(excep);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
 
 		ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
 		*ptr = 0;
@@ -1322,22 +1305,22 @@ static int gdbstub(struct pt_regs *regs,
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
+		hx = hex_asc_hi(bcberr >> 24);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(bcberr >> 24);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_hi(bcberr >> 16);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(bcberr >> 16);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_hi(bcberr >> 8);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(bcberr >> 8);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_hi(bcberr);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(bcberr);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
 
 		ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
 		*ptr = 0;
@@ -1353,14 +1336,14 @@ static int gdbstub(struct pt_regs *regs,
 	 * Send trap type (converted to signal)
 	 */
 	*ptr++ = 'T';
-	*ptr++ = hexchars[sigval >> 4];
-	*ptr++ = hexchars[sigval & 0xf];
+	*ptr++ = hex_asc_hi(sigval);
+	*ptr++ = hex_asc_lo(sigval);
 
 	/*
 	 * Send Error PC
 	 */
-	*ptr++ = hexchars[GDB_REGID_PC >> 4];
-	*ptr++ = hexchars[GDB_REGID_PC & 0xf];
+	*ptr++ = hex_asc_hi(GDB_REGID_PC);
+	*ptr++ = hex_asc_lo(GDB_REGID_PC);
 	*ptr++ = ':';
 	ptr = mem2hex(&regs->pc, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1368,8 +1351,8 @@ static int gdbstub(struct pt_regs *regs,
 	/*
 	 * Send frame pointer
 	 */
-	*ptr++ = hexchars[GDB_REGID_FP >> 4];
-	*ptr++ = hexchars[GDB_REGID_FP & 0xf];
+	*ptr++ = hex_asc_hi(GDB_REGID_FP);
+	*ptr++ = hex_asc_lo(GDB_REGID_FP);
 	*ptr++ = ':';
 	ptr = mem2hex(&regs->a3, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1378,8 +1361,8 @@ static int gdbstub(struct pt_regs *regs,
 	 * Send stack pointer
 	 */
 	ssp = (unsigned long) (regs + 1);
-	*ptr++ = hexchars[GDB_REGID_SP >> 4];
-	*ptr++ = hexchars[GDB_REGID_SP & 0xf];
+	*ptr++ = hex_asc_hi(GDB_REGID_SP);
+	*ptr++ = hex_asc_lo(GDB_REGID_SP);
 	*ptr++ = ':';
 	ptr = mem2hex(&ssp, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1399,8 +1382,8 @@ packet_waiting:
 			/* request repeat of last signal number */
 		case '?':
 			output_buffer[0] = 'S';
-			output_buffer[1] = hexchars[sigval >> 4];
-			output_buffer[2] = hexchars[sigval & 0xf];
+			output_buffer[1] = hex_asc_hi(sigval);
+			output_buffer[2] = hex_asc_lo(sigval);
 			output_buffer[3] = 0;
 			break;
 
@@ -1838,8 +1821,8 @@ void gdbstub_exit(int status)
 
 	gdbstub_busy = 1;
 	output_buffer[0] = 'W';
-	output_buffer[1] = hexchars[(status >> 4) & 0x0F];
-	output_buffer[2] = hexchars[status & 0x0F];
+	output_buffer[1] = hex_asc_hi(status);
+	output_buffer[2] = hex_asc_lo(status);
 	output_buffer[3] = 0;
 
 	gdbstub_io_tx_char('$');
@@ -1853,8 +1836,8 @@ void gdbstub_exit(int status)
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
misc-fix-integer-as-null-pointer-warnings.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
input-ff-memlessc-use-clamp_val-macro.patch
ata-remove-fit-macro.patch
ide-eliminate-fit-macro.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
git-mips.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
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
xtensa-replace-remaining-__function__-occurences.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
lib-add-ascii-hex-helper-functions.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
cris-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
frv-gdb-stubc-use-the-common-ascii-hex-helpers.patch
mn10300-gdb-stubc-use-the-common-ascii-hex-helpers.patch
mips-gdb-stubc-use-the-common-ascii-hex-helpers.patch
sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch

