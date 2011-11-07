From: akpm@linux-foundation.org
Subject: [merged] init-add-root=partuuid=uuid-partnroff=%d-support.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:28:13 -0800
Message-ID: <201111072028.pA7KSDee030108@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47446 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1KGU2c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:28:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wad@chromium.org, Trond.Myklebust@netapp.com, axboe@kernel.dk, kay.sievers@vrfy.org, namhyung@gmail.com, rdunlap@xenotime.net, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: init: add root=PARTUUID=UUID/PARTNROFF=%d support
has been removed from the -mm tree.  Its filename was
     init-add-root=partuuid=uuid-partnroff=%d-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Will Drewry <wad@chromium.org>
Subject: init: add root=PARTUUID=UUID/PARTNROFF=%d support

Expand root=PARTUUID=UUID syntax to support selecting a root partition by
integer offset from a known, unique partition.  This approach provides
similar properties to specifying a device and partition number, but using
the UUID as the unique path prior to evaluating the offset.

For example,
  root=PARTUUID=99DE9194-FC15-4223-9192-FC243948F88B/PARTNROFF=1
selects the partition with UUID 99DE.. then select the next
partition.

This change is motivated by a particular usecase in Chromium OS where the
bootloader can easily determine what partition it is on (by UUID) but
doesn't perform general partition table walking.

That said, support for this model provides a direct mechanism for the user
to modify the root partition to boot without specifically needing to
extract each UUID or update the bootloader explicitly when the root
partition UUID is changed (if it is recreated to be larger, for instance).
 Pinning to a /boot-style partition UUID allows the arbitrary root
partition reconfiguration/modifications with slightly less ambiguity than
just [dev][partition] and less stringency than the specific root partition
UUID.

[sfr@canb.auug.org.au: fix init sections warning]
Signed-off-by: Will Drewry <wad@chromium.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |   48 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 5 deletions(-)

diff -puN init/do_mounts.c~init-add-root=partuuid=uuid-partnroff=%d-support init/do_mounts.c
--- a/init/do_mounts.c~init-add-root=partuuid=uuid-partnroff=%d-support
+++ a/init/do_mounts.c
@@ -28,7 +28,7 @@ int __initdata rd_doload;	/* 1 = load RA
 int root_mountflags = MS_RDONLY | MS_SILENT;
 static char * __initdata root_device_name;
 static char __initdata saved_root_name[64];
-static int __initdata root_wait;
+static int root_wait;
 
 dev_t ROOT_DEV;
 
@@ -85,12 +85,15 @@ no_match:
 
 /**
  * devt_from_partuuid - looks up the dev_t of a partition by its UUID
- * @uuid:	36 byte char array containing a hex ascii UUID
+ * @uuid:	min 36 byte char array containing a hex ascii UUID
  *
  * The function will return the first partition which contains a matching
  * UUID value in its partition_meta_info struct.  This does not search
  * by filesystem UUIDs.
  *
+ * If @uuid is followed by a "/PARTNROFF=%d", then the number will be
+ * extracted and used as an offset from the partition identified by the UUID.
+ *
  * Returns the matching dev_t on success or 0 on failure.
  */
 static dev_t devt_from_partuuid(char *uuid_str)
@@ -98,6 +101,28 @@ static dev_t devt_from_partuuid(char *uu
 	dev_t res = 0;
 	struct device *dev = NULL;
 	u8 uuid[16];
+	struct gendisk *disk;
+	struct hd_struct *part;
+	int offset = 0;
+
+	if (strlen(uuid_str) < 36)
+		goto done;
+
+	/* Check for optional partition number offset attributes. */
+	if (uuid_str[36]) {
+		char c = 0;
+		/* Explicitly fail on poor PARTUUID syntax. */
+		if (sscanf(&uuid_str[36],
+			   "/PARTNROFF=%d%c", &offset, &c) != 1) {
+			printk(KERN_ERR "VFS: PARTUUID= is invalid.\n"
+			 "Expected PARTUUID=<valid-uuid-id>[/PARTNROFF=%%d]\n");
+			if (root_wait)
+				printk(KERN_ERR
+				     "Disabling rootwait; root= is invalid.\n");
+			root_wait = 0;
+			goto done;
+		}
+	}
 
 	/* Pack the requested UUID in the expected format. */
 	part_pack_uuid(uuid_str, uuid);
@@ -107,8 +132,21 @@ static dev_t devt_from_partuuid(char *uu
 		goto done;
 
 	res = dev->devt;
-	put_device(dev);
 
+	/* Attempt to find the partition by offset. */
+	if (!offset)
+		goto no_offset;
+
+	res = 0;
+	disk = part_to_disk(dev_to_part(dev));
+	part = disk_get_part(disk, dev_to_part(dev)->partno + offset);
+	if (part) {
+		res = part_devt(part);
+		put_device(part_to_dev(part));
+	}
+
+no_offset:
+	put_device(dev);
 done:
 	return res;
 }
@@ -126,6 +164,8 @@ done:
  *	   used when disk name of partitioned disk ends on a digit.
  *	6) PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF representing the
  *	   unique id of a partition if the partition table provides it.
+ *	7) PARTUUID=<UUID>/PARTNROFF=<int> to select a partition in relation to
+ *	   a partition with a known unique id.
  *
  *	If name doesn't have fall into the categories above, we return (0,0).
  *	block_class is used to check if something is a disk name. If the disk
@@ -143,8 +183,6 @@ dev_t name_to_dev_t(char *name)
 #ifdef CONFIG_BLOCK
 	if (strncmp(name, "PARTUUID=", 9) == 0) {
 		name += 9;
-		if (strlen(name) != 36)
-			goto fail;
 		res = devt_from_partuuid(name);
 		if (!res)
 			goto fail;
_

Patches currently in -mm which might be from wad@chromium.org are

origin.patch

