From: akpm@osdl.org
Subject: - binfmt_elf-randomize-pie-binaries.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:35 -0800
Message-ID: <200612072302.kB7N2ZLd029869@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51751 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163808AbWLGXCv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: meissner@suse.de, arjan@linux.intel.com, davej@codemonkey.org.uk, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     binfmt_elf: randomize PIE binaries (2nd try)
has been removed from the -mm tree.  Its filename was
     binfmt_elf-randomize-pie-binaries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: binfmt_elf: randomize PIE binaries (2nd try)
From: Marcus Meissner <meissner@suse.de>

Randomizes -pie compiled binaries from 64k (0x10000) up to ELF_ET_DYN_BASE.

0 -> 64k is excluded to allow NULL ptr accesses to fail.

Signed-off-by: Marcus Meissner <meissner@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/binfmt_elf.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-randomize-pie-binaries fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-randomize-pie-binaries
+++ a/fs/binfmt_elf.c
@@ -856,7 +856,13 @@ static int load_elf_binary(struct linux_
 			 * default mmap base, as well as whatever program they
 			 * might try to exec.  This is because the brk will
 			 * follow the loader, and is not movable.  */
-			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
+			if (current->flags & PF_RANDOMIZE)
+				load_bias = randomize_range(0x10000,
+							    ELF_ET_DYN_BASE,
+							    0);
+			else
+				load_bias = ELF_ET_DYN_BASE;
+			load_bias = ELF_PAGESTART(load_bias - vaddr);
 		}
 
 		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
_

Patches currently in -mm which might be from meissner@suse.de are

origin.patch

