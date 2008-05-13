From: akpm@linux-foundation.org
Subject: + ppc-use-the-common-ascii-hex-helpers.patch added to -mm tree
Date: Mon, 12 May 2008 17:31:57 -0700
Message-ID: <200805130031.m4D0VvY1016807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755130AbYEMAcA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 20:32:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     ppc: use the common ascii hex helpers
has been added to the -mm tree.  Its filename is
     ppc-use-the-common-ascii-hex-helpers.patch

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
Subject: ppc: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/btext.c     |   34 +++++++++++------------
 arch/powerpc/kernel/prom_init.c |    3 --
 arch/ppc/kernel/ppc-stub.c      |   43 +++++++++---------------------
 arch/ppc/syslib/btext.c         |   18 +++++-------
 arch/ppc/xmon/start_8xx.c       |    2 -
 5 files changed, 40 insertions(+), 60 deletions(-)

diff -puN arch/powerpc/kernel/btext.c~ppc-use-the-common-ascii-hex-helpers arch/powerpc/kernel/btext.c
--- a/arch/powerpc/kernel/btext.c~ppc-use-the-common-ascii-hex-helpers
+++ a/arch/powerpc/kernel/btext.c
@@ -442,28 +442,26 @@ void btext_drawtext(const char *c, unsig
 
 void btext_drawhex(unsigned long v)
 {
-	char *hex_table = "0123456789abcdef";
-
 	if (!boot_text_mapped)
 		return;
 #ifdef CONFIG_PPC64
-	btext_drawchar(hex_table[(v >> 60) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 56) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 52) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 48) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 44) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 40) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 36) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 32) & 0x0000000FUL]);
+	btext_drawchar(hex_asc_hi(v >> 56));
+	btext_drawchar(hex_asc_lo(v >> 56));
+	btext_drawchar(hex_asc_hi(v >> 48));
+	btext_drawchar(hex_asc_lo(v >> 48));
+	btext_drawchar(hex_asc_hi(v >> 40));
+	btext_drawchar(hex_asc_lo(v >> 40));
+	btext_drawchar(hex_asc_hi(v >> 32));
+	btext_drawchar(hex_asc_lo(v >> 32));
 #endif
-	btext_drawchar(hex_table[(v >> 28) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 24) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 20) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 16) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 12) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >>  8) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >>  4) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >>  0) & 0x0000000FUL]);
+	btext_drawchar(hex_asc_hi(v >> 24));
+	btext_drawchar(hex_asc_lo(v >> 24));
+	btext_drawchar(hex_asc_hi(v >> 16));
+	btext_drawchar(hex_asc_lo(v >> 16));
+	btext_drawchar(hex_asc_hi(v >> 8));
+	btext_drawchar(hex_asc_lo(v >> 8));
+	btext_drawchar(hex_asc_hi(v));
+	btext_drawchar(hex_asc_lo(v));
 	btext_drawchar(' ');
 }
 
diff -puN arch/powerpc/kernel/prom_init.c~ppc-use-the-common-ascii-hex-helpers arch/powerpc/kernel/prom_init.c
--- a/arch/powerpc/kernel/prom_init.c~ppc-use-the-common-ascii-hex-helpers
+++ a/arch/powerpc/kernel/prom_init.c
@@ -453,7 +453,6 @@ static void add_string(char **str, const
 
 static char *tohex(unsigned int x)
 {
-	static char digits[] = "0123456789abcdef";
 	static char result[9];
 	int i;
 
@@ -461,7 +460,7 @@ static char *tohex(unsigned int x)
 	i = 8;
 	do {
 		--i;
-		result[i] = digits[x & 0xf];
+		result[i] = hex_asc_lo(x);
 		x >>= 4;
 	} while (x != 0 && i > 0);
 	return &result[i];
diff -puN arch/ppc/kernel/ppc-stub.c~ppc-use-the-common-ascii-hex-helpers arch/ppc/kernel/ppc-stub.c
--- a/arch/ppc/kernel/ppc-stub.c~ppc-use-the-common-ascii-hex-helpers
+++ a/arch/ppc/kernel/ppc-stub.c
@@ -130,9 +130,6 @@ static int kgdb_started;
 static u_int fault_jmp_buf[100];
 static int kdebug;
 
-
-static const char hexchars[]="0123456789abcdef";
-
 /* Place where we save old trap entries for restoration - sparc*/
 /* struct tt_entry kgdb_savettable[256]; */
 /* typedef void (*trapfunc_t)(void); */
@@ -205,28 +202,19 @@ mem2hex(const char *mem, char *buf, int 
 		if ((count == 2) && (((long)mem & 1) == 0)) {
 			tmp_s = *(unsigned short *)mem;
 			mem += 2;
-			*buf++ = hexchars[(tmp_s >> 12) & 0xf];
-			*buf++ = hexchars[(tmp_s >> 8) & 0xf];
-			*buf++ = hexchars[(tmp_s >> 4) & 0xf];
-			*buf++ = hexchars[tmp_s & 0xf];
-
+			buf = pack_hex_byte(buf, tmp_s >> 8);
+			buf = pack_hex_byte(buf, tmp_s);
 		} else if ((count == 4) && (((long)mem & 3) == 0)) {
 			tmp_l = *(unsigned int *)mem;
 			mem += 4;
-			*buf++ = hexchars[(tmp_l >> 28) & 0xf];
-			*buf++ = hexchars[(tmp_l >> 24) & 0xf];
-			*buf++ = hexchars[(tmp_l >> 20) & 0xf];
-			*buf++ = hexchars[(tmp_l >> 16) & 0xf];
-			*buf++ = hexchars[(tmp_l >> 12) & 0xf];
-			*buf++ = hexchars[(tmp_l >> 8) & 0xf];
-			*buf++ = hexchars[(tmp_l >> 4) & 0xf];
-			*buf++ = hexchars[tmp_l & 0xf];
-
+			buf = pack_hex_byte(buf, tmp_l >> 24);
+			buf = pack_hex_byte(buf, tmp_l >> 16);
+			buf = pack_hex_byte(buf, tmp_l >> 8);
+			buf = pack_hex_byte(buf, tmp_l);
 		} else {
 			while (count-- > 0) {
 				ch = *mem++;
-				*buf++ = hexchars[ch >> 4];
-				*buf++ = hexchars[ch & 0xf];
+				buf = pack_hex_byte(buf, ch);
 			}
 		}
 
@@ -411,8 +399,8 @@ static void putpacket(unsigned char *buf
 		}
 
 		putDebugChar('#');
-		putDebugChar(hexchars[checksum >> 4]);
-		putDebugChar(hexchars[checksum & 0xf]);
+		putDebugChar(hex_asc_hi(checksum));
+		putDebugChar(hex_asc_lo(checksum));
 		recv = getDebugChar();
 	} while ((recv & 0x7f) != '+');
 }
@@ -602,15 +590,12 @@ handle_exception (struct pt_regs *regs)
 	ptr = remcomOutBuffer;
 
 	*ptr++ = 'T';
-	*ptr++ = hexchars[sigval >> 4];
-	*ptr++ = hexchars[sigval & 0xf];
-	*ptr++ = hexchars[PC_REGNUM >> 4];
-	*ptr++ = hexchars[PC_REGNUM & 0xf];
+	ptr = pack_hex_byte(ptr, sigval);
+	ptr = pack_hex_byte(ptr, PC_REGNUM);
 	*ptr++ = ':';
 	ptr = mem2hex((char *)&regs->nip, ptr, 4);
 	*ptr++ = ';';
-	*ptr++ = hexchars[SP_REGNUM >> 4];
-	*ptr++ = hexchars[SP_REGNUM & 0xf];
+	ptr = pack_hex_byte(ptr, SP_REGNUM);
 	*ptr++ = ':';
 	ptr = mem2hex(((char *)regs) + SP_REGNUM*4, ptr, 4);
 	*ptr++ = ';';
@@ -632,8 +617,8 @@ handle_exception (struct pt_regs *regs)
 		switch (remcomInBuffer[0]) {
 		case '?': /* report most recent signal */
 			remcomOutBuffer[0] = 'S';
-			remcomOutBuffer[1] = hexchars[sigval >> 4];
-			remcomOutBuffer[2] = hexchars[sigval & 0xf];
+			remcomOutBuffer[1] = hex_asc_hi(sigval);
+			remcomOutBuffer[2] = hex_asc_lo(sigval);
 			remcomOutBuffer[3] = 0;
 			break;
 #if 0
diff -puN arch/ppc/syslib/btext.c~ppc-use-the-common-ascii-hex-helpers arch/ppc/syslib/btext.c
--- a/arch/ppc/syslib/btext.c~ppc-use-the-common-ascii-hex-helpers
+++ a/arch/ppc/syslib/btext.c
@@ -391,18 +391,16 @@ btext_drawstring(const char *c)
 void BTEXT
 btext_drawhex(unsigned long v)
 {
-	static char hex_table[] = "0123456789abcdef";
-
 	if (!boot_text_mapped)
 		return;
-	btext_drawchar(hex_table[(v >> 28) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 24) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 20) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 16) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 12) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >>  8) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >>  4) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >>  0) & 0x0000000FUL]);
+	btext_drawchar(hex_asc_hi(v >> 24));
+	btext_drawchar(hex_asc_lo(v >> 24));
+	btext_drawchar(hex_asc_hi(v >> 16));
+	btext_drawchar(hex_asc_lo(v >> 16));
+	btext_drawchar(hex_asc_hi(v >> 8));
+	btext_drawchar(hex_asc_lo(v >> 8));
+	btext_drawchar(hex_asc_hi(v));
+	btext_drawchar(hex_asc_lo(v));
 	btext_drawchar(' ');
 }
 
diff -puN arch/ppc/xmon/start_8xx.c~ppc-use-the-common-ascii-hex-helpers arch/ppc/xmon/start_8xx.c
--- a/arch/ppc/xmon/start_8xx.c~ppc-use-the-common-ascii-hex-helpers
+++ a/arch/ppc/xmon/start_8xx.c
@@ -273,7 +273,7 @@ prom_drawhex(uint val)
 	int i;
 	for (i = 7;  i >= 0;  i--)
 	{
-		buf[i] = "0123456789abcdef"[val & 0x0f];
+		buf[i] = hex_asc_lo(val);
 		val >>= 4;
 	}
 	buf[8] = '\0';
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

mmc-make-one-bit-signed-bitfields-unsigned.patch
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
aacraid-linitc-make-aac_show_serial_number-static.patch

