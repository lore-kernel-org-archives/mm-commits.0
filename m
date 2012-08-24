From: akpm@linux-foundation.org
Subject: + block-store-partition_meta_infouuid-as-a-string.patch added to -mm tree
Date: Fri, 24 Aug 2012 15:23:45 -0700
Message-ID: <20120824222346.A170D5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:50317 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760150Ab2HXWXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 18:23:49 -0400
Received: by lbbge1 with SMTP id ge1so112649lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 15:23:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: swarren@nvidia.com, axboe@kernel.dk, kay.sievers@vrfy.org, tj@kernel.org, wad@chromium.org


The patch titled
     Subject: block: store partition_meta_info.uuid as a string
has been added to the -mm tree.  Its filename is
     block-store-partition_meta_infouuid-as-a-string.patch

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
Subject: block: store partition_meta_info.uuid as a string

This will allow other types of UUID to be stored here, aside from true
UUIDs.  This also simplifies code that uses this field, since it's usually
constructed from a, used as a, or compared to other, strings.

Note: A simplistic approach here would be to set uuid_str[36]=0 whenever a
/PARTNROFF option was found to be present.  However, this modifies the
input string, and causes subsequent calls to devt_from_partuuid() not to
see the /PARTNROFF option, which causes different results.  In order to
avoid misleading future maintainers, this parameter is marked const.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c          |    8 +-------
 block/partitions/efi.c |    7 +------
 include/linux/genhd.h  |    8 ++++++--
 init/do_mounts.c       |   28 +++++++++++++++++-----------
 4 files changed, 25 insertions(+), 26 deletions(-)

diff -puN block/genhd.c~block-store-partition_meta_infouuid-as-a-string block/genhd.c
--- a/block/genhd.c~block-store-partition_meta_infouuid-as-a-string
+++ a/block/genhd.c
@@ -743,7 +743,6 @@ void __init printk_all_partitions(void)
 		struct hd_struct *part;
 		char name_buf[BDEVNAME_SIZE];
 		char devt_buf[BDEVT_SIZE];
-		char uuid_buf[PARTITION_META_INFO_UUIDLTH * 2 + 5];
 
 		/*
 		 * Don't show empty devices or things that have been
@@ -762,16 +761,11 @@ void __init printk_all_partitions(void)
 		while ((part = disk_part_iter_next(&piter))) {
 			bool is_part0 = part == &disk->part0;
 
-			uuid_buf[0] = '\0';
-			if (part->info)
-				snprintf(uuid_buf, sizeof(uuid_buf), "%pU",
-					 part->info->uuid);
-
 			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
 			       (unsigned long long)part_nr_sects_read(part) >> 1
 			       , disk_name(disk, part->partno, name_buf),
-			       uuid_buf);
+			       part->info ? part->info->uuid : "");
 			if (is_part0) {
 				if (disk->driverfs_dev != NULL &&
 				    disk->driverfs_dev->driver != NULL)
diff -puN block/partitions/efi.c~block-store-partition_meta_infouuid-as-a-string block/partitions/efi.c
--- a/block/partitions/efi.c~block-store-partition_meta_infouuid-as-a-string
+++ a/block/partitions/efi.c
@@ -620,7 +620,6 @@ int efi_partition(struct parsed_partitio
 	gpt_entry *ptes = NULL;
 	u32 i;
 	unsigned ssz = bdev_logical_block_size(state->bdev) / 512;
-	u8 unparsed_guid[37];
 
 	if (!find_valid_gpt(state, &gpt, &ptes) || !gpt || !ptes) {
 		kfree(gpt);
@@ -649,11 +648,7 @@ int efi_partition(struct parsed_partitio
 			state->parts[i + 1].flags = ADDPART_FLAG_RAID;
 
 		info = &state->parts[i + 1].info;
-		/* Instead of doing a manual swap to big endian, reuse the
-		 * common ASCII hex format as the interim.
-		 */
-		efi_guid_unparse(&ptes[i].unique_partition_guid, unparsed_guid);
-		part_pack_uuid(unparsed_guid, info->uuid);
+		efi_guid_unparse(&ptes[i].unique_partition_guid, info->uuid);
 
 		/* Naively convert UTF16-LE to 7 bits. */
 		label_max = min(sizeof(info->volname) - 1,
diff -puN include/linux/genhd.h~block-store-partition_meta_infouuid-as-a-string include/linux/genhd.h
--- a/include/linux/genhd.h~block-store-partition_meta_infouuid-as-a-string
+++ a/include/linux/genhd.h
@@ -88,10 +88,14 @@ struct disk_stats {
 };
 
 #define PARTITION_META_INFO_VOLNAMELTH	64
-#define PARTITION_META_INFO_UUIDLTH	16
+/*
+ * Enough for the string representation of any kind of UUID plus NULL.
+ * EFI UUID is 36 characters. MSDOS UUID is 11 characters.
+ */
+#define PARTITION_META_INFO_UUIDLTH	37
 
 struct partition_meta_info {
-	u8 uuid[PARTITION_META_INFO_UUIDLTH];	/* always big endian */
+	char uuid[PARTITION_META_INFO_UUIDLTH];
 	u8 volname[PARTITION_META_INFO_VOLNAMELTH];
 };
 
diff -puN init/do_mounts.c~block-store-partition_meta_infouuid-as-a-string init/do_mounts.c
--- a/init/do_mounts.c~block-store-partition_meta_infouuid-as-a-string
+++ a/init/do_mounts.c
@@ -69,23 +69,28 @@ __setup("ro", readonly);
 __setup("rw", readwrite);
 
 #ifdef CONFIG_BLOCK
+struct uuidcmp {
+	const char *uuid;
+	int len;
+};
+
 /**
  * match_dev_by_uuid - callback for finding a partition using its uuid
  * @dev:	device passed in by the caller
- * @data:	opaque pointer to a 36 byte char array with a UUID
+ * @data:	opaque pointer to the desired struct uuidcmp to match
  *
  * Returns 1 if the device matches, and 0 otherwise.
  */
 static int match_dev_by_uuid(struct device *dev, void *data)
 {
-	u8 *uuid = data;
+	struct uuidcmp *cmp = data;
 	struct hd_struct *part = dev_to_part(dev);
 
 	if (!part->info)
 		goto no_match;
 
-	if (memcmp(uuid, part->info->uuid, sizeof(part->info->uuid)))
-			goto no_match;
+	if (strncasecmp(cmp->uuid, part->info->uuid, cmp->len))
+		goto no_match;
 
 	return 1;
 no_match:
@@ -95,7 +100,7 @@ no_match:
 
 /**
  * devt_from_partuuid - looks up the dev_t of a partition by its UUID
- * @uuid:	min 36 byte char array containing a hex ascii UUID
+ * @uuid:	char array containing ascii UUID
  *
  * The function will return the first partition which contains a matching
  * UUID value in its partition_meta_info struct.  This does not search
@@ -106,11 +111,11 @@ no_match:
  *
  * Returns the matching dev_t on success or 0 on failure.
  */
-static dev_t devt_from_partuuid(char *uuid_str)
+static dev_t devt_from_partuuid(const char *uuid_str)
 {
 	dev_t res = 0;
+	struct uuidcmp cmp;
 	struct device *dev = NULL;
-	u8 uuid[16];
 	struct gendisk *disk;
 	struct hd_struct *part;
 	int offset = 0;
@@ -118,6 +123,9 @@ static dev_t devt_from_partuuid(char *uu
 	if (strlen(uuid_str) < 36)
 		goto done;
 
+	cmp.uuid = uuid_str;
+	cmp.len = 36;
+
 	/* Check for optional partition number offset attributes. */
 	if (uuid_str[36]) {
 		char c = 0;
@@ -134,10 +142,8 @@ static dev_t devt_from_partuuid(char *uu
 		}
 	}
 
-	/* Pack the requested UUID in the expected format. */
-	part_pack_uuid(uuid_str, uuid);
