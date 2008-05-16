From: akpm@linux-foundation.org
Subject: - lib-create-common-ascii-hex-array.patch removed from -mm tree
Date: Fri, 16 May 2008 15:53:15 -0700
Message-ID: <200805162253.m4GMrF8a003121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761573AbYEPWxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jason.wessel@windriver.com, lethal@linux-sh.org, mingo@elte.hu, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     lib: create common ascii hex array
has been removed from the -mm tree.  Its filename was
     lib-create-common-ascii-hex-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: create common ascii hex array
From: Harvey Harrison <harvey.harrison@gmail.com>

Add a common hex array in hexdump.c so everyone can use it.

Add a common hi/lo helper to avoid the shifting masking that is
done to get the upper and lower nibbles of a byte value.

Pull the pack_hex_byte helper from kgdb as it is opencoded many
places in the tree that will be consolidated.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/kgdb_stub.c |    8 --------
 drivers/pnp/support.c      |    8 ++++----
 include/linux/kernel.h     |   12 +++++++++++-
 kernel/kgdb.c              |    8 --------
 lib/hexdump.c              |    7 +++++--
 5 files changed, 20 insertions(+), 23 deletions(-)

diff -puN arch/sh/kernel/kgdb_stub.c~lib-create-common-ascii-hex-array arch/sh/kernel/kgdb_stub.c
--- a/arch/sh/kernel/kgdb_stub.c~lib-create-common-ascii-hex-array
+++ a/arch/sh/kernel/kgdb_stub.c
@@ -330,14 +330,6 @@ static char *ebin_to_mem(const char *buf
 	return mem;
 }
 
-/* Pack a hex byte */
-static char *pack_hex_byte(char *pkt, int byte)
-{
-	*pkt++ = hexchars[(byte >> 4) & 0xf];
-	*pkt++ = hexchars[(byte & 0xf)];
-	return pkt;
-}
-
 /* Scan for the start char '$', read the packet and check the checksum */
 static void get_packet(char *buffer, int buflen)
 {
diff -puN drivers/pnp/support.c~lib-create-common-ascii-hex-array drivers/pnp/support.c
--- a/drivers/pnp/support.c~lib-create-common-ascii-hex-array
+++ a/drivers/pnp/support.c
@@ -45,10 +45,10 @@ void pnp_eisa_id_to_string(u32 id, char 
 	str[0] = 'A' + ((id >> 26) & 0x3f) - 1;
 	str[1] = 'A' + ((id >> 21) & 0x1f) - 1;
 	str[2] = 'A' + ((id >> 16) & 0x1f) - 1;
-	str[3] = hex_asc((id >> 12) & 0xf);
-	str[4] = hex_asc((id >>  8) & 0xf);
-	str[5] = hex_asc((id >>  4) & 0xf);
-	str[6] = hex_asc((id >>  0) & 0xf);
+	str[3] = hex_asc_hi(id >> 8);
+	str[4] = hex_asc_lo(id >> 8);
+	str[5] = hex_asc_hi(id);
+	str[6] = hex_asc_lo(id);
 	str[7] = '\0';
 }
 
diff -puN include/linux/kernel.h~lib-create-common-ascii-hex-array include/linux/kernel.h
--- a/include/linux/kernel.h~lib-create-common-ascii-hex-array
+++ a/include/linux/kernel.h
@@ -276,7 +276,17 @@ extern void print_hex_dump(const char *l
 				const void *buf, size_t len, bool ascii);
 extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 			const void *buf, size_t len);
-#define hex_asc(x)	"0123456789abcdef"[x]
+
+extern const char hex_asc[];
+#define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
+#define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
+
+static inline char *pack_hex_byte(char *buf, u8 byte)
+{
+	*buf++ = hex_asc_hi(byte);
+	*buf++ = hex_asc_lo(byte);
+	return buf;
+}
 
 #define pr_emerg(fmt, arg...) \
 	printk(KERN_EMERG fmt, ##arg)
diff -puN kernel/kgdb.c~lib-create-common-ascii-hex-array kernel/kgdb.c
--- a/kernel/kgdb.c~lib-create-common-ascii-hex-array
+++ a/kernel/kgdb.c
@@ -346,14 +346,6 @@ static void put_packet(char *buffer)
 	}
 }
 
-static char *pack_hex_byte(char *pkt, u8 byte)
-{
-	*pkt++ = hexchars[byte >> 4];
-	*pkt++ = hexchars[byte & 0xf];
-
-	return pkt;
-}
-
 /*
  * Convert the memory pointed to by mem into hex, placing result in buf.
  * Return a pointer to the last char put in buf (null). May return an error.
diff -puN lib/hexdump.c~lib-create-common-ascii-hex-array lib/hexdump.c
--- a/lib/hexdump.c~lib-create-common-ascii-hex-array
+++ a/lib/hexdump.c
@@ -12,6 +12,9 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
+const char hex_asc[] = "0123456789abcdef";
+EXPORT_SYMBOL(hex_asc);
+
 /**
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
@@ -93,8 +96,8 @@ void hex_dump_to_buffer(const void *buf,
 		for (j = 0; (j < rowsize) && (j < len) && (lx + 4) < linebuflen;
 		     j++) {
 			ch = ptr[j];
-			linebuf[lx++] = hex_asc(ch >> 4);
-			linebuf[lx++] = hex_asc(ch & 0x0f);
+			linebuf[lx++] = hex_asc_hi(ch);
+			linebuf[lx++] = hex_asc_lo(ch);
 			linebuf[lx++] = ' ';
 		}
 		ascii_column = 3 * rowsize + 2;
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
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
nfs-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
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
mips-use-the-common-ascii-hex-helpers.patch
sh-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

