From: akpm@linux-foundation.org
Subject: - mips-use-the-common-ascii-hex-helpers.patch removed from -mm tree
Date: Tue, 22 Jul 2008 14:30:38 -0700
Message-ID: <200807222130.m6MLUcxS018646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753437AbYGVVbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 17:31:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: use the common ascii hex helpers
has been removed from the -mm tree.  Its filename was
     mips-use-the-common-ascii-hex-helpers.patch

This patch was dropped because that file just disappeared

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/gdb-stub.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff -puN arch/mips/kernel/gdb-stub.c~mips-use-the-common-ascii-hex-helpers arch/mips/kernel/gdb-stub.c
--- a/arch/mips/kernel/gdb-stub.c~mips-use-the-common-ascii-hex-helpers
+++ a/arch/mips/kernel/gdb-stub.c
@@ -190,7 +190,6 @@ static char input_buffer[BUFMAX];
 static char output_buffer[BUFMAX];
 static int initialized;	/* !0 means we've been initialized */
 static int kgdb_started;
-static const char hexchars[]="0123456789abcdef";
 
 /* Used to prevent crashes in memory access.  Note that they'll crash anyway if
    we haven't set up fault handlers yet... */
@@ -306,8 +305,8 @@ static void putpacket(char *buffer)
 		}
 
 		putDebugChar('#');
-		putDebugChar(hexchars[checksum >> 4]);
-		putDebugChar(hexchars[checksum & 0xf]);
+		putDebugChar(hex_asc_hi(checksum));
+		putDebugChar(hex_asc_lo(checksum));
 
 	}
 	while ((getDebugChar() & 0x7f) != '+');
@@ -328,8 +327,7 @@ static unsigned char *mem2hex(char *mem,
 	while (count-- > 0) {
 		if (kgdb_read_byte(mem++, &ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch >> 4];
-		*buf++ = hexchars[ch & 0xf];
+		buf = pack_hex_byte(buf, ch);
 	}
 
 	*buf = 0;
@@ -812,14 +810,12 @@ void handle_exception(struct gdb_regs *r
 	 * Send trap type (converted to signal)
 	 */
 	*ptr++ = 'T';
-	*ptr++ = hexchars[sigval >> 4];
-	*ptr++ = hexchars[sigval & 0xf];
+	ptr = pack_hex_byte(ptr, sigval);
 
 	/*
 	 * Send Error PC
 	 */
-	*ptr++ = hexchars[REG_EPC >> 4];
-	*ptr++ = hexchars[REG_EPC & 0xf];
+	ptr = pack_hex_byte(ptr, REG_EPC);
 	*ptr++ = ':';
 	ptr = mem2hex((char *)&regs->cp0_epc, ptr, sizeof(long), 0);
 	*ptr++ = ';';
@@ -827,8 +823,7 @@ void handle_exception(struct gdb_regs *r
 	/*
 	 * Send frame pointer
 	 */
-	*ptr++ = hexchars[REG_FP >> 4];
-	*ptr++ = hexchars[REG_FP & 0xf];
+	ptr = pack_hex_byte(ptr, REG_FP);
 	*ptr++ = ':';
 	ptr = mem2hex((char *)&regs->reg30, ptr, sizeof(long), 0);
 	*ptr++ = ';';
@@ -836,8 +831,7 @@ void handle_exception(struct gdb_regs *r
 	/*
 	 * Send stack pointer
 	 */
-	*ptr++ = hexchars[REG_SP >> 4];
-	*ptr++ = hexchars[REG_SP & 0xf];
+	ptr = pack_hex_byte(ptr, REG_SP);
 	*ptr++ = ':';
 	ptr = mem2hex((char *)&regs->reg29, ptr, sizeof(long), 0);
 	*ptr++ = ';';
@@ -856,8 +850,8 @@ void handle_exception(struct gdb_regs *r
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
cifs-remove-global_extern-macro.patch
input-ads7846c-remove-sparse-endian-warnings.patch
input-ads7846c-sparse-lock-annotation.patch
git-kvm.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
lockd-trivial-sparse-endian-annotations.patch
pci-procc-sparse-endian-annotations.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
ecryptfs-cryptoc-use-unaligned-byteorder-helpers.patch
ecryptfs-inodec-mmapc-use-unaligned-byteorder-helpers.patch
markers-fix-sparse-integer-as-null-pointer-warning.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

