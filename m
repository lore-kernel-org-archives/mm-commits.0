From: akpm@linux-foundation.org
Subject: + mm-mmap-remove-unnecessary-assignment.patch added to -mm tree
Date: Thu, 29 Aug 2013 12:59:05 -0700
Message-ID: <521fa809.FiH/gV5rdZrm3+rE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab3H2T7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 15:59:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, ycnian@gmail.com

Subject: + mm-mmap-remove-unnecessary-assignment.patch added to -mm tree
To: ycnian@gmail.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 12:59:05 -0700


The patch titled
     Subject: mm/mmap: remove unnecessary assignment
has been added to the -mm tree.  Its filename is
     mm-mmap-remove-unnecessary-assignment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-remove-unnecessary-assignment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-remove-unnecessary-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mmap-remove-unnecessary-assignment.patch

