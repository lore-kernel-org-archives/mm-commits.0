From: akpm@linux-foundation.org
Subject: [merged] block-partition-msdos-detect-aix-formatted-disks-even-without-55aa.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:38 -0800
Message-ID: <20130228201638.C884931C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:52981 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3B1UQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:16:40 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so245099ves.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:16:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phdm@macqel.be, andi@lisas.de, axboe@kernel.dk, hirofumi@mail.parknet.co.jp, olh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: block/partition/msdos: detect AIX formatted disks even without 55aa
has been removed from the -mm tree.  Its filename was
     block-partition-msdos-detect-aix-formatted-disks-even-without-55aa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Philippe De Muyter <phdm@macqel.be>
Subject: block/partition/msdos: detect AIX formatted disks even without 55aa

AIX formatted disks do not always have the MSDOS 55aa signature.
This happens e.g. for unbootable AIX disks.

Up to now, such disks were not recognized as AIX disks, because of the
missing 55aa.  Fix that by inverting the two tests.  Let's first
check for the AIX magic strings, and only if that fails check for
the MSDOS magic word.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Andreas Mohr <andi@lisas.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Olaf Hering <olh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/msdos.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN block/partitions/msdos.c~block-partition-msdos-detect-aix-formatted-disks-even-without-55aa block/partitions/msdos.c
--- a/block/partitions/msdos.c~block-partition-msdos-detect-aix-formatted-disks-even-without-55aa
+++ a/block/partitions/msdos.c
@@ -455,14 +455,19 @@ int msdos_partition(struct parsed_partit
 	data = read_part_sector(state, 0, &sect);
 	if (!data)
 		return -1;
-	if (!msdos_magic_present(data + 510)) {
+
+	/*
+	 * Note order! (some AIX disks, e.g. unbootable kind,
+	 * have no MSDOS 55aa)
+	 */
+	if (aix_magic_present(state, data)) {
 		put_dev_sector(sect);
+		strlcat(state->pp_buf, " [AIX]", PAGE_SIZE);
 		return 0;
 	}
 
-	if (aix_magic_present(state, data)) {
+	if (!msdos_magic_present(data + 510)) {
 		put_dev_sector(sect);
-		strlcat(state->pp_buf, " [AIX]", PAGE_SIZE);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from phdm@macqel.be are

origin.patch

