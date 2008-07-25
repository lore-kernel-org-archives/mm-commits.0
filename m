From: akpm@linux-foundation.org
Subject: - fs-ldm-use-get_unaligned_-helpers.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:05 -0700
Message-ID: <200807252254.m6PMs5ZO002782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207AbYGYWyH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:54:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs: ldm.[ch] use get_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     fs-ldm-use-get_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers-update.patch

