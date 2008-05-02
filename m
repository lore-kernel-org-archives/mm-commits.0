From: akpm@linux-foundation.org
Subject: + fs-ldm-use-get_unaligned_-helpers.patch added to -mm tree
Date: Fri, 02 May 2008 16:09:30 -0700
Message-ID: <200805022309.m42N9Uh9019858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759464AbYEBXJs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 19:09:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     fs: ldm.[ch] use get_unaligned_* helpers
has been added to the -mm tree.  Its filename is
     fs-ldm-use-get_unaligned_-helpers.patch

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
Subject: fs: ldm.[ch] use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Replace the private BE16/BE32/BE64 macros with direct calls to
get_unaligned_be16/32/64.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/ldm.c |   70 +++++++++++++++++++++---------------------
 fs/partitions/ldm.h |    5 ---
 2 files changed, 35 insertions(+), 40 deletions(-)

diff -puN fs/partitions/ldm.c~fs-ldm-use-get_unaligned_-helpers fs/partitions/ldm.c
--- a/fs/partitions/ldm.c~fs-ldm-use-get_unaligned_-helpers
+++ a/fs/partitions/ldm.c
@@ -133,17 +133,17 @@ static bool ldm_parse_privhead(const u8 
 	bool is_vista = false;
 
 	BUG_ON(!data || !ph);
-	if (MAGIC_PRIVHEAD != BE64(data)) {
+	if (MAGIC_PRIVHEAD != get_unaligned_be64(data)) {
 		ldm_error("Cannot find PRIVHEAD structure. LDM database is"
 			" corrupt. Aborting.");
 		return false;
 	}
-	ph->ver_major = BE16(data + 0x000C);
-	ph->ver_minor = BE16(data + 0x000E);
-	ph->logical_disk_start = BE64(data + 0x011B);
-	ph->logical_disk_size = BE64(data + 0x0123);
-	ph->config_start = BE64(data + 0x012B);
-	ph->config_size = BE64(data + 0x0133);
+	ph->ver_major = get_unaligned_be16(data + 0x000C);
+	ph->ver_minor = get_unaligned_be16(data + 0x000E);
+	ph->logical_disk_start = get_unaligned_be64(data + 0x011B);
+	ph->logical_disk_size = get_unaligned_be64(data + 0x0123);
+	ph->config_start = get_unaligned_be64(data + 0x012B);
+	ph->config_size = get_unaligned_be64(data + 0x0133);
 	/* Version 2.11 is Win2k/XP and version 2.12 is Vista. */
 	if (ph->ver_major == 2 && ph->ver_minor == 12)
 		is_vista = true;
@@ -191,14 +191,14 @@ static bool ldm_parse_tocblock (const u8
 {
 	BUG_ON (!data || !toc);
 
-	if (MAGIC_TOCBLOCK != BE64 (data)) {
+	if (MAGIC_TOCBLOCK != get_unaligned_be64(data)) {
 		ldm_crit ("Cannot find TOCBLOCK, database may be corrupt.");
 		return false;
 	}
 	strncpy (toc->bitmap1_name, data + 0x24, sizeof (toc->bitmap1_name));
 	toc->bitmap1_name[sizeof (toc->bitmap1_name) - 1] = 0;
-	toc->bitmap1_start = BE64 (data + 0x2E);
-	toc->bitmap1_size  = BE64 (data + 0x36);
+	toc->bitmap1_start = get_unaligned_be64(data + 0x2E);
+	toc->bitmap1_size  = get_unaligned_be64(data + 0x36);
 
 	if (strncmp (toc->bitmap1_name, TOC_BITMAP1,
 			sizeof (toc->bitmap1_name)) != 0) {
@@ -208,8 +208,8 @@ static bool ldm_parse_tocblock (const u8
 	}
 	strncpy (toc->bitmap2_name, data + 0x46, sizeof (toc->bitmap2_name));
 	toc->bitmap2_name[sizeof (toc->bitmap2_name) - 1] = 0;
-	toc->bitmap2_start = BE64 (data + 0x50);
-	toc->bitmap2_size  = BE64 (data + 0x58);
+	toc->bitmap2_start = get_unaligned_be64(data + 0x50);
+	toc->bitmap2_size  = get_unaligned_be64(data + 0x58);
 	if (strncmp (toc->bitmap2_name, TOC_BITMAP2,
 			sizeof (toc->bitmap2_name)) != 0) {
 		ldm_crit ("TOCBLOCK's second bitmap is '%s', should be '%s'.",
@@ -237,22 +237,22 @@ static bool ldm_parse_vmdb (const u8 *da
 {
 	BUG_ON (!data || !vm);
 
-	if (MAGIC_VMDB != BE32 (data)) {
+	if (MAGIC_VMDB != get_unaligned_be32(data)) {
 		ldm_crit ("Cannot find the VMDB, database may be corrupt.");
 		return false;
 	}
 
-	vm->ver_major = BE16 (data + 0x12);
-	vm->ver_minor = BE16 (data + 0x14);
+	vm->ver_major = get_unaligned_be16(data + 0x12);
+	vm->ver_minor = get_unaligned_be16(data + 0x14);
 	if ((vm->ver_major != 4) || (vm->ver_minor != 10)) {
 		ldm_error ("Expected VMDB version %d.%d, got %d.%d. "
 			"Aborting.", 4, 10, vm->ver_major, vm->ver_minor);
 		return false;
 	}
 
-	vm->vblk_size     = BE32 (data + 0x08);
-	vm->vblk_offset   = BE32 (data + 0x0C);
-	vm->last_vblk_seq = BE32 (data + 0x04);
+	vm->vblk_size     = get_unaligned_be32(data + 0x08);
+	vm->vblk_offset   = get_unaligned_be32(data + 0x0C);
+	vm->last_vblk_seq = get_unaligned_be32(data + 0x04);
 
 	ldm_debug ("Parsed VMDB successfully.");
 	return true;
@@ -507,7 +507,7 @@ static bool ldm_validate_vmdb (struct bl
 		goto out;				/* Already logged */
 
 	/* Are there uncommitted transactions? */
-	if (BE16(data + 0x10) != 0x01) {
+	if (get_unaligned_be16(data + 0x10) != 0x01) {
 		ldm_crit ("Database is not in a consistent state.  Aborting.");
 		goto out;
 	}
@@ -802,7 +802,7 @@ static bool ldm_parse_cmp3 (const u8 *bu
 		return false;
 
 	len += VBLK_SIZE_CMP3;
-	if (len != BE32 (buffer + 0x14))
+	if (len != get_unaligned_be32(buffer + 0x14))
 		return false;
 
 	comp = &vb->vblk.comp;
@@ -851,7 +851,7 @@ static int ldm_parse_dgr3 (const u8 *buf
 		return false;
 
 	len += VBLK_SIZE_DGR3;
-	if (len != BE32 (buffer + 0x14))
+	if (len != get_unaligned_be32(buffer + 0x14))
 		return false;
 
 	dgrp = &vb->vblk.dgrp;
@@ -895,7 +895,7 @@ static bool ldm_parse_dgr4 (const u8 *bu
 		return false;
 
 	len += VBLK_SIZE_DGR4;
-	if (len != BE32 (buffer + 0x14))
+	if (len != get_unaligned_be32(buffer + 0x14))
 		return false;
 
 	dgrp = &vb->vblk.dgrp;
@@ -931,7 +931,7 @@ static bool ldm_parse_dsk3 (const u8 *bu
 		return false;
 
 	len += VBLK_SIZE_DSK3;
-	if (len != BE32 (buffer + 0x14))
+	if (len != get_unaligned_be32(buffer + 0x14))
 		return false;
 
 	disk = &vb->vblk.disk;
@@ -968,7 +968,7 @@ static bool ldm_parse_dsk4 (const u8 *bu
 		return false;
 
 	len += VBLK_SIZE_DSK4;
-	if (len != BE32 (buffer + 0x14))
+	if (len != get_unaligned_be32(buffer + 0x14))
 		return false;
 
 	disk = &vb->vblk.disk;
@@ -1034,14 +1034,14 @@ static bool ldm_parse_prt3(const u8 *buf
 		return false;
 	}
 	len += VBLK_SIZE_PRT3;
-	if (len > BE32(buffer + 0x14)) {
+	if (len > get_unaligned_be32(buffer + 0x14)) {
 		ldm_error("len %d > BE32(buffer + 0x14) %d", len,
-				BE32(buffer + 0x14));
+				get_unaligned_be32(buffer + 0x14));
 		return false;
 	}
 	part = &vb->vblk.part;
-	part->start = BE64(buffer + 0x24 + r_name);
-	part->volume_offset = BE64(buffer + 0x2C + r_name);
+	part->start = get_unaligned_be64(buffer + 0x24 + r_name);
+	part->volume_offset = get_unaligned_be64(buffer + 0x2C + r_name);
 	part->size = ldm_get_vnum(buffer + 0x34 + r_name);
 	part->parent_id = ldm_get_vnum(buffer + 0x34 + r_size);
 	part->disk_id = ldm_get_vnum(buffer + 0x34 + r_parent);
@@ -1139,9 +1139,9 @@ static bool ldm_parse_vol5(const u8 *buf
 		return false;
 	}
 	len += VBLK_SIZE_VOL5;
-	if (len > BE32(buffer + 0x14)) {
+	if (len > get_unaligned_be32(buffer + 0x14)) {
 		ldm_error("len %d > BE32(buffer + 0x14) %d", len,
-				BE32(buffer + 0x14));
+				get_unaligned_be32(buffer + 0x14));
 		return false;
 	}
 	volu = &vb->vblk.volu;
@@ -1294,9 +1294,9 @@ static bool ldm_frag_add (const u8 *data
 
 	BUG_ON (!data || !frags);
 
-	group = BE32 (data + 0x08);
-	rec   = BE16 (data + 0x0C);
-	num   = BE16 (data + 0x0E);
+	group = get_unaligned_be32(data + 0x08);
+	rec   = get_unaligned_be16(data + 0x0C);
+	num   = get_unaligned_be16(data + 0x0E);
 	if ((num < 1) || (num > 4)) {
 		ldm_error ("A VBLK claims to have %d parts.", num);
 		return false;
@@ -1425,12 +1425,12 @@ static bool ldm_get_vblks (struct block_
 		}
 
 		for (v = 0; v < perbuf; v++, data+=size) {  /* For each vblk */
-			if (MAGIC_VBLK != BE32 (data)) {
+			if (MAGIC_VBLK != get_unaligned_be32(data)) {
 				ldm_error ("Expected to find a VBLK.");
 				goto out;
 			}
 
-			recs = BE16 (data + 0x0E);	/* Number of records */
+			recs = get_unaligned_be16(data + 0x0E);	/* Number of records */
 			if (recs == 1) {
 				if (!ldm_ldmdb_add (data, size, ldb))
 					goto out;	/* Already logged */
diff -puN fs/partitions/ldm.h~fs-ldm-use-get_unaligned_-helpers fs/partitions/ldm.h
--- a/fs/partitions/ldm.h~fs-ldm-use-get_unaligned_-helpers
+++ a/fs/partitions/ldm.h
@@ -98,11 +98,6 @@ struct parsed_partitions;
 #define TOC_BITMAP1		"config"	/* Names of the two defined */
 #define TOC_BITMAP2		"log"		/* bitmaps in the TOCBLOCK. */
 
-/* Most numbers we deal with are big-endian and won't be aligned. */
-#define BE16(x)			((u16)be16_to_cpu(get_unaligned((__be16*)(x))))
-#define BE32(x)			((u32)be32_to_cpu(get_unaligned((__be32*)(x))))
-#define BE64(x)			((u64)be64_to_cpu(get_unaligned((__be64*)(x))))
-
 /* Borrowed from msdos.c */
 #define SYS_IND(p)		(get_unaligned(&(p)->sys_ind))
 
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
block-use-get_unaligned_-helpers.patch
ide-use-get_unaligned_-helpers.patch
media-use-get_unaligned_-helpers.patch
scsi-use-get_unaligned_-helpers.patch
usb-use-get_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
fs-ldm-use-get_unaligned_-helpers.patch
irda-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
bluetooth-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch

