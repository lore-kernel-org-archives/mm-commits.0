From: akpm@linux-foundation.org
Subject: + fat-use-fat_msg_ratelimit-in-fat__get_entry.patch added to -mm tree
Date: Tue, 15 May 2012 12:36:02 -0700
Message-ID: <20120515193602.E6E19A0280@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:49171 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965425Ab2EOTgE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 15:36:04 -0400
Received: by qabg24 with SMTP id g24so8413qab.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 12:36:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linkinjeon@gmail.com, amit.sahrawat83@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat: use fat_msg_ratelimit() in fat__get_entry()
has been added to the -mm tree.  Its filename is
     fat-use-fat_msg_ratelimit-in-fat__get_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: fat: use fat_msg_ratelimit() in fat__get_entry()

If an application tries to lookup (opendir/readdir/stat) 5000 files on a
fatfs USB device and the device is unplugged, many message occur, shown
below.  This makes the application slow.  So use the new
fat_msg_ratelimit() decrease the messaging rate.

#> ./file_lookup_testcase ./files_directory/
[   57.768000] usb 2-1.4: USB disconnect, device number 4
[   57.812000] FAT-fs (sda1): FAT read failed (blocknr 2631)
stat failed
[   57.816000] FAT-fs (sda1): Directory bread(block 396816) failed
[   57.824000] FAT-fs (sda1): Directory bread(block 396817) failed
: No such file [   57.832000] FAT-fs (sda1): Directory bread(block 396818) failed
or directory
[   57.840000] FAT-fs (sda1): Directory bread(block 396819) failed
[   57.848000] FAT-fs (sda1): Directory bread(block 396820) failed
[   57.860000] FAT-fs (sda1): Directory bread(block 396821) failed
[   57.876000] FAT-fs (sda1): Directory bread(block 396822) failed
[   57.892000] FAT-fs (sda1): Directory bread(block 396823) failed
[   57.904000] FAT-fs (sda1): Directory bread(block 406824) failed
[   57.920000] FAT-fs (sda1): Directory bread(block 406825) failed
[   57.932000] FAT-fs (sda1): Directory bread(block 406826) failed
[   57.940000] FAT-fs (sda1): Directory bread(block 406827) failed
[   57.952000] FAT-fs (sda1): Directory bread(block 406828) failed
[   57.960000] FAT-fs (sda1): Directory bread(block 406829) failed
[   57.964000] FAT-fs (sda1): Directory bread(block 406830) failed
[   57.972000] FAT-fs (sda1): Directory bread(block 406831) failed
[   57.976000] FAT-fs (sda1): Directory bread(block 417696) failed
[   57.984000] FAT-fs (sda1): Directory bread(block 417697) failed
[   57.988000] FAT-fs (sda1): Directory bread(block 417698) failed
[   57.996000] FAT-fs (sda1): Directory bread(block 417699) failed
[   58.000000] FAT-fs (sda1): Directory bread(block 417700) failed
[   58.004000] FAT-fs (sda1): Directory bread(block 417701) failed
[   58.012000] FAT-fs (sda1): Directory bread(block 417702) failed
[   58.016000] FAT-fs (sda1): Directory bread(block 417703) failed
[   58.024000] FAT-fs (sda1): FAT read failed (blocknr 2631)
stat[   58.028000] FAT-fs (sda1): Directory bread(block 396816) failed
[   58.036000] FAT-fs (sda1): Directory bread(block 396817) failed
[   58.040000] FAT-fs (sda1): Directory bread(block 396818) failed
[   58.048000] FAT-fs (sda1): Directory bread(block 396819) failed
[   58.052000] FAT-fs (sda1): Directory bread(block 396820) failed
[   58.060000] FAT-fs (sda1): Directory bread(block 396821) failed

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/fat/dir.c~fat-use-fat_msg_ratelimit-in-fat__get_entry fs/fat/dir.c
--- a/fs/fat/dir.c~fat-use-fat_msg_ratelimit-in-fat__get_entry
+++ a/fs/fat/dir.c
@@ -98,8 +98,8 @@ next:
 
 	*bh = sb_bread(sb, phys);
 	if (*bh == NULL) {
-		fat_msg(sb, KERN_ERR, "Directory bread(block %llu) failed",
-		       (llu)phys);
+		fat_msg_ratelimit(sb, KERN_ERR,
+			"Directory bread(block %llu) failed", (llu)phys);
 		/* skip this block */
 		*pos = (iblock + 1) << sb->s_blocksize_bits;
 		goto next;
_
Subject: Subject: fat: use fat_msg_ratelimit() in fat__get_entry()

Patches currently in -mm which might be from linkinjeon@gmail.com are

linux-next.patch
drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch
ufs-fix-incorrect-return-value-about-success-and-failed.patch
fat-add-fat_msg_ratelimit.patch
fat-use-fat_msg_ratelimit-in-fat__get_entry.patch

