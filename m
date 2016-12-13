From: akpm@linux-foundation.org
Subject: [patch 026/123] mm/gup.c: make unnecessarily global
 vma_permits_fault() static
Date: Mon, 12 Dec 2016 16:41:53 -0800
Message-ID: <584f43d1.JVwR6/LniFrVmrpN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40764 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753137AbcLMAly (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:41:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, tklauser@distanz.ch

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
