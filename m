From: akpm@linux-foundation.org
Subject: - sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers.patch removed from -mm tree
Date: Fri, 02 May 2008 17:08:47 -0700
Message-ID: <200805030008.m4308lEm022251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965356AbYECAIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 20:08:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sh: kgdb-stub.c, sh-sci.c use the common ascii hex helpers
has been removed from the -mm tree.  Its filename was
     sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sh: kgdb-stub.c, sh-sci.c use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/kgdb_stub.c |   16 ++++++++--------
 drivers/serial/sh-sci.c    |    8 ++++----
 include/asm-sh/kgdb.h      |   14 --------------
 3 files changed, 12 insertions(+), 26 deletions(-)

diff -puN arch/sh/kernel/kgdb_stub.c~sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers arch/sh/kernel/kgdb_stub.c
--- a/arch/sh/kernel/kgdb_stub.c~sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers
+++ a/arch/sh/kernel/kgdb_stub.c
@@ -274,8 +274,8 @@ static char *mem_to_hex(const char *mem,
 	}
 	for (i = 0; i < count; i++) {
 		ch = *mem++;
-		*buf++ = highhex(ch);
-		*buf++ = lowhex(ch);
+		*buf++ = hex_asc_hi(ch);
+		*buf++ = hex_asc_lo(ch);
 	}
 	*buf = 0;
 	return (buf);
@@ -333,8 +333,8 @@ static char *ebin_to_mem(const char *buf
 /* Pack a hex byte */
 static char *pack_hex_byte(char *pkt, int byte)
 {
-	*pkt++ = hexchars[(byte >> 4) & 0xf];
-	*pkt++ = hexchars[(byte & 0xf)];
+	*pkt++ = hex_asc_hi(byte);
+	*pkt++ = hex_asc_lo(byte);
 	return pkt;
 }
 
@@ -435,8 +435,8 @@ static void put_packet(char *buffer)
 
 		/* '#' Separator, put high and low components of checksum */
 		put_debug_char('#');
-		put_debug_char(highhex(checksum));
-		put_debug_char(lowhex(checksum));
+		put_debug_char(hex_asc_hi(checksum));
+		put_debug_char(hex_asc_lo(checksum));
 	}
 	while ((get_debug_char()) != '+');	/* While no ack */
 }
@@ -658,8 +658,8 @@ static void undo_single_step(void)
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
diff -puN drivers/serial/sh-sci.c~sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers drivers/serial/sh-sci.c
--- a/drivers/serial/sh-sci.c~sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers
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
diff -puN include/asm-sh/kgdb.h~sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers include/asm-sh/kgdb.h
--- a/include/asm-sh/kgdb.h~sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers
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
sh-kgdb-stubc-sh-scic-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
isdn-use-the-common-ascii-hex-helpers.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch

