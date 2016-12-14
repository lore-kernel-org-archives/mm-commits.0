From: akpm@linux-foundation.org
Subject: [merged]
 mm-gup-make-unnecessarily-global-vma_permits_fault-static.patch removed
 from -mm tree
Date: Wed, 14 Dec 2016 11:23:48 -0800
Message-ID: <58519c44.9ajhQB0uaI5dEkoB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44042 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756518AbcLNTXt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:23:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: make unnecessarily global vma_permits_fault() static
has been removed from the -mm tree.  Its filename was
     mm-gup-make-unnecessarily-global-vma_permits_fault-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -632,7 +632,8 @@ next_page:
 	return i;
 }
 
-bool vma_permits_fault(struct vm_area_struct *vma, unsigned int fault_flags)
+static bool vma_permits_fault(struct vm_area_struct *vma,
+			      unsigned int fault_flags)
 {
 	bool write   = !!(fault_flags & FAULT_FLAG_WRITE);
 	bool foreign = !!(fault_flags & FAULT_FLAG_REMOTE);
_

Patches currently in -mm which might be from tklauser@distanz.ch are


