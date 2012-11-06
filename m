From: akpm@linux-foundation.org
Subject: + mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch added to -mm tree
Date: Tue, 06 Nov 2012 14:39:04 -0800
Message-ID: <20121106223905.248ED100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53348 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab2KFWjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 17:39:07 -0500
Received: by mail-vc0-f202.google.com with SMTP id fy27so108218vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 14:39:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@surriel.com, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de, walken@google.com


The patch titled
     Subject: mm: rearrange vm_area_struct for fewer cache misses
has been added to the -mm tree.  Its filename is
     mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: mm: rearrange vm_area_struct for fewer cache misses

The kernel walks the VMA rbtree in various places, including the page
fault path.  However, the vm_rb node spanned two cache lines, on 64 bit
systems with 64 byte cache lines (most x86 systems).

Rearrange vm_area_struct a little, so all the information we need to do a
VMA tree walk is in the first cache line.

Signed-off-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN include/linux/mm_types.h~mm-rearrange-vm_area_struct-for-fewer-cache-misses include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-rearrange-vm_area_struct-for-fewer-cache-misses
+++ a/include/linux/mm_types.h
@@ -226,7 +226,8 @@ struct vm_region {
  * library, the executable area etc).
  */
 struct vm_area_struct {
-	struct mm_struct * vm_mm;	/* The address space we belong to. */
+	/* The first cache line has the info for VMA tree walking. */
+
 	unsigned long vm_start;		/* Our start address within vm_mm. */
 	unsigned long vm_end;		/* The first byte after our end address
 					   within vm_mm. */
@@ -234,9 +235,6 @@ struct vm_area_struct {
 	/* linked list of VM areas per task, sorted by address */
 	struct vm_area_struct *vm_next, *vm_prev;
 
-	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
-	unsigned long vm_flags;		/* Flags, see mm.h. */
