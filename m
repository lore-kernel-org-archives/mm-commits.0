From: akpm@linux-foundation.org
Subject: + sh-use-the-common-ascii-hex-helpers.patch added to -mm tree
Date: Mon, 12 May 2008 17:31:55 -0700
Message-ID: <200805130031.m4D0VtKl016804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754917AbYEMAb7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 20:31:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, lethal@linux-sh.org


The patch titled
     sh: use the common ascii hex helpers
has been added to the -mm tree.  Its filename is
     sh-use-the-common-ascii-hex-helpers.patch

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
Subject: sh: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/kgdb_stub.c |   11 +++++------
 drivers/serial/sh-sci.c    |    8 ++++----
 include/asm-sh/kgdb.h      |   14 --------------
 3 files changed, 9 insertions(+), 24 deletions(-)

diff -puN arch/sh/kernel/kgdb_stub.c~sh-use-the-common-ascii-hex-helpers arch/sh/kernel/kgdb_stub.c
--- a/arch/sh/kernel/kgdb_stub.c~sh-use-the-common-ascii-hex-helpers
+++ a/arch/sh/kernel/kgdb_stub.c
@@ -274,8 +274,7 @@ static char *mem_to_hex(const char *mem,
 	}
 	for (i = 0; i < count; i++) {
 		ch = *mem++;
-		*buf++ = highhex(ch);
-		*buf++ = lowhex(ch);
+		buf = pack_hex_byte(buf, ch);
 	}
 	*buf = 0;
 	return (buf);
@@ -427,8 +426,8 @@ static void put_packet(char *buffer)
 
 		/* '#' Separator, put high and low components of checksum */
 		put_debug_char('#');
-		put_debug_char(highhex(checksum));
-		put_debug_char(lowhex(checksum));
+		put_debug_char(hex_asc_hi(checksum));
+		put_debug_char(hex_asc_lo(checksum));
 	}
 	while ((get_debug_char()) != '+');	/* While no ack */
 }
@@ -650,8 +649,8 @@ static void undo_single_step(void)
 static void send_signal_msg(const int signum)
 {
 	out_buffer[0] = 'S';
-	out_buffer[1] = highhex(signum);
-	out_buffer[2] = lowhex(signum);
+	out_buffer[1] = hex_asc_hi(signum);
+	out_buffer[2] = hex_asc_lo(signum);
 	out_buffer[3] = 0;
 	put_packet(out_buffer);
 }
diff -puN drivers/serial/sh-sci.c~sh-use-the-common-ascii-hex-helpers drivers/serial/sh-sci.c
--- a/drivers/serial/sh-sci.c~sh-use-the-common-ascii-hex-helpers
+++ a/drivers/serial/sh-sci.c
@@ -184,15 +184,15 @@ static void put_string(struct sci_port *
 			int h, l;
 
 			c = *p++;
-			h = highhex(c);
-			l = lowhex(c);
+			h = hex_asc_hi(c);
+			l = hex_asc_lo(c);
 			put_char(port, h);
 			put_char(port, l);
 			checksum += h + l;
 		}
 		put_char(port, '#');
-		put_char(port, highhex(checksum));
-		put_char(port, lowhex(checksum));
+		put_char(port, hex_asc_hi(checksum));
+		put_char(port, hex_asc_lo(checksum));
 	    } while  (get_char(port) != '+');
 	} else
 #endif /* CONFIG_SH_STANDARD_BIOS || CONFIG_SH_KGDB */
diff -puN include/asm-sh/kgdb.h~sh-use-the-common-ascii-hex-helpers include/asm-sh/kgdb.h
--- a/include/asm-sh/kgdb.h~sh-use-the-common-ascii-hex-helpers
+++ a/include/asm-sh/kgdb.h
@@ -66,18 +66,4 @@ extern int     setjmp(jmp_buf __jmpb);
 /* Forced breakpoint */
 #define breakpoint()	__asm__ __volatile__("trapa   #0x3c")
 
-/* Taken from sh-stub.c of GDB 4.18 */
-static const char hexchars[] = "0123456789abcdef";
-
-/* Get high hex bits */
-static inline char highhex(const int x)
-{
-	return hexchars[(x >> 4) & 0xf];
-}
-
-/* Get low hex bits */
-static inline char lowhex(const int x)
-{
-	return hexchars[x & 0xf];
-}
 #endif
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

