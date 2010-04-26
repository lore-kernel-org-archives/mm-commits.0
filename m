From: akpm@linux-foundation.org
Subject: + remove-redundant-check-for-config_mmu.patch added to -mm tree
Date: Mon, 26 Apr 2010 16:10:32 -0700
Message-ID: <201004262310.o3QNAWMg025242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622Ab0DZXSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 19:18:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: siccegge@cs.fau.de, dhowells@redhat.com, siccegge@stud.informatik.uni-erlangen.de


The patch titled
     fs/binfmt_elf_fdpic.c: remove redundant check for CONFIG_MMU
has been added to the -mm tree.  Its filename is
     remove-redundant-check-for-config_mmu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/binfmt_elf_fdpic.c: remove redundant check for CONFIG_MMU
From: Christoph Egger <siccegge@cs.fau.de>

The checks for CONFIG_MMU at this location are duplicated as all the code
is located inside a #ifndef CONFIG_MMU block.  So the first conditional
block will always be included while the second never will.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~remove-redundant-check-for-config_mmu fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~remove-redundant-check-for-config_mmu
+++ a/fs/binfmt_elf_fdpic.c
@@ -1005,15 +1005,8 @@ static int elf_fdpic_map_file_constdisp_
 				}
 			} else if (!mm->start_data) {
 				mm->start_data = seg->addr;
-#ifndef CONFIG_MMU
 				mm->end_data = seg->addr + phdr->p_memsz;
-#endif
 			}
