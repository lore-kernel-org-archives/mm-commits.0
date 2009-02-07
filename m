From: akpm@linux-foundation.org
Subject: + ecryptfs-regression-in-unencrypted-filename-symlinks.patch added to -mm tree
Date: Sat, 07 Feb 2009 12:10:45 -0800
Message-ID: <200902072010.n17KAjee002222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129AbZBGULU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 7 Feb 2009 15:11:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tyhicks@linux.vnet.ibm.com, shaggy@linux.vnet.ibm.com


The patch titled
     eCryptfs: regression in unencrypted filename symlinks
has been added to the -mm tree.  Its filename is
     ecryptfs-regression-in-unencrypted-filename-symlinks.patch

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
Subject: eCryptfs: regression in unencrypted filename symlinks
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

The addition of filename encryption caused a regression in unencrypted
filename symlink support.  ecryptfs_copy_filename() is used when dealing
with unencrypted filenames and it reported that the new, copied filename
was a character longer than it should have been.

This caused the return value of readlink() to count the NULL byte of the
symlink target.  Most applications don't care about the extra NULL byte,
but a version control system (bzr) helped in discovering the bug.

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-regression-in-unencrypted-filename-symlinks fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-regression-in-unencrypted-filename-symlinks
+++ a/fs/ecryptfs/crypto.c
@@ -1716,7 +1716,7 @@ static int ecryptfs_copy_filename(char *
 {
 	int rc = 0;
 
-	(*copied_name) = kmalloc((name_size + 2), GFP_KERNEL);
+	(*copied_name) = kmalloc((name_size + 1), GFP_KERNEL);
 	if (!(*copied_name)) {
 		rc = -ENOMEM;
 		goto out;
@@ -1726,7 +1726,7 @@ static int ecryptfs_copy_filename(char *
 						 * in printing out the
 						 * string in debug
 						 * messages */
-	(*copied_name_size) = (name_size + 1);
+	(*copied_name_size) = name_size;
 out:
 	return rc;
 }
_

Patches currently in -mm which might be from tyhicks@linux.vnet.ibm.com are

ecryptfs-regression-in-unencrypted-filename-symlinks.patch

