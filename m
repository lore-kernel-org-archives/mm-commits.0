From: akpm@linux-foundation.org
Subject: + mips-gdb-stubc-use-the-common-ascii-hex-helpers.patch added to -mm tree
Date: Fri, 02 May 2008 15:56:46 -0700
Message-ID: <200805022256.m42Muktj019298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935068AbYEBW5T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 18:57:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     mips: gdb-stub.c use the common ascii hex helpers
has been added to the -mm tree.  Its filename is
     mips-gdb-stubc-use-the-common-ascii-hex-helpers.patch

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
Subject: mips: gdb-stub.c use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/gdb-stub.c |   56 ++++++++++++----------------------
 1 file changed, 20 insertions(+), 36 deletions(-)

diff -puN arch/mips/kernel/gdb-stub.c~mips-gdb-stubc-use-the-common-ascii-hex-helpers arch/mips/kernel/gdb-stub.c
--- a/arch/mips/kernel/gdb-stub.c~mips-gdb-stubc-use-the-common-ascii-hex-helpers
+++ a/arch/mips/kernel/gdb-stub.c
@@ -164,7 +164,6 @@ extern void adel(void);
 static void getpacket(char *buffer);
 static void putpacket(char *buffer);
 static int computeSignal(int tt);
-static int hex(unsigned char ch);
 static int hexToInt(char **ptr, int *intValue);
 static int hexToLong(char **ptr, long *longValue);
 static unsigned char *mem2hex(char *mem, char *buf, int count, int may_fault);
@@ -190,7 +189,6 @@ static char input_buffer[BUFMAX];
 static char output_buffer[BUFMAX];
 static int initialized;	/* !0 means we've been initialized */
 static int kgdb_started;
-static const char hexchars[]="0123456789abcdef";
 
 /* Used to prevent crashes in memory access.  Note that they'll crash anyway if
    we haven't set up fault handlers yet... */
@@ -198,20 +196,6 @@ int kgdb_read_byte(unsigned char *addres
 int kgdb_write_byte(unsigned char val, unsigned char *dest);
 
 /*
- * Convert ch from a hex digit to an int
- */
-static int hex(unsigned char ch)
-{
-	if (ch >= 'a' && ch <= 'f')
-		return ch-'a'+10;
-	if (ch >= '0' && ch <= '9')
-		return ch-'0';
-	if (ch >= 'A' && ch <= 'F')
-		return ch-'A'+10;
-	return -1;
-}
-
-/*
  * scan for the sequence $<data>#<checksum>
  */
 static void getpacket(char *buffer)
@@ -251,8 +235,8 @@ static void getpacket(char *buffer)
 		buffer[count] = 0;
 
 		if (ch == '#') {
-			xmitcsum = hex(getDebugChar() & 0x7f) << 4;
-			xmitcsum |= hex(getDebugChar() & 0x7f);
+			xmitcsum = hex_to_int(getDebugChar() & 0x7f) << 4;
+			xmitcsum |= hex_to_int(getDebugChar() & 0x7f);
 
 			if (checksum != xmitcsum)
 				putDebugChar('-');	/* failed checksum */
@@ -306,8 +290,8 @@ static void putpacket(char *buffer)
 		}
 
 		putDebugChar('#');
-		putDebugChar(hexchars[checksum >> 4]);
-		putDebugChar(hexchars[checksum & 0xf]);
+		putDebugChar(hex_asc_hi(checksum));
+		putDebugChar(hex_asc_lo(checksum));
 
 	}
 	while ((getDebugChar() & 0x7f) != '+');
@@ -328,8 +312,8 @@ static unsigned char *mem2hex(char *mem,
 	while (count-- > 0) {
 		if (kgdb_read_byte(mem++, &ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch >> 4];
-		*buf++ = hexchars[ch & 0xf];
+		*buf++ = hex_asc_hi(ch);
+		*buf++ = hex_asc_lo(ch);
 	}
 
 	*buf = 0;
@@ -356,8 +340,8 @@ static char *hex2mem(char *buf, char *me
 				ch = 0x20 ^ *buf++;
 		}
 		else {
-			ch = hex(*buf++) << 4;
-			ch |= hex(*buf++);
+			ch = hex_to_int(*buf++) << 4;
+			ch |= hex_to_int(*buf++);
 		}
 		if (kgdb_write_byte(ch, mem++) != 0)
 			return 0;
@@ -457,7 +441,7 @@ static int hexToInt(char **ptr, int *int
 	*intValue = 0;
 
 	while (**ptr) {
-		hexValue = hex(**ptr);
+		hexValue = hex_to_int(**ptr);
 		if (hexValue < 0)
 			break;
 
@@ -478,7 +462,7 @@ static int hexToLong(char **ptr, long *l
 	*longValue = 0;
 
 	while (**ptr) {
-		hexValue = hex(**ptr);
+		hexValue = hex_to_int(**ptr);
 		if (hexValue < 0)
 			break;
 
@@ -812,14 +796,14 @@ void handle_exception(struct gdb_regs *r
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
-	*ptr++ = hexchars[REG_EPC >> 4];
-	*ptr++ = hexchars[REG_EPC & 0xf];
+	*ptr++ = hex_asc_hi(REG_EPC);
+	*ptr++ = hex_asc_lo(REG_EPC);
 	*ptr++ = ':';
 	ptr = mem2hex((char *)&regs->cp0_epc, ptr, sizeof(long), 0);
 	*ptr++ = ';';
@@ -827,8 +811,8 @@ void handle_exception(struct gdb_regs *r
 	/*
 	 * Send frame pointer
 	 */
-	*ptr++ = hexchars[REG_FP >> 4];
-	*ptr++ = hexchars[REG_FP & 0xf];
+	*ptr++ = hex_asc_hi(REG_FP);
+	*ptr++ = hex_asc_lo(REG_FP);
 	*ptr++ = ':';
 	ptr = mem2hex((char *)&regs->reg30, ptr, sizeof(long), 0);
 	*ptr++ = ';';
@@ -836,8 +820,8 @@ void handle_exception(struct gdb_regs *r
 	/*
 	 * Send stack pointer
 	 */
-	*ptr++ = hexchars[REG_SP >> 4];
-	*ptr++ = hexchars[REG_SP & 0xf];
+	*ptr++ = hex_asc_hi(REG_SP);
+	*ptr++ = hex_asc_lo(REG_SP);
 	*ptr++ = ':';
 	ptr = mem2hex((char *)&regs->reg29, ptr, sizeof(long), 0);
 	*ptr++ = ';';
@@ -856,8 +840,8 @@ void handle_exception(struct gdb_regs *r
 		{
 		case '?':
 			output_buffer[0] = 'S';
-			output_buffer[1] = hexchars[sigval >> 4];
-			output_buffer[2] = hexchars[sigval & 0xf];
+			output_buffer[1] = hex_asc_hi(sigval);
+			output_buffer[2] = hex_asc_lo(sigval);
 			output_buffer[3] = 0;
 			break;
 
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

