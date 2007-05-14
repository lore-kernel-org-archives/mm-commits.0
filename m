From: akpm@linux-foundation.org
Subject: + make-__vunmap-static.patch added to -mm tree
Date: Mon, 14 May 2007 11:51:26 -0700
Message-ID: <200705141851.l4EIpQMZ023450@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754956AbXENSvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 14:51:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org


The patch titled
     Make __vunmap static
has been added to the -mm tree.  Its filename is
     make-__vunmap-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make __vunmap static
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

__vunmap doesn't seem to be used outside of mm/vmalloc.c, and has
no prototype in any header so let's make it static

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~make-__vunmap-static mm/vmalloc.c
--- a/mm/vmalloc.c~make-__vunmap-static
+++ a/mm/vmalloc.c
@@ -311,7 +311,7 @@ struct vm_struct *remove_vm_area(void *a
 	return v;
 }
 
-void __vunmap(void *addr, int deallocate_pages)
+static void __vunmap(void *addr, int deallocate_pages)
 {
 	struct vm_struct *area;
 
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

do-not-select-macintosh-drivers-by-default.patch
make-__vunmap-static.patch
