From: akpm@linux-foundation.org
Subject: + fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table.patch added to -mm tree
Date: Wed, 30 Mar 2011 12:48:25 -0700
Message-ID: <201103301948.p2UJmQW2003827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755177Ab1C3UCT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 16:02:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Warns@pre-sense.de, eugeneteo@kernel.sg, harvey.harrison@gmail.com, rich@flatcap.org, warns@pre-sense.de


The patch titled
     fs/partitions/ldm.c: fix oops caused by corrupted partition table
has been added to the -mm tree.  Its filename is
     fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table.patch

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
Subject: fs/partitions/ldm.c: fix oops caused by corrupted partition table
From: Timo Warns <Warns@pre-sense.de>

The kernel automatically evaluates partition tables of storage devices.
The code for evaluating LDM partitions (in fs/partitions/ldm.c) contains
a bug that causes a kernel oops on certain corrupted LDM partitions.
A kernel subsystem seems to crash, because, after the oops, the kernel no
longer recognizes newly connected storage devices.

The patch validates the value of vblk_size.

Signed-off-by: Timo Warns <warns@pre-sense.de>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Richard Russon <rich@flatcap.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/ldm.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN fs/partitions/ldm.c~fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table fs/partitions/ldm.c
--- a/fs/partitions/ldm.c~fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table
+++ a/fs/partitions/ldm.c
@@ -1299,6 +1299,11 @@ static bool ldm_frag_add (const u8 *data
 
 	BUG_ON (!data || !frags);
 
+	if (size < 2*VBLK_SIZE_HEAD) {
+		ldm_error ("Value of size is to small.");
+		return false;
+	}
+
 	group = get_unaligned_be32(data + 0x08);
 	rec   = get_unaligned_be16(data + 0x0C);
 	num   = get_unaligned_be16(data + 0x0E);
@@ -1306,6 +1311,10 @@ static bool ldm_frag_add (const u8 *data
 		ldm_error ("A VBLK claims to have %d parts.", num);
 		return false;
 	}
+	if (rec >= num) {
+		ldm_error ("REC value (%d) exceeds NUM value (%d)", rec, num);
+		return false;
+	}
 
 	list_for_each (item, frags) {
 		f = list_entry (item, struct frag, list);
@@ -1334,10 +1343,9 @@ found:
 
 	f->map |= (1 << rec);
 
-	if (num > 0) {
-		data += VBLK_SIZE_HEAD;
-		size -= VBLK_SIZE_HEAD;
-	}
+	data += VBLK_SIZE_HEAD;
+	size -= VBLK_SIZE_HEAD;
+
 	memcpy (f->data+rec*(size-VBLK_SIZE_HEAD)+VBLK_SIZE_HEAD, data, size);
 
 	return true;
_

Patches currently in -mm which might be from Warns@pre-sense.de are

fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table.patch

