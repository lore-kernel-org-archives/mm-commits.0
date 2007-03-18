From: akpm@linux-foundation.org
Subject: - fix-process-crash-caused-by-randomisation-and-64k-pages.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:10:16 -0800
Message-ID: <200703180910.l2I9AGm6020078@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60516 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbXCRJKb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:10:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: James.Bottomley@SteelEye.com, ak@suse.de, arjan@infradead.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     fix process crash caused by randomisation and 64k pages
has been removed from the -mm tree.  Its filename was
     fix-process-crash-caused-by-randomisation-and-64k-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix process crash caused by randomisation and 64k pages
From: James Bottomley <James.Bottomley@SteelEye.com>

This bug was seen on ppc64, but it could have occurred on any architecture
with a page size of 64k or above.  The problem is that
fs/binfmt_elf.c:randomize_stack_top() randomizes the stack to within 0x7ff
pages.  On 4k page machines, this is 8MB; on 64k page boxes, this is 128MB.
 The problem is that the new binary layout (selected in
arch_pick_mmap_layout) places the mapping segment 128MB or the stack rlimit
away from the top of the process memory, whichever is larger.  If you chose
an rlimit of less than 128MB (most defaults are in the 8Mb range) then you
can end up having your entire stack randomized away.

The fix is to make randomize_stack_top() only steal at most 8MB, which this
patch does.  However, I have to point out that even with this, your stack
rlimit might not be exactly what you get if it's > 128MB, because you're
still losing the random offset of up to 8MB.

The true fix should be to leave an explicit gap for the randomization plus
a buffer when determining mmap_base, but that would involve fixing all the
architectures.

Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~fix-process-crash-caused-by-randomisation-and-64k-pages fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fix-process-crash-caused-by-randomisation-and-64k-pages
+++ a/fs/binfmt_elf.c
@@ -507,7 +507,7 @@ out:
 #define INTERPRETER_ELF 2
 
 #ifndef STACK_RND_MASK
-#define STACK_RND_MASK 0x7ff		/* with 4K pages 8MB of VA */
+#define STACK_RND_MASK (0x7ff >> (PAGE_SHIFT - 12))	/* 8MB of VA */
 #endif
 
 static unsigned long randomize_stack_top(unsigned long stack_top)
_

Patches currently in -mm which might be from James.Bottomley@SteelEye.com are

origin.patch
git-scsi-misc.patch
git-scsi-rc-fixes.patch
fix--confusion-in-fusion-driver.patch
introduce-config_has_dma.patch
