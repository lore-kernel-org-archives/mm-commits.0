From: akpm@linux-foundation.org
Subject: + mm-gup-make-unnecessarily-global-vma_permits_fault-static.patch added to -mm tree
Date: Mon, 17 Oct 2016 17:12:38 -0700
Message-ID: <580568f6.ZFGBtHGUC/fWbsss%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58920 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754236AbcJRAMj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2016 20:12:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: make unnecessarily global vma_permits_fault() static
has been added to the -mm tree.  Its filename is
     mm-gup-make-unnecessarily-global-vma_permits_fault-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-make-unnecessarily-global-vma_permits_fault-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-make-unnecessarily-global-vma_permits_fault-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: mm/gup.c: make unnecessarily global vma_permits_fault() static

Make vma_permits_fault() static as it is only used in mm/gup.c

This fixes a sparse warning.

Link: http://lkml.kernel.org/r/20161017122353.31598-1-tklauser@distanz.ch
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/gup.c~mm-gup-make-unnecessarily-global-vma_permits_fault-static mm/gup.c
--- a/mm/gup.c~mm-gup-make-unnecessarily-global-vma_permits_fault-static
+++ a/mm/gup.c
@@ -623,7 +623,8 @@ next_page:
 }
 EXPORT_SYMBOL(__get_user_pages);
 
-bool vma_permits_fault(struct vm_area_struct *vma, unsigned int fault_flags)
+static bool vma_permits_fault(struct vm_area_struct *vma,
+			      unsigned int fault_flags)
 {
 	bool write   = !!(fault_flags & FAULT_FLAG_WRITE);
 	bool foreign = !!(fault_flags & FAULT_FLAG_REMOTE);
_

Patches currently in -mm which might be from tklauser@distanz.ch are

mm-gup-make-unnecessarily-global-vma_permits_fault-static.patch

