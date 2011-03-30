From: akpm@linux-foundation.org
Subject: + proc-stat-use-defined-macro-kmalloc_max_size.patch added to -mm tree
Date: Wed, 30 Mar 2011 12:50:24 -0700
Message-ID: <201103301950.p2UJoOsT003944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153Ab1C3Tuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 15:50:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yuanhan.liu@linux.intel.com, adobriyan@gmail.com


The patch titled
     proc/stat: use defined macro KMALLOC_MAX_SIZE
has been added to the -mm tree.  Its filename is
     proc-stat-use-defined-macro-kmalloc_max_size.patch

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
Subject: proc/stat: use defined macro KMALLOC_MAX_SIZE
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>

There is a macro for the max size kmalloc can allocate, so use it instead
of a hardcoded number.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/proc/stat.c~proc-stat-use-defined-macro-kmalloc_max_size fs/proc/stat.c
--- a/fs/proc/stat.c~proc-stat-use-defined-macro-kmalloc_max_size
+++ a/fs/proc/stat.c
@@ -138,9 +138,9 @@ static int stat_open(struct inode *inode
 	struct seq_file *m;
 	int res;
 
-	/* don't ask for more than the kmalloc() max size, currently 128 KB */
-	if (size > 128 * 1024)
-		size = 128 * 1024;
+	/* don't ask for more than the kmalloc() max size */
+	if (size > KMALLOC_MAX_SIZE)
+		size = KMALLOC_MAX_SIZE;
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
_

Patches currently in -mm which might be from yuanhan.liu@linux.intel.com are

proc-stat-use-defined-macro-kmalloc_max_size.patch

