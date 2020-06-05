From: akpm@linux-foundation.org
Subject: [merged]
 fs-binfmt_elf-remove-redundant-elf_map-ifndef.patch removed from -mm tree
Date: Fri, 05 Jun 2020 13:19:30 -0700
Message-ID: <20200605201930.Jvs4lox5f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728126AbgFEUTa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:19:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ailiop@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf: remove redundant elf_map ifndef
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elf-remove-redundant-elf_map-ifndef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -353,8 +353,6 @@ create_elf_tables(struct linux_binprm *b
 	return 0;
 }
 
-#ifndef elf_map
-
 static unsigned long elf_map(struct file *filep, unsigned long addr,
 		const struct elf_phdr *eppnt, int prot, int type,
 		unsigned long total_size)
@@ -394,8 +392,6 @@ static unsigned long elf_map(struct file
 	return(map_addr);
 }
 
-#endif /* !elf_map */
