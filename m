From: akpm@linux-foundation.org
Subject: + block-partition-msdos-detect-aix-formatted-disks-even-without-55aa.patch added to -mm tree
Date: Fri, 25 Jan 2013 14:47:22 -0800
Message-ID: <20130125224722.A453B31C1CB@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:39688 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab3AYWrY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 17:47:24 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so87797ghb.5
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 14:47:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: phdm@macqel.be, andi@lisas.de, axboe@kernel.dk, hirofumi@mail.parknet.co.jp, olh@suse.de


The patch titled
     Subject: block/partition/msdos: detect AIX formatted disks even without 55aa
has been added to the -mm tree.  Its filename is
     block-partition-msdos-detect-aix-formatted-disks-even-without-55aa.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
block-partition-msdos-detect-aix-formatted-disks-even-without-55aa.patch

