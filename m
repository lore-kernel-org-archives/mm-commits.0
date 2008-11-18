From: akpm@linux-foundation.org
Subject: + md-need-another-print_sb-for-mdp_superblock_1.patch added to -mm tree
Date: Tue, 18 Nov 2008 14:08:45 -0800
Message-ID: <200811182208.mAIM8kZo015479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbYKRWJ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 17:09:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, dan.j.williams@gmail.com, neilb@suse.de


The patch titled
     md: need another print_sb for mdp_superblock_1
has been added to the -mm tree.  Its filename is
     md-need-another-print_sb-for-mdp_superblock_1.patch

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
Subject: md: need another print_sb for mdp_superblock_1
From: Cheng Renquan <crquan@gmail.com>

md_print_devices is called in two code path: MD_BUG(...), and md_ioctl
with PRINT_RAID_DEBUG.  it will dump out all in use md devices
information;

However, it wrongly processed two types of superblock in one:

The header file <linux/raid/md_p.h> has defined two types of superblock,
struct mdp_superblock_s (typedefed with mdp_super_t) according to md with
metadata 0.90, and struct mdp_superblock_1 according to md with metadata
1.0 and later,

These two types of superblock are very different,

The md_print_devices code processed them both in mdp_super_t, that would
lead to wrong informaton dump like:

	[ 6742.345877]
	[ 6742.345887] md:	**********************************
	[ 6742.345890] md:	* <COMPLETE RAID STATE PRINTOUT> *
	[ 6742.345892] md:	**********************************
	[ 6742.345896] md1: <ram7><ram6><ram5><ram4>
	[ 6742.345907] md: rdev ram7, SZ:00065472 F:0 S:1 DN:3
	[ 6742.345909] md: rdev superblock:
	[ 6742.345914] md:  SB: (V:0.90.0) ID:<42ef13c7.598c059a.5f9f1645.801e9ee6> CT:4919856d
	[ 6742.345918] md:     L5 S00065472 ND:4 RD:4 md1 LO:2 CS:65536
	[ 6742.345922] md:     UT:4919856d ST:1 AD:4 WD:4 FD:0 SD:0 CSUM:b7992907 E:00000001
	[ 6742.345924]      D  0:  DISK<N:0,(1,8),R:0,S:6>
	[ 6742.345930]      D  1:  DISK<N:1,(1,10),R:1,S:6>
	[ 6742.345933]      D  2:  DISK<N:2,(1,12),R:2,S:6>
	[ 6742.345937]      D  3:  DISK<N:3,(1,14),R:3,S:6>
	[ 6742.345942] md:     THIS:  DISK<N:3,(1,14),R:3,S:6>
	...
	[ 6742.346058] md0: <ram3><ram2><ram1><ram0>
	[ 6742.346067] md: rdev ram3, SZ:00065472 F:0 S:1 DN:3
	[ 6742.346070] md: rdev superblock:
	[ 6742.346073] md:  SB: (V:1.0.0) ID:<369aad81.00000000.00000000.00000000> CT:9a322a9c
	[ 6742.346077] md:     L-1507699579 S976570180 ND:48 RD:0 md0 LO:65536 CS:196610
	[ 6742.346081] md:     UT:00000018 ST:0 AD:131048 WD:0 FD:8 SD:0 CSUM:00000000 E:00000000
	[ 6742.346084]      D  0:  DISK<N:-1,(-1,-1),R:-1,S:-1>
	[ 6742.346089]      D  1:  DISK<N:-1,(-1,-1),R:-1,S:-1>
	[ 6742.346092]      D  2:  DISK<N:-1,(-1,-1),R:-1,S:-1>
	[ 6742.346096]      D  3:  DISK<N:-1,(-1,-1),R:-1,S:-1>
	[ 6742.346102] md:     THIS:  DISK<N:0,(0,0),R:0,S:0>
	...
	[ 6742.346219] md:	**********************************
	[ 6742.346221]

Here md1 is metadata 0.90.0, and md0 is metadata 1.2

After some more code to distinguish these two types of superblock, in this patch,

it will generate dump information like:

	[ 7906.755790]
	[ 7906.755799] md:	**********************************
	[ 7906.755802] md:	* <COMPLETE RAID STATE PRINTOUT> *
	[ 7906.755804] md:	**********************************
	[ 7906.755808] md1: <ram7><ram6><ram5><ram4>
	[ 7906.755819] md: rdev ram7, SZ:00065472 F:0 S:1 DN:3
	[ 7906.755821] md: rdev superblock (MJ:0):
	[ 7906.755826] md:  SB: (V:0.90.0) ID:<3fca7a0d.a612bfed.5f9f1645.801e9ee6> CT:491989f3
	[ 7906.755830] md:     L5 S00065472 ND:4 RD:4 md1 LO:2 CS:65536
	[ 7906.755834] md:     UT:491989f3 ST:1 AD:4 WD:4 FD:0 SD:0 CSUM:00fb52ad E:00000001
	[ 7906.755836]      D  0:  DISK<N:0,(1,8),R:0,S:6>
	[ 7906.755842]      D  1:  DISK<N:1,(1,10),R:1,S:6>
	[ 7906.755845]      D  2:  DISK<N:2,(1,12),R:2,S:6>
	[ 7906.755849]      D  3:  DISK<N:3,(1,14),R:3,S:6>
	[ 7906.755855] md:     THIS:  DISK<N:3,(1,14),R:3,S:6>
	...
	[ 7906.755972] md0: <ram3><ram2><ram1><ram0>
	[ 7906.755981] md: rdev ram3, SZ:00065472 F:0 S:1 DN:3
	[ 7906.755984] md: rdev superblock (MJ:1):
	[ 7906.755989] md:  SB: (V:1) (F:0) Array-ID:<5fbcf158:55aa:5fbe:9a79:1e939880dcbd>
	[ 7906.755990] md:    Name: "DG5:0" CT:1226410480
	[ 7906.755998] md:       L5 SZ130944 RD:4 LO:2 CS:128 DO:24 DS:131048 SO:8 RO:0
	[ 7906.755999] md:     Dev:00000003 UUID: 9194d744:87f7:a448:85f2:7497b84ce30a
	[ 7906.756001] md:       (F:0) UT:1226410480 Events:0 ResyncOffset:-1 CSUM:0dbcd829
	[ 7906.756003] md:         (MaxDev:384)
	...
	[ 7906.756113] md:	**********************************
	[ 7906.756116]

this md0 (metadata 1.2) information dumping is exactly according to struct
mdp_superblock_1.

Signed-off-by: Cheng Renquan <crquan@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   55 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 5 deletions(-)

diff -puN drivers/md/md.c~md-need-another-print_sb-for-mdp_superblock_1 drivers/md/md.c
--- a/drivers/md/md.c~md-need-another-print_sb-for-mdp_superblock_1
+++ a/drivers/md/md.c
@@ -1593,7 +1593,7 @@ static void print_desc(mdp_disk_t *desc)
 		desc->major,desc->minor,desc->raid_disk,desc->state);
 }
 
-static void print_sb(mdp_super_t *sb)
+static void print_sb_90(mdp_super_t *sb)
 {
 	int i;
 
@@ -1624,10 +1624,48 @@ static void print_sb(mdp_super_t *sb)
 	}
 	printk(KERN_INFO "md:     THIS: ");
 	print_desc(&sb->this_disk);
+}
+
+static void print_sb_1(struct mdp_superblock_1 *sb)
+{
+	__u8 *uuid;
 
+	uuid = sb->set_uuid;
+	printk(KERN_INFO "md:  SB: (V:%d) (F:%x) Array-ID:<%02x%02x%02x%02x"
+			":%02x%02x:%02x%02x:%02x%02x:%02x%02x%02x%02x%02x%02x>\n"
+	       KERN_INFO "md:    Name: \"%s\" CT:%Lu\n",
+		sb->major_version, sb->feature_map,
+		uuid[0], uuid[1], uuid[2], uuid[3],
+		uuid[4], uuid[5], uuid[6], uuid[7],
+		uuid[8], uuid[9], uuid[10], uuid[11],
+		uuid[12], uuid[13], uuid[14], uuid[15],
+		sb->set_name,
+		sb->ctime & 0xffffffffffLL);
+
+	uuid = sb->device_uuid;
+	printk(KERN_INFO "md:       L%d SZ%Ld RD:%d LO:%d CS:%d DO:%Ld DS:%Ld SO:%Ld"
+			" RO:%Ld\n"
+	       KERN_INFO "md:     Dev:%08x UUID: %02x%02x%02x%02x:%02x%02x:%02x%02x:%02x%02x"
+			":%02x%02x%02x%02x%02x%02x\n"
+	       KERN_INFO "md:       (F:%d) UT:%Lu Events:%Ld ResyncOffset:%Ld CSUM:%08x\n"
+	       KERN_INFO "md:         (MaxDev:%d) \n",
+		sb->level, sb->size, sb->raid_disks,
+		sb->layout, sb->chunksize,
+		sb->data_offset, sb->data_size,
+		sb->super_offset, sb->recovery_offset,
+		sb->dev_number,
+		uuid[0], uuid[1], uuid[2], uuid[3],
+		uuid[4], uuid[5], uuid[6], uuid[7],
+		uuid[8], uuid[9], uuid[10], uuid[11],
+		uuid[12], uuid[13], uuid[14], uuid[15],
+		sb->devflags,
+		sb->utime, sb->events,
+		sb->resync_offset,
+		sb->sb_csum, sb->max_dev
+		);
 }
 
-static void print_rdev(mdk_rdev_t *rdev)
+static void print_rdev(mdk_rdev_t *rdev, int major_version)
 {
 	char b[BDEVNAME_SIZE];
 	printk(KERN_INFO "md: rdev %s, SZ:%08llu F:%d S:%d DN:%u\n",
@@ -1635,8 +1673,15 @@ static void print_rdev(mdk_rdev_t *rdev)
 	        test_bit(Faulty, &rdev->flags), test_bit(In_sync, &rdev->flags),
 	        rdev->desc_nr);
 	if (rdev->sb_loaded) {
-		printk(KERN_INFO "md: rdev superblock:\n");
-		print_sb((mdp_super_t*)page_address(rdev->sb_page));
+		printk(KERN_INFO "md: rdev superblock (MJ:%d):\n", major_version);
+		switch (major_version) {
+		case 0:
+			print_sb_90((mdp_super_t*)page_address(rdev->sb_page));
+			break;
+		case 1:
+			print_sb_1((struct mdp_superblock_1 *)page_address(rdev->sb_page));
+			break;
+		}
 	} else
 		printk(KERN_INFO "md: no rdev superblock!\n");
 }
@@ -1663,7 +1708,7 @@ static void md_print_devices(void)
 		printk("\n");
 
 		rdev_for_each(rdev, tmp2, mddev)
-			print_rdev(rdev);
+			print_rdev(rdev, mddev->major_version);
 	}
 	printk("md:	**********************************\n");
 	printk("\n");
_

Patches currently in -mm which might be from crquan@gmail.com are

fs-block_devc-__read_mostly-improvement-and-sb_is_blkdev_sb-utilization.patch
md-need-another-print_sb-for-mdp_superblock_1.patch

