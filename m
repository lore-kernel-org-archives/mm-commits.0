From: akpm@linux-foundation.org
Subject: + ext4-remove-redundant-test-on-unsigned.patch added to -mm tree
Date: Thu, 25 Jun 2009 15:51:04 -0700
Message-ID: <200906252251.n5PMp4uD018347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440AbZFYWvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 18:51:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com


The patch titled
     ext4: remove redundant test on unsigned
has been added to the -mm tree.  Its filename is
     ext4-remove-redundant-test-on-unsigned.patch

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
Subject: ext4: remove redundant test on unsigned
From: Roel Kluin <roel.kluin@gmail.com>

unsigned i_block cannot be less than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ext4/inode.c~ext4-remove-redundant-test-on-unsigned fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-remove-redundant-test-on-unsigned
+++ a/fs/ext4/inode.c
@@ -343,9 +343,7 @@ static int ext4_block_to_path(struct ino
 	int n = 0;
 	int final = 0;
 
-	if (i_block < 0) {
-		ext4_warning(inode->i_sb, "ext4_block_to_path", "block < 0");
-	} else if (i_block < direct_blocks) {
+	if (i_block < direct_blocks) {
 		offsets[n++] = i_block;
 		final = direct_blocks;
 	} else if ((i_block -= direct_blocks) < indirect_blocks) {
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
ext4-remove-redundant-test-on-unsigned.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch

