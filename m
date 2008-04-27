From: akpm@linux-foundation.org
Subject: + mm-nommuc-return-0-from-kobjsize-with-invalid-objects.patch added to -mm tree
Date: Sun, 27 Apr 2008 13:47:05 -0700
Message-ID: <200804272047.m3RKl5g9024119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbYD0UsE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 16:48:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Michael.Hennerich@analog.com, dhowells@redhat.com, rgetz@blackfin.uclinux.org


The patch titled
     mm/nommu.c: return 0 from kobjsize with invalid objects
has been added to the -mm tree.  Its filename is
     mm-nommuc-return-0-from-kobjsize-with-invalid-objects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mm-nommuc-return-0-from-kobjsize-with-invalid-objects.patch

