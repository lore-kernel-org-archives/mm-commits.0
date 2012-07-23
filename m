From: akpm@linux-foundation.org
Subject: + tmpfs-interleave-the-starting-node-of-dev-shmem-fix.patch added to -mm tree
Date: Mon, 23 Jul 2012 14:55:16 -0700
Message-ID: <20120723215517.0C9185C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:48217 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab2GWVzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 17:55:19 -0400
Received: by wgbdt11 with SMTP id dt11so336661wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 14:55:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nzimmer@sgi.com


The patch titled
     Subject: shmem: correct build warning in shmem interleave
has been added to the -mm tree.  Its filename is
     tmpfs-interleave-the-starting-node-of-dev-shmem-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: shmem: correct build warning in shmem interleave

Correcting a build warning in shmem_interleave

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~tmpfs-interleave-the-starting-node-of-dev-shmem-fix mm/shmem.c
--- a/mm/shmem.c~tmpfs-interleave-the-starting-node-of-dev-shmem-fix
+++ a/mm/shmem.c
@@ -1338,7 +1338,7 @@ static unsigned long shmem_interleave(st
 	unsigned long offset;
 
 	/* Use the vm_files prefered node as the initial offset. */
-	offset = (unsigned long *) vma->vm_private_data;
+	offset = (unsigned long)vma->vm_private_data;
 
 	offset += ((addr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
_
Subject: Subject: shmem: correct build warning in shmem interleave

Patches currently in -mm which might be from nzimmer@sgi.com are

shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch
tmpfs-interleave-the-starting-node-of-dev-shmem.patch
tmpfs-interleave-the-starting-node-of-dev-shmem-fix.patch

