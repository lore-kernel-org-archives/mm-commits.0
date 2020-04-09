From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-dont-allow-to-mount-if-the-fat-length-==-0.patch
 added to -mm tree
Date: Wed, 08 Apr 2020 18:07:50 -0700
Message-ID: <20200409010750.t3QDF5_Lo%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbgDIBHv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 21:07:51 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, elver@google.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: don't allow to mount if the FAT length == 0
has been added to the -mm tree.  Its filename is
     fat-dont-allow-to-mount-if-the-fat-length-==-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-dont-allow-to-mount-if-the-fat-length-%3D%3D-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-dont-allow-to-mount-if-the-fat-length-%3D%3D-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: don't allow to mount if the FAT length == 0

If FAT length == 0, the image doesn't have any data. And it can be the
cause of overlapping the root dir and FAT entries.

Also Windows treats it as invalid format.

Link: http://lkml.kernel.org/r/87r1wz8mrd.fsf@mail.parknet.co.jp
Reported-by: syzbot+6f1624f937d9d6911e2d@syzkaller.appspotmail.com
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/fat/inode.c~fat-dont-allow-to-mount-if-the-fat-length-==-0
+++ a/fs/fat/inode.c
@@ -1520,6 +1520,12 @@ static int fat_read_bpb(struct super_blo
 		goto out;
 	}
 
+	if (bpb->fat_fat_length == 0 && bpb->fat32_length == 0) {
+		if (!silent)
+			fat_msg(sb, KERN_ERR, "bogus number of FAT sectors");
+		goto out;
+	}
+
 	error = 0;
 
 out:
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-dont-allow-to-mount-if-the-fat-length-==-0.patch
