From: akpm@linux-foundation.org
Subject: + hwpoison-fix-oops-on-ksm-pages.patch added to -mm tree
Date: Tue, 13 Oct 2009 09:44:03 -0700
Message-ID: <200910131644.n9DGi4VG005715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753609AbZJMQsc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 12:48:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, andi@firstfloor.org


The patch titled
     hwpoison: fix oops on ksm pages
has been added to the -mm tree.  Its filename is
     hwpoison-fix-oops-on-ksm-pages.patch

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
Subject: hwpoison: fix oops on ksm pages
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Memory failure on a KSM page currently oopses on its NULL anon_vma in
page_lock_anon_vma(): that may not be much worse than the consequence of
ignoring it, but it is better to be consistent with how ZERO_PAGE and
hugetlb pages and other awkward cases are treated.  Just skip it.

We could fix it for 2.6.32 at the KSM end, by putting a dummy anon_vma
pointer in there; but that would get harder next time, when KSM will put a
pointer to something else there (and I'm not currently planning to do any
work to open that up to memory_failure).  So I would prefer this simple
PageKsm test, until the other exceptions are handled.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/memory-failure.c~hwpoison-fix-oops-on-ksm-pages mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-fix-oops-on-ksm-pages
+++ a/mm/memory-failure.c
@@ -35,6 +35,7 @@
 #include <linux/mm.h>
 #include <linux/page-flags.h>
 #include <linux/sched.h>
+#include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
@@ -661,7 +662,7 @@ static void hwpoison_user_mappings(struc
 	int i;
 	int kill = 1;
 
-	if (PageReserved(p) || PageCompound(p) || PageSlab(p))
+	if (PageReserved(p) || PageCompound(p) || PageSlab(p) || PageKsm(p))
 		return;
 
 	if (!PageLRU(p))
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

hwpoison-fix-oops-on-ksm-pages.patch
hwpoison-fix-proc-meminfo-alignment.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

