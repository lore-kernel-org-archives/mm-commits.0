From: akpm@linux-foundation.org
Subject: + block-partition-msdos-provide-uuids-for-partitions.patch added to -mm tree
Date: Fri, 24 Aug 2012 15:23:53 -0700
Message-ID: <20120824222354.BE02C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:34671 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab2HXWX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 18:23:57 -0400
Received: by wibhr14 with SMTP id hr14so57904wib.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 15:23:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: swarren@nvidia.com, axboe@kernel.dk, kay.sievers@vrfy.org, tj@kernel.org, wad@chromium.org


The patch titled
     Subject: block: partition: msdos: provide UUIDs for partitions
has been added to the -mm tree.  Its filename is
     block-partition-msdos-provide-uuids-for-partitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Warren <swarren@nvidia.com>
Subject: block: partition: msdos: provide UUIDs for partitions

The MSDOS/MBR partition table includes a 32-bit unique ID, often referred
to as the NT disk signature.  When combined with a partition number within
the table, this can form a unique ID similar in concept to EFI/GPT's
partition UUID.  Constructing and recording this value in struct
partition_meta_info allows MSDOS partitions to be referred to on the
kernel command-line using the following syntax:

root=PARTUUID=0002dd75-01

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/msdos.c |   21 +++++++++++++++++++--
 init/do_mounts.c         |    4 ++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff -puN block/partitions/msdos.c~block-partition-msdos-provide-uuids-for-partitions block/partitions/msdos.c
--- a/block/partitions/msdos.c~block-partition-msdos-provide-uuids-for-partitions
+++ a/block/partitions/msdos.c
@@ -94,6 +94,17 @@ static int aix_magic_present(struct pars
 	return ret;
 }
 
+static void set_info(struct parsed_partitions *state, int slot,
+		     u32 disksig)
+{
+	struct partition_meta_info *info = &state->parts[slot].info;
+
+	snprintf(info->uuid, sizeof(info->uuid), "%08x-%02x", disksig,
+		 slot);
+	info->volname[0] = 0;
+	state->parts[slot].has_info = true;
+}
+
 /*
  * Create devices for each logical partition in an extended partition.
  * The logical partitions form a linked list, with each entry being
@@ -106,7 +117,8 @@ static int aix_magic_present(struct pars
  */
 
 static void parse_extended(struct parsed_partitions *state,
-			   sector_t first_sector, sector_t first_size)
+			   sector_t first_sector, sector_t first_size,
+			   u32 disksig)
 {
 	struct partition *p;
 	Sector sect;
@@ -166,6 +178,7 @@ static void parse_extended(struct parsed
 			}
 
 			put_partition(state, state->next, next, size);
+			set_info(state, state->next, disksig);
 			if (SYS_IND(p) == LINUX_RAID_PARTITION)
 				state->parts[state->next].flags = ADDPART_FLAG_RAID;
 			loopct = 0;
@@ -437,6 +450,7 @@ int msdos_partition(struct parsed_partit
 	struct partition *p;
 	struct fat_boot_sector *fb;
 	int slot;
+	u32 disksig;
 
 	data = read_part_sector(state, 0, &sect);
 	if (!data)
@@ -491,6 +505,8 @@ int msdos_partition(struct parsed_partit
 #endif
 	p = (struct partition *) (data + 0x1be);
 
+	disksig = le32_to_cpup((__le32 *)(data + 0x1b8));
+
 	/*
 	 * Look for partitions in two passes:
 	 * First find the primary and DOS-type extended partitions.
@@ -515,11 +531,12 @@ int msdos_partition(struct parsed_partit
 			put_partition(state, slot, start, n);
 
 			strlcat(state->pp_buf, " <", PAGE_SIZE);
-			parse_extended(state, start, size);
+			parse_extended(state, start, size, disksig);
 			strlcat(state->pp_buf, " >", PAGE_SIZE);
 			continue;
 		}
 		put_partition(state, slot, start, size);
+		set_info(state, slot, disksig);
 		if (SYS_IND(p) == LINUX_RAID_PARTITION)
 			state->parts[slot].flags = ADDPART_FLAG_RAID;
 		if (SYS_IND(p) == DM6_PARTITION)
diff -puN init/do_mounts.c~block-partition-msdos-provide-uuids-for-partitions init/do_mounts.c
--- a/init/do_mounts.c~block-partition-msdos-provide-uuids-for-partitions
+++ a/init/do_mounts.c
@@ -189,6 +189,10 @@ done:
  *	   used when disk name of partitioned disk ends on a digit.
  *	6) PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF representing the
  *	   unique id of a partition if the partition table provides it.
+ *	   The UUID may be either an EFI/GPT UUID, or refer to an MSDOS
+ *	   partition using the format SSSSSSSS-PP, where SSSSSSSS is a zero-
+ *	   filled hex representation of the 32-bit "NT disk signature", and PP
+ *	   is a zero-filled hex representation of the 1-based partition number.
  *	7) PARTUUID=<UUID>/PARTNROFF=<int> to select a partition in relation to
  *	   a partition with a known unique id.
  *
_

Patches currently in -mm which might be from swarren@nvidia.com are

linux-next.patch
block-store-partition_meta_infouuid-as-a-string.patch
init-reduce-partuuid-min-length-to-1-from-36.patch
block-partition-msdos-provide-uuids-for-partitions.patch
rtc-add-max8907-rtc-driver.patch

