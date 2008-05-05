From: akpm@linux-foundation.org
Subject: + mm-allow-pfnmap-faults.patch added to -mm tree
Date: Mon, 05 May 2008 13:20:43 -0700
Message-ID: <200805052020.m45KKhB3003077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756174AbYEEUVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 16:21:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, jes@sgi.com


The patch titled
     mm: allow pfnmap ->fault()s
has been added to the -mm tree.  Its filename is
     mm-allow-pfnmap-faults.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: allow pfnmap ->fault()s
From: Nick Piggin <npiggin@suse.de>

Take out an assertion to allow ->fault handlers to service PFNMAP regions. 
This is required to reimplement .nopfn handlers with .fault handlers and
subsequently remove nopfn.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Jes Sorensen <jes@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memory.c~mm-allow-pfnmap-faults mm/memory.c
--- a/mm/memory.c~mm-allow-pfnmap-faults
+++ a/mm/memory.c
@@ -2290,8 +2290,6 @@ static int __do_fault(struct mm_struct *
 	vmf.flags = flags;
 	vmf.page = NULL;
 
-	BUG_ON(vma->vm_flags & VM_PFNMAP);
