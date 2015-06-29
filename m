From: akpm@linux-foundation.org
Subject: [merged] mm-mmapc-optimization-of-do_mmap_pgoff-function.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:39:26 -0700
Message-ID: <5591acfe.uG7puX0djINPbYXN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbbF2Uj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kwapulinski.piotr@gmail.com, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: optimization of do_mmap_pgoff function
has been removed from the -mm tree.  Its filename was
     mm-mmapc-optimization-of-do_mmap_pgoff-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Subject: mm/mmap.c: optimization of do_mmap_pgoff function

The simple check for zero length memory mapping may be performed earlier. 
So that in case of zero length memory mapping some unnecessary code is not
executed at all.  It does not make the code less readable and saves some
CPU cycles.

Signed-off-by: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-optimization-of-do_mmap_pgoff-function mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-optimization-of-do_mmap_pgoff-function
+++ a/mm/mmap.c
@@ -1258,6 +1258,9 @@ unsigned long do_mmap_pgoff(struct file
 
 	*populate = 0;
 
+	if (!len)
+		return -EINVAL;
+
 	/*
 	 * Does the application expect PROT_READ to imply PROT_EXEC?
 	 *
@@ -1268,9 +1271,6 @@ unsigned long do_mmap_pgoff(struct file
 		if (!(file && (file->f_path.mnt->mnt_flags & MNT_NOEXEC)))
 			prot |= PROT_EXEC;
 
-	if (!len)
-		return -EINVAL;
