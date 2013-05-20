From: akpm@linux-foundation.org
Subject: +
 partitions-msdosc-end-of-line-whitespace-and-semicolon-cleanup.patch added
 to -mm tree
Date: Mon, 20 May 2013 16:42:04 -0700
Message-ID: <519ab4cc.8Rew+nFDQ21FN+XA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab3ETXmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 19:42:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kzak@redhat.com, axboe@kernel.dk, phdm@macqel.be

Subject: + partitions-msdosc-end-of-line-whitespace-and-semicolon-cleanup.patch added to -mm tree
To: phdm@macqel.be,axboe@kernel.dk,kzak@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 16:42:04 -0700


The patch titled
     Subject: partitions/msdos.c: end-of-line whitespace and semicolon cleanup
has been added to the -mm tree.  Its filename is
     partitions-msdosc-end-of-line-whitespace-and-semicolon-cleanup.patch

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

partitions-msdosc-end-of-line-whitespace-and-semicolon-cleanup.patch
partitions-add-aix-lvm-partition-support-files.patch
partitions-add-aix-lvm-partition-support-files-compile-aixc-if-configured.patch
partitions-add-aix-lvm-partition-support-files-add-the-aix_partition-entry.patch
partitions-msdos-enumerate-also-aix-lvm-partitions.patch

