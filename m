From: akpm@linux-foundation.org
Subject: + mm-mmapc-optimization-of-do_mmap_pgoff-function.patch added to
 -mm tree
Date: Tue, 09 Jun 2015 15:56:14 -0700
Message-ID: <55776f0e.6wrXnSB8bLzHgaiW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbbFIW4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2015 18:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kwapulinski.piotr@gmail.com, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: optimization of do_mmap_pgoff function
has been added to the -mm tree.  Its filename is
     mm-mmapc-optimization-of-do_mmap_pgoff-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-optimization-of-do_mmap_pgoff-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-optimization-of-do_mmap_pgoff-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1271,6 +1271,9 @@ unsigned long do_mmap_pgoff(struct file
 
 	*populate = 0;
 
+	if (!len)
+		return -EINVAL;
+
 	/*
 	 * Does the application expect PROT_READ to imply PROT_EXEC?
 	 *
@@ -1281,9 +1284,6 @@ unsigned long do_mmap_pgoff(struct file
 		if (!(file && (file->f_path.mnt->mnt_flags & MNT_NOEXEC)))
 			prot |= PROT_EXEC;
 
-	if (!len)
-		return -EINVAL;
