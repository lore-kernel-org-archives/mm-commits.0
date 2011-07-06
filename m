From: akpm@linux-foundation.org
Subject: + fs-binfmt_elf_fdpicc-fix-memory-leak.patch added to -mm tree
Date: Wed, 06 Jul 2011 14:16:10 -0700
Message-ID: <201107062116.p66LGA5h032260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756189Ab1GFVQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2011 17:16:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@gnu.org, dhowells@redhat.com, stable@kernel.org


The patch titled
     fs/binfmt_elf_fdpic.c: fix memory leak
has been added to the -mm tree.  Its filename is
     fs-binfmt_elf_fdpicc-fix-memory-leak.patch

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

fs-binfmt_elf_fdpicc-fix-memory-leak.patch

