From: akpm@linux-foundation.org
Subject: + fs-binfmt_elf-remove-redundant-elf_map-ifndef.patch
 added to -mm tree
Date: Wed, 15 Apr 2020 20:37:49 -0700
Message-ID: <20200416033749.crp4tOd3b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391344AbgDPDhu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 23:37:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ailiop@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf: remove redundant elf_map ifndef
has been added to the -mm tree.  Its filename is
     fs-binfmt_elf-remove-redundant-elf_map-ifndef.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-binfmt_elf-remove-redundant-elf_map-ifndef.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmt_elf-remove-redundant-elf_map-ifndef.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anthony Iliopoulos <ailiop@suse.com>
Subject: fs/binfmt_elf: remove redundant elf_map ifndef

The ifndef was added a long time ago to support archs that would define
their own mapping function.  The last user was the metag arch which was
removed from the tree, and as such there are no users left.  Let's kill
it.

Link: http://lkml.kernel.org/r/20200402161543.4119-1-ailiop@suse.com
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/binfmt_elf.c~fs-binfmt_elf-remove-redundant-elf_map-ifndef
+++ a/fs/binfmt_elf.c
@@ -347,8 +347,6 @@ create_elf_tables(struct linux_binprm *b
 	return 0;
 }
 
-#ifndef elf_map
-
 static unsigned long elf_map(struct file *filep, unsigned long addr,
 		const struct elf_phdr *eppnt, int prot, int type,
 		unsigned long total_size)
@@ -388,8 +386,6 @@ static unsigned long elf_map(struct file
 	return(map_addr);
 }
 
-#endif /* !elf_map */
