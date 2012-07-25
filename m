From: akpm@linux-foundation.org
Subject: [folded] tmpfs-interleave-the-starting-node-of-dev-shmem-fix.patch removed from -mm tree
Date: Wed, 25 Jul 2012 11:54:00 -0700
Message-ID: <20120725185401.08A7D200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:36855 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2GYSyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jul 2012 14:54:03 -0400
Received: by wibhr14 with SMTP id hr14so53428wib.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jul 2012 11:54:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: correct build warning in shmem interleave
has been removed from the -mm tree.  Its filename was
     tmpfs-interleave-the-starting-node-of-dev-shmem-fix.patch

This patch was dropped because it was folded into tmpfs-interleave-the-starting-node-of-dev-shmem.patch

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

Patches currently in -mm which might be from nzimmer@sgi.com are

shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch
tmpfs-interleave-the-starting-node-of-dev-shmem.patch

