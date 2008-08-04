From: akpm@linux-foundation.org
Subject: - proc-fix-inode-number-bogorithmetic.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:07:42 -0700
Message-ID: <200808042007.m74K7gTS027835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761131AbYHDUHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc: fix inode number bogorithmetic
has been removed from the -mm tree.  Its filename was
     proc-fix-inode-number-bogorithmetic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: fix inode number bogorithmetic
From: Alexey Dobriyan <adobriyan@gmail.com>

Id which proc gets from IDR for inode number and id which proc removes
from IDR do not match.  E.g.  0x11a transforms into 0x8000011a.

Which stayed unnoticed for a long time because, surprise, idr_remove()
masks out that high bit before doing anything.

All of this due to "| ~MAX_ID_MASK" in release_inode_number().

I still don't understand how it's supposed to work, because "| ~MASK" is
not an inversion for "& MAX" operation.

So, use just one nice, working addition.  Make start offset unsigned int,
while I'm at it.  Its longness is not used anywhere.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff -puN fs/proc/generic.c~proc-fix-inode-number-bogorithmetic fs/proc/generic.c
--- a/fs/proc/generic.c~proc-fix-inode-number-bogorithmetic
+++ a/fs/proc/generic.c
@@ -303,7 +303,7 @@ out:
 static DEFINE_IDR(proc_inum_idr);
 static DEFINE_SPINLOCK(proc_inum_lock); /* protects the above */
 
-#define PROC_DYNAMIC_FIRST 0xF0000000UL
+#define PROC_DYNAMIC_FIRST 0xF0000000U
 
 /*
  * Return an inode number between PROC_DYNAMIC_FIRST and
@@ -311,7 +311,7 @@ static DEFINE_SPINLOCK(proc_inum_lock); 
  */
 static unsigned int get_inode_number(void)
 {
-	int i, inum = 0;
+	unsigned int i;
 	int error;
 
 retry:
@@ -326,21 +326,18 @@ retry:
 	else if (error)
 		return 0;
 
-	inum = (i & MAX_ID_MASK) + PROC_DYNAMIC_FIRST;
-
-	/* inum will never be more than 0xf0ffffff, so no check
-	 * for overflow.
-	 */
-
-	return inum;
+	if (i > UINT_MAX - PROC_DYNAMIC_FIRST) {
+		spin_lock(&proc_inum_lock);
+		idr_remove(&proc_inum_idr, i);
+		spin_unlock(&proc_inum_lock);
+	}
+	return PROC_DYNAMIC_FIRST + i;
 }
 
 static void release_inode_number(unsigned int inum)
 {
-	int id = (inum - PROC_DYNAMIC_FIRST) | ~MAX_ID_MASK;
