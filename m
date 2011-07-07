From: akpm@linux-foundation.org
Subject: [merged] fs-binfmt_elf_fdpicc-fix-memory-leak.patch removed from -mm tree
Date: Thu, 07 Jul 2011 12:20:48 -0700
Message-ID: <201107071920.p67JKMmd008555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306Ab1GGTUa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2011 15:20:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@gnu.org, dhowells@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fs/binfmt_elf_fdpic.c: fix memory leak
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elf_fdpicc-fix-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/binfmt_elf_fdpic.c: fix memory leak
From: Davidlohr Bueso <dave@gnu.org>

The shdr4extnum variable isn't being freed in the cleanup process of
elf_fdpic_core_dump().

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/binfmt_elf_fdpic.c~fs-binfmt_elf_fdpicc-fix-memory-leak fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~fs-binfmt_elf_fdpicc-fix-memory-leak
+++ a/fs/binfmt_elf_fdpic.c
@@ -1863,6 +1863,7 @@ cleanup:
 	kfree(psinfo);
 	kfree(notes);
 	kfree(fpu);
+	kfree(shdr4extnum);
 #ifdef ELF_CORE_COPY_XFPREGS
 	kfree(xfpu);
 #endif
_

Patches currently in -mm which might be from dave@gnu.org are

origin.patch

