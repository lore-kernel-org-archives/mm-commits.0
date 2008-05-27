From: akpm@linux-foundation.org
Subject: - mm-allow-pfnmap-faults.patch removed from -mm tree
Date: Tue, 27 May 2008 00:26:32 -0700
Message-ID: <200805270726.m4R7QWlq014675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757039AbYE0H1K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:27:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, benh@kernel.crashing.org, jes@sgi.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     mm: allow pfnmap ->fault()s
has been removed from the -mm tree.  Its filename was
     mm-allow-pfnmap-faults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: allow pfnmap ->fault()s
From: Nick Piggin <npiggin@suse.de>

Take out an assertion to allow ->fault handlers to service PFNMAP regions. 
This is required to reimplement .nopfn handlers with .fault handlers and
subsequently remove nopfn.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Jes Sorensen <jes@sgi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memory.c~mm-allow-pfnmap-faults mm/memory.c
--- a/mm/memory.c~mm-allow-pfnmap-faults
+++ a/mm/memory.c
@@ -2295,8 +2295,6 @@ static int __do_fault(struct mm_struct *
 	vmf.flags = flags;
 	vmf.page = NULL;
 
-	BUG_ON(vma->vm_flags & VM_PFNMAP);
