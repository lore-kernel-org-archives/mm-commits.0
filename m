From: akpm@linux-foundation.org
Subject: [patch 053/115] mm/mmap.c: do not blow on PROT_NONE
 MAP_FIXED holes in the stack
Date: Mon, 10 Jul 2017 15:49:51 -0700
Message-ID: <20170710224951.oa3rOnG3D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42912 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932151AbdGJWtw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:49:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ben@decadent.org.uk, hughd@google.com, mhocko@suse.com, mm-commits@vger.kernel.org, oleg@redhat.com, riel@redhat.com, torvalds@linux-foundation.org, vbabka@suse.cz, w@1wt.eu

From: Michal Hocko <mhocko@suse.com>
Subject: mm/mmap.c: do not blow on PROT_NONE MAP_FIXED holes in the stack

"mm: enlarge stack guard gap" has introduced a regression in some rust and
Java environments which are trying to implement their own stack guard
page.  They are punching a new MAP_FIXED mapping inside the existing stack
Vma.

This will confuse expand_{downwards,upwards} into thinking that the stack
expansion would in fact get us too close to an existing non-stack vma
which is a correct behavior wrt.  safety.  It is a real regression on the
other hand.  Let's work around the problem by considering PROT_NONE
mapping as a part of the stack.  This is a gros hack but overflowing to
such a mapping would trap anyway an we only can hope that usespace knows
what it is doing and handle it propely.

Fixes: 1be7107fbe18 ("mm: larger stack guard gap, between vmas")
Link: http://lkml.kernel.org/r/20170705182849.GA18027@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Debugged-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mm-mm-mmap-do-not-blow-on-prot_none-map_fixed-holes-in-the-stack mm/mmap.c
--- a/mm/mmap.c~mm-mm-mmap-do-not-blow-on-prot_none-map_fixed-holes-in-the-stack
+++ a/mm/mmap.c
@@ -2244,7 +2244,8 @@ int expand_upwards(struct vm_area_struct
 		gap_addr = TASK_SIZE;
 
 	next = vma->vm_next;
-	if (next && next->vm_start < gap_addr) {
+	if (next && next->vm_start < gap_addr &&
+			(next->vm_flags & (VM_WRITE|VM_READ|VM_EXEC))) {
 		if (!(next->vm_flags & VM_GROWSUP))
 			return -ENOMEM;
 		/* Check that both stack segments have the same anon_vma? */
@@ -2328,7 +2329,8 @@ int expand_downwards(struct vm_area_stru
 	if (gap_addr > address)
 		return -ENOMEM;
 	prev = vma->vm_prev;
-	if (prev && prev->vm_end > gap_addr) {
+	if (prev && prev->vm_end > gap_addr &&
+			(prev->vm_flags & (VM_WRITE|VM_READ|VM_EXEC))) {
 		if (!(prev->vm_flags & VM_GROWSDOWN))
 			return -ENOMEM;
 		/* Check that both stack segments have the same anon_vma? */
_
