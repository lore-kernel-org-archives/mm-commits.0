From: akpm@linux-foundation.org
Subject: + btrfs-dont-dereference-extent_mapping-if-null.patch added to -mm tree
Date: Tue, 05 Oct 2010 14:30:30 -0700
Message-ID: <201010052130.o95LUU1o021216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565Ab0JEVbG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 17:31:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, chris.mason@oracle.com


The patch titled
     btrfs: don't dereference extent_mapping if NULL
has been added to the -mm tree.  Its filename is
     btrfs-dont-dereference-extent_mapping-if-null.patch

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
Subject: btrfs: don't dereference extent_mapping if NULL
From: Roel Kluin <roel.kluin@gmail.com>

Don't dereference em if it's NULL or an error pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/btrfs/inode.c~btrfs-dont-dereference-extent_mapping-if-null fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~btrfs-dont-dereference-extent_mapping-if-null
+++ a/fs/btrfs/inode.c
@@ -1777,7 +1777,8 @@ static int btrfs_io_failed_hook(struct b
 
 		read_lock(&em_tree->lock);
 		em = lookup_extent_mapping(em_tree, start, failrec->len);
-		if (em->start > start || em->start + em->len < start) {
+		if (em && !IS_ERR(em) && (em->start > start ||
+					em->start + em->len < start)) {
 			free_extent_map(em);
 			em = NULL;
 		}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
btrfs-dont-dereference-extent_mapping-if-null.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

