From: akpm@linux-foundation.org
Subject: - add-export_symbolksize.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:28:46 -0800
Message-ID: <200712080128.lB81SkcZ013353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50314 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753984AbXLHB3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:29:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, clameter@sgi.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     Add EXPORT_SYMBOL(ksize);
has been removed from the -mm tree.  Its filename was
     add-export_symbolksize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add EXPORT_SYMBOL(ksize);
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

mm/slub.c exports ksize(), but mm/slob.c and mm/slab.c don't.

It's used by binfmt_flat, which can be built as a module.

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
@@ -4475,3 +4475,4 @@ size_t ksize(const void *objp)
 
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

origin.patch
