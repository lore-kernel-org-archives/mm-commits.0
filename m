From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 087/127] fs/binfmt_elf: remove redundant elf_map
 ifndef
Date: Thu, 04 Jun 2020 16:50:46 -0700
Message-ID: <20200604235046.8_MpY6yXD%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbgFDXur (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:50:47 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ailiop@suse.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
