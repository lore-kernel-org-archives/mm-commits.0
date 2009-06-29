From: akpm@linux-foundation.org
Subject: + move-magic-numbers-into-magich-update.patch added to -mm tree
Date: Mon, 29 Jun 2009 12:29:54 -0700
Message-ID: <200906291929.n5TJTs1S006812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758766AbZF2Ta0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 15:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dank@qemfd.net, penberg@cs.helsinki.fi


The patch titled
     move-magic-numbers-into-magich-update
has been added to the -mm tree.  Its filename is
     move-magic-numbers-into-magich-update.patch

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
Subject: move-magic-numbers-into-magich-update
From: Nick Black <dank@qemfd.net>

Signed-off-by: Nick Black <dank@qemfd.net>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c  |    4 +---
 include/linux/magic.h |    1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/hugetlbfs/inode.c~move-magic-numbers-into-magich-update fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~move-magic-numbers-into-magich-update
+++ a/fs/hugetlbfs/inode.c
@@ -31,12 +31,10 @@
 #include <linux/statfs.h>
 #include <linux/security.h>
 #include <linux/ima.h>
+#include <linux/magic.h>
 
 #include <asm/uaccess.h>
 
-/* some random number */
-#define HUGETLBFS_MAGIC	0x958458f6
