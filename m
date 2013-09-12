From: akpm@linux-foundation.org
Subject: [merged] mm-mmap-remove-unnecessary-assignment.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:47 -0700
Message-ID: <523219eb.LCWj6kcCwnNhKztW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab3ILTps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, ycnian@gmail.com

Subject: [merged] mm-mmap-remove-unnecessary-assignment.patch removed from -mm tree
To: ycnian@gmail.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:47 -0700


The patch titled
     Subject: mm/mmap: remove unnecessary assignment
has been removed from the -mm tree.  Its filename was
     mm-mmap-remove-unnecessary-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yanchuan Nian <ycnian@gmail.com>
Subject: mm/mmap: remove unnecessary assignment

pgoff is not used after the statement "pgoff = vma->vm_pgoff;", so the
assignment is redundant.

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/mmap.c~mm-mmap-remove-unnecessary-assignment mm/mmap.c
--- a/mm/mmap.c~mm-mmap-remove-unnecessary-assignment
+++ a/mm/mmap.c
@@ -1566,7 +1566,6 @@ munmap_back:
 		WARN_ON_ONCE(addr != vma->vm_start);
 
 		addr = vma->vm_start;
-		pgoff = vma->vm_pgoff;
 		vm_flags = vma->vm_flags;
 	} else if (vm_flags & VM_SHARED) {
 		error = shmem_zero_setup(vma);
_

Patches currently in -mm which might be from ycnian@gmail.com are

origin.patch

