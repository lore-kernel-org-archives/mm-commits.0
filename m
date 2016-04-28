From: akpm@linux-foundation.org
Subject: + documentation-vm-fix-spelling-mistakes.patch added to -mm tree
Date: Thu, 28 Apr 2016 12:12:44 -0700
Message-ID: <572260ac.fy5ri2G6OY+B0VZJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbcD1TMu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2016 15:12:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric@engestrom.ch, corbet@lwn.net, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: vm: fix spelling mistakes
has been added to the -mm tree.  Its filename is
     documentation-vm-fix-spelling-mistakes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-vm-fix-spelling-mistakes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-vm-fix-spelling-mistakes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Engestrom <eric@engestrom.ch>
Subject: Documentation: vm: fix spelling mistakes

Signed-off-by: Eric Engestrom <eric@engestrom.ch>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN Documentation/vm/transhuge.txt~documentation-vm-fix-spelling-mistakes Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~documentation-vm-fix-spelling-mistakes
+++ a/Documentation/vm/transhuge.txt
@@ -340,7 +340,7 @@ unaffected. libhugetlbfs will also work
 
 == Graceful fallback ==
 
-Code walking pagetables but unware about huge pmds can simply call
+Code walking pagetables but unaware about huge pmds can simply call
 split_huge_pmd(vma, pmd, addr) where the pmd is the one returned by
 pmd_offset. It's trivial to make the code transparent hugepage aware
 by just grepping for "pmd_offset" and adding split_huge_pmd where
@@ -414,7 +414,7 @@ tracking. The alternative is alter ->_ma
 map/unmap of the whole compound page.
 
 We set PG_double_map when a PMD of the page got split for the first time,
-but still have PMD mapping. The addtional references go away with last
+but still have PMD mapping. The additional references go away with last
 compound_mapcount.
 
 split_huge_page internally has to distribute the refcounts in the head
@@ -432,10 +432,10 @@ page->_mapcount.
 We safe against physical memory scanners too: the only legitimate way
 scanner can get reference to a page is get_page_unless_zero().
 
-All tail pages has zero ->_refcount until atomic_add(). It prevent scanner
-from geting reference to tail page up to the point. After the atomic_add()
-we don't care about ->_refcount value.  We already known how many references
-with should uncharge from head page.
+All tail pages have zero ->_refcount until atomic_add(). This prevents the
+scanner from getting a reference to the tail page up to that point. After the
+atomic_add() we don't care about the ->_refcount value.  We already known how
+many references should be uncharged from the head page.
 
 For head page get_page_unless_zero() will succeed and we don't mind. It's
 clear where reference should go after split: it will stay on head page.
_

Patches currently in -mm which might be from eric@engestrom.ch are

documentation-vm-fix-spelling-mistakes.patch

