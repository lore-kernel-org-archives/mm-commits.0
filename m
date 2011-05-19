From: akpm@linux-foundation.org
Subject: + fs-partitions-ldmc-fix-buffer-overflow-again.patch added to -mm tree
Date: Thu, 19 May 2011 15:05:37 -0700
Message-ID: <201105192205.p4JM5bMx030737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933084Ab1ESWGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 May 2011 18:06:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Warns@pre-sense.de, ben@decadent.org.uk, eugeneteo@kernel.sg, harvey.harrison@gmail.com, rich@flatcap.org, stable@kernel.org, warns@pre-sense.de


The patch titled
     fs/partitions/ldm.c: fix buffer overflow again
has been added to the -mm tree.  Its filename is
     fs-partitions-ldmc-fix-buffer-overflow-again.patch

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
Subject: fs/partitions/ldm.c: fix buffer overflow again
From: Timo Warns <Warns@pre-sense.de>

c340b1d640001 ("fs/partitions/ldm.c: fix oops caused by corrupted
partition table") was incomplete and incorrect.  It does not consider that
for subsequent fragments, previously allocated memory is used.

Signed-off-by: Timo Warns <warns@pre-sense.de>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Richard Russon <rich@flatcap.org>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/ldm.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/partitions/ldm.c~fs-partitions-ldmc-fix-buffer-overflow-again fs/partitions/ldm.c
--- a/fs/partitions/ldm.c~fs-partitions-ldmc-fix-buffer-overflow-again
+++ a/fs/partitions/ldm.c
@@ -1335,6 +1335,11 @@ static bool ldm_frag_add (const u8 *data
 
 	list_add_tail (&f->list, frags);
 found:
+	if (rec >= f->num) {
+		ldm_error("REC value (%d) exceeds NUM value (%d)", rec, f->num);
+		return false;
+	}
+
 	if (f->map & (1 << rec)) {
 		ldm_error ("Duplicate VBLK, part %d.", rec);
 		f->map &= 0x7F;			/* Mark the group as broken */
_

Patches currently in -mm which might be from Warns@pre-sense.de are

fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops.patch
fs-partitions-ldmc-fix-buffer-overflow-again.patch

