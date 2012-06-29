From: akpm@linux-foundation.org
Subject: + mm-memoryc-print_vma_addr-call-up_readmm-mmap_sem-directly.patch added to -mm tree
Date: Fri, 29 Jun 2012 13:53:14 -0700
Message-ID: <20120629205314.926B5A0244@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:57158 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735Ab2F2UxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jun 2012 16:53:16 -0400
Received: by vcbfl13 with SMTP id fl13so418902vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 29 Jun 2012 13:53:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff.liu@oracle.com


The patch titled
     Subject: mm/memory.c:print_vma_addr(): call up_read(&mm->mmap_sem) directly
has been added to the -mm tree.  Its filename is
     mm-memoryc-print_vma_addr-call-up_readmm-mmap_sem-directly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Liu <jeff.liu@oracle.com>
Subject: mm/memory.c:print_vma_addr(): call up_read(&mm->mmap_sem) directly

Call up_read(&mm->mmap_sem) directly since we have already got mm via
current->mm at the beginning of print_vma_addr().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-memoryc-print_vma_addr-call-up_readmm-mmap_sem-directly mm/memory.c
--- a/mm/memory.c~mm-memoryc-print_vma_addr-call-up_readmm-mmap_sem-directly
+++ a/mm/memory.c
@@ -3946,7 +3946,7 @@ void print_vma_addr(char *prefix, unsign
 			free_page((unsigned long)buf);
 		}
 	}
-	up_read(&current->mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 }
 
 #ifdef CONFIG_PROVE_LOCKING
_
Subject: Subject: mm/memory.c:print_vma_addr(): call up_read(&mm->mmap_sem) directly

Patches currently in -mm which might be from jeff.liu@oracle.com are

linux-next.patch
mm-memoryc-print_vma_addr-call-up_readmm-mmap_sem-directly.patch

