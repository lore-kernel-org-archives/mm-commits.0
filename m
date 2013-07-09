From: akpm@linux-foundation.org
Subject: [merged]
 partitions-msdosc-end-of-line-whitespace-and-semicolon-cleanup.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:22:03 -0700
Message-ID: <51dc9b1b.hm6P+ykhOzRrXKvy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab3GIXWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:22:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kzak@redhat.com, axboe@kernel.dk, phdm@macqel.be

Subject: [merged] partitions-msdosc-end-of-line-whitespace-and-semicolon-cleanup.patch removed from -mm tree
To: phdm@macqel.be,axboe@kernel.dk,kzak@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:22:03 -0700


The patch titled
     Subject: partitions/msdos.c: end-of-line whitespace and semicolon cleanup
has been removed from the -mm tree.  Its filename was
     partitions-msdosc-end-of-line-whitespace-and-semicolon-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Philippe De Muyter <phdm@macqel.be>
Subject: partitions/msdos.c: end-of-line whitespace and semicolon cleanup

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Karel Zak <kzak@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/msdos.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN block/partitions/msdos.c~partitions-msdosc-end-of-line-whitespace-and-semicolon-cleanup block/partitions/msdos.c
--- a/block/partitions/msdos.c~partitions-msdosc-end-of-line-whitespace-and-semicolon-cleanup
+++ a/block/partitions/msdos.c
@@ -90,7 +90,7 @@ static int aix_magic_present(struct pars
 		if (d[0] == '_' && d[1] == 'L' && d[2] == 'V' && d[3] == 'M')
 			ret = 1;
 		put_dev_sector(sect);
-	};
+	}
 	return ret;
 }
 
@@ -142,7 +142,7 @@ static void parse_extended(struct parsed
 			return;
 
 		if (!msdos_magic_present(data + 510))
-			goto done; 
+			goto done;
 
 		p = (struct partition *) (data + 0x1be);
 
@@ -155,7 +155,7 @@ static void parse_extended(struct parsed
 		 * and OS/2 seems to use all four entries.
 		 */
 
-		/* 
+		/*
 		 * First process the data partition(s)
 		 */
 		for (i=0; i<4; i++, p++) {
@@ -263,7 +263,7 @@ static void parse_solaris_x86(struct par
 }
 
 #if defined(CONFIG_BSD_DISKLABEL)
-/* 
+/*
  * Create devices for BSD partitions listed in a disklabel, under a
  * dos-like partition. See parse_extended() for more information.
  */
@@ -294,7 +294,7 @@ static void parse_bsd(struct parsed_part
 
 		if (state->next == state->limit)
 			break;
-		if (p->p_fstype == BSD_FS_UNUSED) 
+		if (p->p_fstype == BSD_FS_UNUSED)
 			continue;
 		bsd_start = le32_to_cpu(p->p_offset);
 		bsd_size = le32_to_cpu(p->p_size);
@@ -441,7 +441,7 @@ static struct {
 	{NEW_SOLARIS_X86_PARTITION, parse_solaris_x86},
 	{0, NULL},
 };
- 
+
 int msdos_partition(struct parsed_partitions *state)
 {
 	sector_t sector_size = bdev_logical_block_size(state->bdev) / 512;
_

Patches currently in -mm which might be from phdm@macqel.be are

origin.patch

