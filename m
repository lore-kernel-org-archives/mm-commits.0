From: akpm@linux-foundation.org
Subject: + mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch added to -mm tree
Date: Thu, 15 Nov 2007 16:05:36 -0800
Message-ID: <200711160005.lAG05aAG022824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46783 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbXKPAFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 19:05:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: robert@sixbynine.org, npiggin@suse.de


The patch titled
     mm: don't allow ioremapping of ranges larger than vmalloc space
has been added to the -mm tree.  Its filename is
     mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
