From: akpm@linux-foundation.org
Subject: + partitions-fix-sometimes-unreadable-partition-strings.patch added to -mm tree
Date: Tue, 15 Jun 2010 14:28:01 -0700
Message-ID: <201006152128.o5FLS1gF031535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659Ab0FOV2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jun 2010 17:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     partitions: fix sometimes unreadable partition strings
has been added to the -mm tree.  Its filename is
     partitions-fix-sometimes-unreadable-partition-strings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: partitions: fix sometimes unreadable partition strings
From: Alexey Dobriyan <adobriyan@gmail.com>

Fix this garbage happening quite often:

==>	 sda:
	scsi 3:0:0:0: CD-ROM            TOSHIBA
==>	 sda1 sda2 sda3 sda4 <sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
			    ^^^
	Uniform CD-ROM driver Revision: 3.20
	sr 3:0:0:0: Attached scsi CD-ROM sr0
==>	 sda5 sda6 sda7 >

Make "sda: sda1 ..." lines actually lines.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/acorn.c  |   35 +++++++++++---------
 fs/partitions/amiga.c  |   20 ++++++++---
 fs/partitions/atari.c  |   12 +++---
 fs/partitions/check.c  |   22 ++++++++++--
 fs/partitions/check.h  |    6 ++-
 fs/partitions/efi.c    |    2 -
 fs/partitions/ibm.c    |   17 ++++++---
 fs/partitions/karma.c  |    2 -
 fs/partitions/ldm.c    |    4 +-
 fs/partitions/mac.c    |    4 +-
 fs/partitions/msdos.c  |   67 ++++++++++++++++++++++++++-------------
 fs/partitions/osf.c    |    2 -
 fs/partitions/sgi.c    |    2 -
 fs/partitions/sun.c    |    2 -
 fs/partitions/sysv68.c |    9 +++--
 fs/partitions/ultrix.c |    2 -
 16 files changed, 136 insertions(+), 72 deletions(-)

diff -puN fs/partitions/acorn.c~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/acorn.c
--- a/fs/partitions/acorn.c~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/acorn.c
@@ -45,8 +45,11 @@ adfs_partition(struct parsed_partitions 
 	nr_sects = (le32_to_cpu(dr->disc_size_high) << 23) |
 		   (le32_to_cpu(dr->disc_size) >> 9);
 
-	if (name)
-		printk(" [%s]", name);
+	if (name) {
+		strlcat(state->pp_buf, " [", PAGE_SIZE);
+		strlcat(state->pp_buf, name, PAGE_SIZE);
+		strlcat(state->pp_buf, "]", PAGE_SIZE);
+	}
 	put_partition(state, slot, first_sector, nr_sects);
 	return dr;
 }
@@ -81,14 +84,14 @@ static int riscix_partition(struct parse
 	if (!rr)
 		return -1;
 
-	printk(" [RISCiX]");
+	strlcat(state->pp_buf, " [RISCiX]", PAGE_SIZE);
 
 
 	if (rr->magic == RISCIX_MAGIC) {
 		unsigned long size = nr_sects > 2 ? 2 : nr_sects;
 		int part;
 
-		printk(" <");
+		strlcat(state->pp_buf, " <", PAGE_SIZE);
 
 		put_partition(state, slot++, first_sect, size);
 		for (part = 0; part < 8; part++) {
@@ -97,11 +100,13 @@ static int riscix_partition(struct parse
 				put_partition(state, slot++,
 					le32_to_cpu(rr->part[part].start),
 					le32_to_cpu(rr->part[part].length));
-				printk("(%s)", rr->part[part].name);
+				strlcat(state->pp_buf, "(", PAGE_SIZE);
+				strlcat(state->pp_buf, rr->part[part].name, PAGE_SIZE);
+				strlcat(state->pp_buf, ")", PAGE_SIZE);
 			}
 		}
 
-		printk(" >\n");
+		strlcat(state->pp_buf, " >\n", PAGE_SIZE);
 	} else {
 		put_partition(state, slot++, first_sect, nr_sects);
 	}
@@ -131,7 +136,7 @@ static int linux_partition(struct parsed
 	struct linux_part *linuxp;
 	unsigned long size = nr_sects > 2 ? 2 : nr_sects;
 
-	printk(" [Linux]");
+	strlcat(state->pp_buf, " [Linux]", PAGE_SIZE);
 
 	put_partition(state, slot++, first_sect, size);
 
@@ -139,7 +144,7 @@ static int linux_partition(struct parsed
 	if (!linuxp)
 		return -1;
 
-	printk(" <");
+	strlcat(state->pp_buf, " <", PAGE_SIZE);
 	while (linuxp->magic == cpu_to_le32(LINUX_NATIVE_MAGIC) ||
 	       linuxp->magic == cpu_to_le32(LINUX_SWAP_MAGIC)) {
 		if (slot == state->limit)
@@ -149,7 +154,7 @@ static int linux_partition(struct parsed
 				 le32_to_cpu(linuxp->nr_sects));
 		linuxp ++;
 	}
-	printk(" >");
+	strlcat(state->pp_buf, " >", PAGE_SIZE);
 
 	put_dev_sector(sect);
 	return slot;
@@ -294,7 +299,7 @@ int adfspart_check_ADFS(struct parsed_pa
 			break;
 		}
 	}
-	printk("\n");
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 	return 1;
 }
 #endif
@@ -367,7 +372,7 @@ int adfspart_check_ICS(struct parsed_par
 		return 0;
 	}
 
-	printk(" [ICS]");
+	strlcat(state->pp_buf, " [ICS]", PAGE_SIZE);
 
 	for (slot = 1, p = (const struct ics_part *)data; p->size; p++) {
 		u32 start = le32_to_cpu(p->start);
@@ -401,7 +406,7 @@ int adfspart_check_ICS(struct parsed_par
 	}
 
 	put_dev_sector(sect);
-	printk("\n");
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 	return 1;
 }
 #endif
@@ -461,7 +466,7 @@ int adfspart_check_POWERTEC(struct parse
 		return 0;
 	}
 
-	printk(" [POWERTEC]");
+	strlcat(state->pp_buf, " [POWERTEC]", PAGE_SIZE);
 
 	for (i = 0, p = (const struct ptec_part *)data; i < 12; i++, p++) {
 		u32 start = le32_to_cpu(p->start);
@@ -472,7 +477,7 @@ int adfspart_check_POWERTEC(struct parse
 	}
 
 	put_dev_sector(sect);
-	printk("\n");
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 	return 1;
 }
 #endif
@@ -543,7 +548,7 @@ int adfspart_check_EESOX(struct parsed_p
 
 		size = get_capacity(state->bdev->bd_disk);
 		put_partition(state, slot++, start, size - start);
-		printk("\n");
+		strlcat(state->pp_buf, "\n", PAGE_SIZE);
 	}
 
 	return i ? 1 : 0;
diff -puN fs/partitions/amiga.c~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/amiga.c
--- a/fs/partitions/amiga.c~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/amiga.c
@@ -69,7 +69,13 @@ int amiga_partition(struct parsed_partit
 	/* blksize is blocks per 512 byte standard block */
 	blksize = be32_to_cpu( rdb->rdb_BlockBytes ) / 512;
 
-	printk(" RDSK (%d)", blksize * 512);	/* Be more informative */
+	{
+		char tmp[7 + 10 + 1 + 1];
+
+		/* Be more informative */
+		snprintf(tmp, sizeof(tmp), " RDSK (%d)", blksize * 512);
+		strlcat(state->pp_buf, tmp, PAGE_SIZE);
+	}
 	blk = be32_to_cpu(rdb->rdb_PartitionList);
 	put_dev_sector(sect);
 	for (part = 1; blk>0 && part<=16; part++, put_dev_sector(sect)) {
@@ -106,23 +112,27 @@ int amiga_partition(struct parsed_partit
 		{
 			/* Be even more informative to aid mounting */
 			char dostype[4];
+			char tmp[42];
+
 			__be32 *dt = (__be32 *)dostype;
 			*dt = pb->pb_Environment[16];
 			if (dostype[3] < ' ')
-				printk(" (%c%c%c^%c)",
+				snprintf(tmp, sizeof(tmp), " (%c%c%c^%c)",
 					dostype[0], dostype[1],
 					dostype[2], dostype[3] + '@' );
 			else
-				printk(" (%c%c%c%c)",
+				snprintf(tmp, sizeof(tmp), " (%c%c%c%c)",
 					dostype[0], dostype[1],
 					dostype[2], dostype[3]);
-			printk("(res %d spb %d)",
+			strlcat(state->pp_buf, tmp, PAGE_SIZE);
+			snprintf(tmp, sizeof(tmp), "(res %d spb %d)",
 				be32_to_cpu(pb->pb_Environment[6]),
 				be32_to_cpu(pb->pb_Environment[4]));
+			strlcat(state->pp_buf, tmp, PAGE_SIZE);
 		}
 		res = 1;
 	}
-	printk("\n");
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 
 rdb_done:
 	return res;
diff -puN fs/partitions/atari.c~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/atari.c
--- a/fs/partitions/atari.c~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/atari.c
@@ -62,7 +62,7 @@ int atari_partition(struct parsed_partit
 	}
 
 	pi = &rs->part[0];
-	printk (" AHDI");
+	strlcat(state->pp_buf, " AHDI", PAGE_SIZE);
 	for (slot = 1; pi < &rs->part[4] && slot < state->limit; slot++, pi++) {
 		struct rootsector *xrs;
 		Sector sect2;
@@ -81,7 +81,7 @@ int atari_partition(struct parsed_partit
 #ifdef ICD_PARTS
 		part_fmt = 1;
 #endif
-		printk(" XGM<");
+		strlcat(state->pp_buf, " XGM<", PAGE_SIZE);
 		partsect = extensect = be32_to_cpu(pi->st);
 		while (1) {
 			xrs = read_part_sector(state, partsect, &sect2);
@@ -120,14 +120,14 @@ int atari_partition(struct parsed_partit
 				break;
 			}
 		}
-		printk(" >");
+		strlcat(state->pp_buf, " >", PAGE_SIZE);
 	}
 #ifdef ICD_PARTS
 	if ( part_fmt!=1 ) { /* no extended partitions -> test ICD-format */
 		pi = &rs->icdpart[0];
 		/* sanity check: no ICD format if first partition invalid */
 		if (OK_id(pi->id)) {
-			printk(" ICD<");
+			strlcat(state->pp_buf, " ICD<", PAGE_SIZE);
 			for (; pi < &rs->icdpart[8] && slot < state->limit; slot++, pi++) {
 				/* accept only GEM,BGM,RAW,LNX,SWP partitions */
 				if (!((pi->flg & 1) && OK_id(pi->id)))
@@ -137,13 +137,13 @@ int atari_partition(struct parsed_partit
 						be32_to_cpu(pi->st),
 						be32_to_cpu(pi->siz));
 			}
-			printk(" >");
+			strlcat(state->pp_buf, " >", PAGE_SIZE);
 		}
 	}
 #endif
 	put_dev_sector(sect);
 
-	printk ("\n");
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 
 	return 1;
 }
diff -puN fs/partitions/check.c~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/check.c
--- a/fs/partitions/check.c~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/check.c
@@ -164,10 +164,16 @@ check_partition(struct gendisk *hd, stru
 	state = kzalloc(sizeof(struct parsed_partitions), GFP_KERNEL);
 	if (!state)
 		return NULL;
+	state->pp_buf = (char *)__get_free_page(GFP_KERNEL);
+	if (!state->pp_buf) {
+		kfree(state);
+		return NULL;
+	}
+	state->pp_buf[0] = '\0';
 
 	state->bdev = bdev;
 	disk_name(hd, 0, state->name);
-	printk(KERN_INFO " %s:", state->name);
+	snprintf(state->pp_buf, PAGE_SIZE, " %s:", state->name);
 	if (isdigit(state->name[strlen(state->name)-1]))
 		sprintf(state->name, "p");
 
@@ -185,17 +191,25 @@ check_partition(struct gendisk *hd, stru
 		}
 
 	}
-	if (res > 0)
+	if (res > 0) {
+		printk(KERN_INFO "%s", state->pp_buf);
+
+		free_page((unsigned long)state->pp_buf);
 		return state;
+	}
 	if (state->access_beyond_eod)
 		err = -ENOSPC;
 	if (err)
 	/* The partition is unrecognized. So report I/O errors if there were any */
 		res = err;
 	if (!res)
-		printk(" unknown partition table\n");
+		strlcat(state->pp_buf, " unknown partition table\n", PAGE_SIZE);
 	else if (warn_no_part)
-		printk(" unable to read partition table\n");
+		strlcat(state->pp_buf, " unable to read partition table\n", PAGE_SIZE);
+
+	printk(KERN_INFO "%s", state->pp_buf);
+
+	free_page((unsigned long)state->pp_buf);
 	kfree(state);
 	return ERR_PTR(res);
 }
diff -puN fs/partitions/check.h~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/check.h
--- a/fs/partitions/check.h~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/check.h
@@ -16,6 +16,7 @@ struct parsed_partitions {
 	int next;
 	int limit;
 	bool access_beyond_eod;
+	char *pp_buf;
 };
 
 static inline void *read_part_sector(struct parsed_partitions *state,
@@ -32,9 +33,12 @@ static inline void
 put_partition(struct parsed_partitions *p, int n, sector_t from, sector_t size)
 {
 	if (n < p->limit) {
+		char tmp[1 + BDEVNAME_SIZE + 10 + 1];
+
 		p->parts[n].from = from;
 		p->parts[n].size = size;
-		printk(" %s%d", p->name, n);
+		snprintf(tmp, sizeof(tmp), " %s%d", p->name, n);
+		strlcat(p->pp_buf, tmp, PAGE_SIZE);
 	}
 }
 
diff -puN fs/partitions/efi.c~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/efi.c
--- a/fs/partitions/efi.c~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/efi.c
@@ -630,6 +630,6 @@ int efi_partition(struct parsed_partitio
 	}
 	kfree(ptes);
 	kfree(gpt);
-	printk("\n");
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 	return 1;
 }
diff -puN fs/partitions/ibm.c~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/ibm.c
--- a/fs/partitions/ibm.c~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/ibm.c
@@ -74,6 +74,7 @@ int ibm_partition(struct parsed_partitio
 	} *label;
 	unsigned char *data;
 	Sector sect;
+	char tmp[64];
 
 	res = 0;
 	blocksize = bdev_logical_block_size(bdev);
@@ -134,13 +135,15 @@ int ibm_partition(struct parsed_partitio
 			 */
 			blocksize = label->cms.block_size;
 			if (label->cms.disk_offset != 0) {
-				printk("CMS1/%8s(MDSK):", name);
+				snprintf(tmp, sizeof(tmp), "CMS1/%8s(MDSK):", name);
+				strlcat(state->pp_buf, tmp, PAGE_SIZE);
 				/* disk is reserved minidisk */
 				offset = label->cms.disk_offset;
 				size = (label->cms.block_count - 1)
 					* (blocksize >> 9);
 			} else {
-				printk("CMS1/%8s:", name);
+				snprintf(tmp, sizeof(tmp), "CMS1/%8s:", name);
+				strlcat(state->pp_buf, tmp, PAGE_SIZE);
 				offset = (info->label_block + 1);
 				size = label->cms.block_count
 					* (blocksize >> 9);
@@ -149,7 +152,8 @@ int ibm_partition(struct parsed_partitio
 				      size-offset*(blocksize >> 9));
 		} else {
 			if (strncmp(type, "LNX1", 4) == 0) {
-				printk("LNX1/%8s:", name);
+				snprintf(tmp, sizeof(tmp), "LNX1/%8s:", name);
+				strlcat(state->pp_buf, tmp, PAGE_SIZE);
 				if (label->lnx.ldl_version == 0xf2) {
 					fmt_size = label->lnx.formatted_blocks
 						* (blocksize >> 9);
@@ -168,7 +172,7 @@ int ibm_partition(struct parsed_partitio
 				offset = (info->label_block + 1);
 			} else {
 				/* unlabeled disk */
-				printk("(nonl)");
+				strlcat(tmp, sizeof(tmp), "(nonl)", PAGE_SIZE);
 				size = i_size >> 9;
 				offset = (info->label_block + 1);
 			}
@@ -187,7 +191,8 @@ int ibm_partition(struct parsed_partitio
 		 * if not, something is wrong, skipping partition detection
 		 */
 		if (strncmp(type, "VOL1",  4) == 0) {
-			printk("VOL1/%8s:", name);
+			snprintf(tmp, sizeof(tmp), "VOL1/%8s:", name);
+			strlcat(state->pp_buf, tmp, PAGE_SIZE);
 			/*
 			 * get block number and read then go through format1
 			 * labels
@@ -243,7 +248,7 @@ int ibm_partition(struct parsed_partitio
 
 	}
 
-	printk("\n");
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 	goto out_freeall;
 
 
diff -puN fs/partitions/karma.c~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/karma.c
--- a/fs/partitions/karma.c~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/karma.c
@@ -50,7 +50,7 @@ int karma_partition(struct parsed_partit
 		}
 		slot++;
 	}
-	printk("\n");
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 	put_dev_sector(sect);
 	return 1;
 }
diff -puN fs/partitions/ldm.c~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/ldm.c
--- a/fs/partitions/ldm.c~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/ldm.c
@@ -643,7 +643,7 @@ static bool ldm_create_data_partitions (
 		return false;
 	}
 
-	printk (" [LDM]");
+	strlcat(pp->pp_buf, " [LDM]", PAGE_SIZE);
 
 	/* Create the data partitions */
 	list_for_each (item, &ldb->v_part) {
@@ -658,7 +658,7 @@ static bool ldm_create_data_partitions (
 		part_num++;
 	}
 
-	printk ("\n");
+	strlcat(pp->pp_buf, "\n", PAGE_SIZE);
 	return true;
 }
 
diff -puN fs/partitions/mac.c~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/mac.c
--- a/fs/partitions/mac.c~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/mac.c
@@ -59,7 +59,7 @@ int mac_partition(struct parsed_partitio
 		put_dev_sector(sect);
 		return 0;		/* not a MacOS disk */
 	}
-	printk(" [mac]");
+	strlcat(state->pp_buf, " [mac]", PAGE_SIZE);
 	blocks_in_map = be32_to_cpu(part->map_count);
 	for (blk = 1; blk <= blocks_in_map; ++blk) {
 		int pos = blk * secsize;
@@ -128,6 +128,6 @@ int mac_partition(struct parsed_partitio
 #endif
 
 	put_dev_sector(sect);
-	printk("\n");
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 	return 1;
 }
diff -puN fs/partitions/msdos.c~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/msdos.c
--- a/fs/partitions/msdos.c~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/msdos.c
@@ -213,10 +213,18 @@ static void parse_solaris_x86(struct par
 		put_dev_sector(sect);
 		return;
 	}
-	printk(" %s%d: <solaris:", state->name, origin);
+	{
+		char tmp[1 + BDEVNAME_SIZE + 10 + 11 + 1];
+
+		snprintf(tmp, sizeof(tmp), " %s%d: <solaris:", state->name, origin);
+		strlcat(state->pp_buf, tmp, PAGE_SIZE);
+	}
 	if (le32_to_cpu(v->v_version) != 1) {
-		printk("  cannot handle version %d vtoc>\n",
-			le32_to_cpu(v->v_version));
+		char tmp[64];
+
+		snprintf(tmp, sizeof(tmp), "  cannot handle version %d vtoc>\n",
+			 le32_to_cpu(v->v_version));
+		strlcat(state->pp_buf, tmp, PAGE_SIZE);
 		put_dev_sector(sect);
 		return;
 	}
@@ -224,9 +232,12 @@ static void parse_solaris_x86(struct par
 	max_nparts = le16_to_cpu (v->v_nparts) > 8 ? SOLARIS_X86_NUMSLICE : 8;
 	for (i=0; i<max_nparts && state->next<state->limit; i++) {
 		struct solaris_x86_slice *s = &v->v_slice[i];
+		char tmp[3 + 10 + 1 + 1];
+
 		if (s->s_size == 0)
 			continue;
-		printk(" [s%d]", i);
+		snprintf(tmp, sizeof(tmp), " [s%d]", i);
+		strlcat(state->pp_buf, tmp, PAGE_SIZE);
 		/* solaris partitions are relative to current MS-DOS
 		 * one; must add the offset of the current partition */
 		put_partition(state, state->next++,
@@ -234,7 +245,7 @@ static void parse_solaris_x86(struct par
 				 le32_to_cpu(s->s_size));
 	}
 	put_dev_sector(sect);
-	printk(" >\n");
+	strlcat(state->pp_buf, " >\n", PAGE_SIZE);
 #endif
 }
 
@@ -250,6 +261,7 @@ static void parse_bsd(struct parsed_part
 	Sector sect;
 	struct bsd_disklabel *l;
 	struct bsd_partition *p;
+	char tmp[64];
 
 	l = read_part_sector(state, offset + 1, &sect);
 	if (!l)
@@ -258,7 +270,9 @@ static void parse_bsd(struct parsed_part
 		put_dev_sector(sect);
 		return;
 	}
-	printk(" %s%d: <%s:", state->name, origin, flavour);
+
+	snprintf(tmp, sizeof(tmp), " %s%d: <%s:", state->name, origin, flavour);
+	strlcat(state->pp_buf, tmp, PAGE_SIZE);
 
 	if (le16_to_cpu(l->d_npartitions) < max_partitions)
 		max_partitions = le16_to_cpu(l->d_npartitions);
@@ -275,16 +289,18 @@ static void parse_bsd(struct parsed_part
 			/* full parent partition, we have it already */
 			continue;
 		if (offset > bsd_start || offset+size < bsd_start+bsd_size) {
-			printk("bad subpartition - ignored\n");
+			strlcat(state->pp_buf, "bad subpartition - ignored\n", PAGE_SIZE);
 			continue;
 		}
 		put_partition(state, state->next++, bsd_start, bsd_size);
 	}
 	put_dev_sector(sect);
-	if (le16_to_cpu(l->d_npartitions) > max_partitions)
-		printk(" (ignored %d more)",
-		       le16_to_cpu(l->d_npartitions) - max_partitions);
-	printk(" >\n");
+	if (le16_to_cpu(l->d_npartitions) > max_partitions) {
+		snprintf(tmp, sizeof(tmp), " (ignored %d more)",
+			 le16_to_cpu(l->d_npartitions) - max_partitions);
+		strlcat(state->pp_buf, tmp, PAGE_SIZE);
+	}
+	strlcat(state->pp_buf, " >\n", PAGE_SIZE);
 }
 #endif
 
@@ -333,7 +349,12 @@ static void parse_unixware(struct parsed
 		put_dev_sector(sect);
 		return;
 	}
-	printk(" %s%d: <unixware:", state->name, origin);
+	{
+		char tmp[1 + BDEVNAME_SIZE + 10 + 12 + 1];
+
+		snprintf(tmp, sizeof(tmp), " %s%d: <unixware:", state->name, origin);
+		strlcat(state->pp_buf, tmp, PAGE_SIZE);
+	}
 	p = &l->vtoc.v_slice[1];
 	/* I omit the 0th slice as it is the same as whole disk. */
 	while (p - &l->vtoc.v_slice[0] < UNIXWARE_NUMSLICE) {
@@ -347,7 +368,7 @@ static void parse_unixware(struct parsed
 		p++;
 	}
 	put_dev_sector(sect);
-	printk(" >\n");
+	strlcat(state->pp_buf, " >\n", PAGE_SIZE);
 #endif
 }
 
@@ -376,8 +397,10 @@ static void parse_minix(struct parsed_pa
 	 * the normal boot sector. */
 	if (msdos_magic_present (data + 510) &&
 	    SYS_IND(p) == MINIX_PARTITION) { /* subpartition table present */
+		char tmp[1 + BDEVNAME_SIZE + 10 + 9 + 1];
 
-		printk(" %s%d: <minix:", state->name, origin);
+		snprintf(tmp, sizeof(tmp), " %s%d: <minix:", state->name, origin);
+		strlcat(state->pp_buf, tmp, PAGE_SIZE);
 		for (i = 0; i < MINIX_NR_SUBPARTITIONS; i++, p++) {
 			if (state->next == state->limit)
 				break;
@@ -386,7 +409,7 @@ static void parse_minix(struct parsed_pa
 				put_partition(state, state->next++,
 					      start_sect(p), nr_sects(p));
 		}
-		printk(" >\n");
+		strlcat(state->pp_buf, " >\n", PAGE_SIZE);
 	}
 	put_dev_sector(sect);
 #endif /* CONFIG_MINIX_SUBPARTITION */
@@ -425,7 +448,7 @@ int msdos_partition(struct parsed_partit
 
 	if (aix_magic_present(state, data)) {
 		put_dev_sector(sect);
-		printk( " [AIX]");
+		strlcat(state->pp_buf, " [AIX]", PAGE_SIZE);
 		return 0;
 	}
 
@@ -446,7 +469,7 @@ int msdos_partition(struct parsed_partit
 			fb = (struct fat_boot_sector *) data;
 			if (slot == 1 && fb->reserved && fb->fats
 				&& fat_valid_media(fb->media)) {
-				printk("\n");
+				strlcat(state->pp_buf, "\n", PAGE_SIZE);
 				put_dev_sector(sect);
 				return 1;
 			} else {
@@ -491,21 +514,21 @@ int msdos_partition(struct parsed_partit
 			n = min(size, max(sector_size, n));
 			put_partition(state, slot, start, n);
 
-			printk(" <");
+			strlcat(state->pp_buf, " <", PAGE_SIZE);
 			parse_extended(state, start, size);
-			printk(" >");
+			strlcat(state->pp_buf, " >", PAGE_SIZE);
 			continue;
 		}
 		put_partition(state, slot, start, size);
 		if (SYS_IND(p) == LINUX_RAID_PARTITION)
 			state->parts[slot].flags = ADDPART_FLAG_RAID;
 		if (SYS_IND(p) == DM6_PARTITION)
-			printk("[DM]");
+			strlcat(state->pp_buf, "[DM]", PAGE_SIZE);
 		if (SYS_IND(p) == EZD_PARTITION)
-			printk("[EZD]");
+			strlcat(state->pp_buf, "[EZD]", PAGE_SIZE);
 	}
 
-	printk("\n");
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 
 	/* second pass - output for each on a separate line */
 	p = (struct partition *) (0x1be + data);
diff -puN fs/partitions/osf.c~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/osf.c
--- a/fs/partitions/osf.c~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/osf.c
@@ -72,7 +72,7 @@ int osf_partition(struct parsed_partitio
 				le32_to_cpu(partition->p_size));
 		slot++;
 	}
-	printk("\n");
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 	put_dev_sector(sect);
 	return 1;
 }
diff -puN fs/partitions/sgi.c~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/sgi.c
--- a/fs/partitions/sgi.c~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/sgi.c
@@ -76,7 +76,7 @@ int sgi_partition(struct parsed_partitio
 		}
 		slot++;
 	}
-	printk("\n");
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 	put_dev_sector(sect);
 	return 1;
 }
diff -puN fs/partitions/sun.c~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/sun.c
--- a/fs/partitions/sun.c~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/sun.c
@@ -116,7 +116,7 @@ int sun_partition(struct parsed_partitio
 		}
 		slot++;
 	}
-	printk("\n");
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 	put_dev_sector(sect);
 	return 1;
 }
diff -puN fs/partitions/sysv68.c~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/sysv68.c
--- a/fs/partitions/sysv68.c~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/sysv68.c
@@ -54,6 +54,7 @@ int sysv68_partition(struct parsed_parti
 	unsigned char *data;
 	struct dkblk0 *b;
 	struct slice *slice;
+	char tmp[64];
 
 	data = read_part_sector(state, 0, &sect);
 	if (!data)
@@ -73,7 +74,8 @@ int sysv68_partition(struct parsed_parti
 		return -1;
 
 	slices -= 1; /* last slice is the whole disk */
-	printk("sysV68: %s(s%u)", state->name, slices);
+	snprintf(tmp, sizeof(tmp), "sysV68: %s(s%u)", state->name, slices);
+	strlcat(state->pp_buf, tmp, PAGE_SIZE);
 	slice = (struct slice *)data;
 	for (i = 0; i < slices; i++, slice++) {
 		if (slot == state->limit)
@@ -82,11 +84,12 @@ int sysv68_partition(struct parsed_parti
 			put_partition(state, slot,
 				be32_to_cpu(slice->blkoff),
 				be32_to_cpu(slice->nblocks));
-			printk("(s%u)", i);
+			snprintf(tmp, sizeof(tmp), "(s%u)", i);
+			strlcat(state->pp_buf, tmp, PAGE_SIZE);
 		}
 		slot++;
 	}
-	printk("\n");
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 	put_dev_sector(sect);
 	return 1;
 }
diff -puN fs/partitions/ultrix.c~partitions-fix-sometimes-unreadable-partition-strings fs/partitions/ultrix.c
--- a/fs/partitions/ultrix.c~partitions-fix-sometimes-unreadable-partition-strings
+++ a/fs/partitions/ultrix.c
@@ -39,7 +39,7 @@ int ultrix_partition(struct parsed_parti
 					      label->pt_part[i].pi_blkoff,
 					      label->pt_part[i].pi_nblocks);
 		put_dev_sector(sect);
-		printk ("\n");
+		strlcat(state->pp_buf, "\n", PAGE_SIZE);
 		return 1;
 	} else {
 		put_dev_sector(sect);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
mpt-fusion-convert-to-seq_file.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm-provide-init_mm-mm_context-initializer.patch
partitions-fix-sometimes-unreadable-partition-strings.patch

