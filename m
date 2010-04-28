From: akpm@linux-foundation.org
Subject: [merged] remove-redundant-check-for-config_mmu.patch removed from -mm tree
Date: Wed, 28 Apr 2010 11:03:21 -0400
Message-ID: <201004281804.o3SI4s03010992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939Ab0D1SFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:05:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: siccegge@cs.fau.de, dhowells@redhat.com, siccegge@stud.informatik.uni-erlangen.de, mm-commits@vger.kernel.org


The patch titled
     fs/binfmt_elf_fdpic.c: remove redundant check for CONFIG_MMU
has been removed from the -mm tree.  Its filename was
     remove-redundant-check-for-config_mmu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
