From: akpm@linux-foundation.org
Subject: - mm-nommuc-return-0-from-kobjsize-with-invalid-objects.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:10 -0700
Message-ID: <200804282154.m3SLsAx4017981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935873AbYD1Vyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Michael.Hennerich@analog.com, dhowells@redhat.com, rgetz@blackfin.uclinux.org, mm-commits@vger.kernel.org


The patch titled
     mm/nommu.c: return 0 from kobjsize with invalid objects
has been removed from the -mm tree.  Its filename was
     mm-nommuc-return-0-from-kobjsize-with-invalid-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/nommu.c: return 0 from kobjsize with invalid objects
From: Michael Hennerich <Michael.Hennerich@analog.com>

Don't perform kobjsize operations on objects the kernel doesn't manage.


---
On Blackfin, drivers can get dma coherent memory by calling a function
dma_alloc_coherent(). We do this in nommu by configuring a chunk of uncached
memory at the top of memory.

Since we don't want the kernel to use the uncached memory, we lie to the
kernel, and tell it that it's max memory is between 0, and the start of the
uncached dma coherent section.

this all works well, until this memory gets exposed into userspace (with a
frame buffer), when you look at the process's maps, it shows the framebuf:

root:/proc> cat maps
[snip]
03f0ef00-03f34700 rw-p 00000000 1f:00 192        /dev/fb0
root:/proc>

This is outside the "normal" range for the kernel. When the kernel tries to
find the size of this object (when you run ps), it dies in nommu.c in
kobjsize.

BUG_ON(page->index >= MAX_ORDER);

since the page we are referring to is outside what the kernel thinks is it's
max valid memory.

root:~> while [ 1 ]; ps > /dev/null; done
kernel BUG at mm/nommu.c:119!
Kernel panic - not syncing: BUG!

We fixed this by adding a check to reject out of range object pointers as it
already does that for NULL pointers.

Signed-off-by: Michael Hennerich <Michael.Hennerich@analog.com>
Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/nommu.c~mm-nommuc-return-0-from-kobjsize-with-invalid-objects mm/nommu.c
--- a/mm/nommu.c~mm-nommuc-return-0-from-kobjsize-with-invalid-objects
+++ a/mm/nommu.c
@@ -105,7 +105,11 @@ unsigned int kobjsize(const void *objp)
 {
 	struct page *page;
 
-	if (!objp || !((page = virt_to_page(objp))))
+	/*
+	 * If the object we have should not have ksize performed on it,
+	 * return size of 0
+	 */
+	if (!objp || (unsigned long)objp >= memory_end || !((page = virt_to_page(objp))))
 		return 0;
 
 	if (PageSlab(page))
_

Patches currently in -mm which might be from Michael.Hennerich@analog.com are

origin.patch

