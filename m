From: akpm@linux-foundation.org
Subject: + fat-remove-redundant-assignment-of-0-to-slots.patch added to
 -mm tree
Date: Wed, 18 Oct 2017 15:20:09 -0700
Message-ID: <59e7d399.vYDXH81YJv6TTQL7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37946 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750920AbdJRWUK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2017 18:20:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: remove redundant assignment of 0 to slots
has been added to the -mm tree.  Its filename is
     fat-remove-redundant-assignment-of-0-to-slots.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-remove-redundant-assignment-of-0-to-slots.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-remove-redundant-assignment-of-0-to-slots.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from colin.king@canonical.com are

mm-rmap-remove-redundant-variable-cend.patch
zram-make-function-zram_page_end_io-static.patch
fat-remove-redundant-assignment-of-0-to-slots.patch

