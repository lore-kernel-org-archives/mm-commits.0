From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 090/127] fat: don't allow to mount if the FAT
 length == 0
Date: Thu, 04 Jun 2020 16:50:56 -0700
Message-ID: <20200604235056.ras4DFMTz%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXu6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:50:58 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dvyukov@google.com, elver@google.com, hirofumi@mail.parknet.co.jp, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
@@ -1519,6 +1519,12 @@ static int fat_read_bpb(struct super_blo
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
