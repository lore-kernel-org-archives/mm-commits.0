From: akpm@linux-foundation.org
Subject: + rmap-fixup-page_referenced-for-nommu-systems.patch added to -mm tree
Date: Thu, 18 Jun 2009 17:48:00 -0700
Message-ID: <200906190048.n5J0m0kq021597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253AbZFSAs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 20:48:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, davidm@snapgear.com, dhowells@redhat.com, fengguang.wu@intel.com, gerg@uclinux.org, lethal@linux-sh.org


The patch titled
     rmap: fixup page_referenced() for nommu systems
has been added to the -mm tree.  Its filename is
     rmap-fixup-page_referenced-for-nommu-systems.patch

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
Subject: rmap: fixup page_referenced() for nommu systems
From: Mike Frysinger <vapier@gentoo.org>

After the recent changes that went into mm/vmscan.c to overhaul stuff, we
ended up with these warnings on no-mmu systems:
mm/vmscan.c: In function `shrink_page_list':
mm/vmscan.c:580: warning: unused variable `vm_flags'
mm/vmscan.c: In function `shrink_active_list':
mm/vmscan.c:1294: warning: `vm_flags' may be used uninitialized in this function
mm/vmscan.c:1242: note: `vm_flags' was declared here

This is because the no-mmu function defines page_referenced() to work on
the first argument only (the page).  It does not clear the vm_flags given
to it because for no-mmu systems, they never actually get utilized.  Since
that is no longer strictly true, we need to set vm_flags to 0 like
everyone else so gcc can do proper dead code elimination without annoying
us with unused warnings.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Howells <dhowells@redhat.com>
Cc: David McCullough <davidm@snapgear.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN include/linux/rmap.h~rmap-fixup-page_referenced-for-nommu-systems include/linux/rmap.h
--- a/include/linux/rmap.h~rmap-fixup-page_referenced-for-nommu-systems
+++ a/include/linux/rmap.h
@@ -118,7 +118,14 @@ int try_to_munlock(struct page *);
 #define anon_vma_prepare(vma)	(0)
 #define anon_vma_link(vma)	do {} while (0)
 
-#define page_referenced(page, locked, cnt, flags) TestClearPageReferenced(page)
+static inline int page_referenced(struct page *page, int is_locked,
+				  struct mem_cgroup *cnt,
+				  unsigned long *vm_flags)
+{
+	*vm_flags = 0;
+	return TestClearPageReferenced(page);
+}
+
 #define try_to_unmap(page, refs) SWAP_FAIL
 
 static inline int page_mkclean(struct page *page)
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
istallion-add-missing-__devexit-marking.patch
rmap-fixup-page_referenced-for-nommu-systems.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch

