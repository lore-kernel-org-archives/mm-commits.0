From: akpm@linux-foundation.org
Subject: + add-export_symbolksize.patch added to -mm tree
Date: Mon, 03 Dec 2007 15:37:05 -0800
Message-ID: <200712032337.lB3Nb5dF023281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43642 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbXLCXhY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 18:37:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penguin-kernel@I-love.SAKURA.ne.jp, clameter@sgi.com, mpm@selenic.com


The patch titled
     Add EXPORT_SYMBOL(ksize);
has been added to the -mm tree.  Its filename is
     add-export_symbolksize.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add EXPORT_SYMBOL(ksize);
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

mm/slub.c exports ksize(), but mm/slob.c and mm/slab.c don't.

It's used by binfmt_flat, whcih can be built as a module.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    1 +
 mm/slob.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN mm/slab.c~add-export_symbolksize mm/slab.c
--- a/mm/slab.c~add-export_symbolksize
+++ a/mm/slab.c
@@ -4479,3 +4479,4 @@ size_t ksize(const void *objp)
 
 	return obj_size(virt_to_cache(objp));
 }
+EXPORT_SYMBOL(ksize);
diff -puN mm/slob.c~add-export_symbolksize mm/slob.c
--- a/mm/slob.c~add-export_symbolksize
+++ a/mm/slob.c
@@ -495,6 +495,7 @@ size_t ksize(const void *block)
 	else
 		return sp->page.private;
 }
+EXPORT_SYMBOL(ksize);
 
 struct kmem_cache {
 	unsigned int size, align;
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

add-export_symbolksize.patch
