From: akpm@linux-foundation.org
Subject: +
 mm-mmapc-remove-incorrect-map_fixed-flag-comparison-from-mmap_region.patch
 added to -mm tree
Date: Tue, 17 Nov 2015 16:53:02 -0800
Message-ID: <564bcbee.S5VK1jKPAG5roRel%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbbKRAxD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 19:53:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kwapulinski.piotr@gmail.com, cmetcalf@ezchip.com, mhocko@suse.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: remove incorrect MAP_FIXED flag comparison from mmap_region
has been added to the -mm tree.  Its filename is
     mm-mmapc-remove-incorrect-map_fixed-flag-comparison-from-mmap_region.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-remove-incorrect-map_fixed-flag-comparison-from-mmap_region.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-remove-incorrect-map_fixed-flag-comparison-from-mmap_region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Subject: mm/mmap.c: remove incorrect MAP_FIXED flag comparison from mmap_region

The following flag comparison in mmap_region is not fully correct:

if (!(vm_flags & MAP_FIXED))

The vm_flags should not be compared with MAP_FIXED (0x10).  It is a bit
confusing.  This condition is almost always true since VM_MAYREAD (0x10)
flag is almost always set by default.  This patch removes this condition.

Signed-off-by: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-remove-incorrect-map_fixed-flag-comparison-from-mmap_region mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-remove-incorrect-map_fixed-flag-comparison-from-mmap_region
+++ a/mm/mmap.c
@@ -1547,13 +1547,6 @@ unsigned long mmap_region(struct file *f
 	if (!may_expand_vm(mm, len >> PAGE_SHIFT)) {
 		unsigned long nr_pages;
 
-		/*
-		 * MAP_FIXED may remove pages of mappings that intersects with
-		 * requested mapping. Account for the pages it would unmap.
-		 */
-		if (!(vm_flags & MAP_FIXED))
-			return -ENOMEM;
