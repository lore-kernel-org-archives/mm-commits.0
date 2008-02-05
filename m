From: akpm@linux-foundation.org
Subject: - mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:31:47 -0800
Message-ID: <200802052231.m15MVShh012169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60993 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760870AbYBEWlY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert@sixbynine.org, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: don't allow ioremapping of ranges larger than vmalloc space
has been removed from the -mm tree.  Its filename was
     mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: don't allow ioremapping of ranges larger than vmalloc space
From: "Robert Bragg" <robert@sixbynine.org>

When running with a 16M IOREMAP_MAX_ORDER (on armv7) we found that the
vmlist search routine in __get_vm_area_node can mistakenly allow a driver
to ioremap a range larger than vmalloc space.

If at the time of the ioremap all existing vmlist areas sit below the
determined alignment then the search routine continues past all entries and
exits the for loop - straight into the found: label - without ever testing
for integer wrapping or that the requested size fits.

We were seeing a driver successfully ioremap 128M of flash even though
there was only 120M of vmalloc space.  From that point the system was left
with the remainder of the first 16M of space to vmalloc/ioremap within.

Signed-off-by: Robert Bragg <robert@sixbynine.org>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/vmalloc.c~mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space mm/vmalloc.c
--- a/mm/vmalloc.c~mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space
+++ a/mm/vmalloc.c
@@ -254,6 +254,10 @@ static struct vm_struct *__get_vm_area_n
 		if (addr > end - size)
 			goto out;
 	}
+	if ((size + addr) < addr)
+		goto out;
+	if (addr > end - size)
+		goto out;
 
 found:
 	area->next = *p;
_

Patches currently in -mm which might be from robert@sixbynine.org are

origin.patch
