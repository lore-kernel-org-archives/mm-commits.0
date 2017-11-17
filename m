From: akpm@linux-foundation.org
Subject: [patch 63/94] fat: remove redundant assignment of 0 to
 slots
Date: Fri, 17 Nov 2017 15:29:57 -0800
Message-ID: <20171117232957._GTqf5_Ah%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55918 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966947AbdKQX37 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:29:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, colin.king@canonical.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Colin Ian King <colin.king@canonical.com>
Subject: fat: remove redundant assignment of 0 to slots

The variable slots is being assigned a value of zero that is never read,
slots is being updated again a few lines later.  Remove this redundant
assignment.

Cleans clang warning: Value stored to 'slots' is never read

Link: http://lkml.kernel.org/r/20171017140258.22536-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/fat/dir.c~fat-remove-redundant-assignment-of-0-to-slots fs/fat/dir.c
--- a/fs/fat/dir.c~fat-remove-redundant-assignment-of-0-to-slots
+++ a/fs/fat/dir.c
@@ -291,7 +291,6 @@ static int fat_parse_long(struct inode *
 		}
 	}
 parse_long:
-	slots = 0;
 	ds = (struct msdos_dir_slot *)*de;
 	id = ds->id;
 	if (!(id & 0x40))
_
