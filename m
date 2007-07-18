From: akpm@linux-foundation.org
Subject: + slob-kill-off-duplicate-kzalloc-definition.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:37:24 -0700
Message-ID: <200707180037.l6I0bOiu015840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755295AbXGRAhf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:37:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, clameter@sgi.com, jengelh@computergmbh.de


The patch titled
     slob: kill off duplicate kzalloc() definition.
has been added to the -mm tree.  Its filename is
     slob-kill-off-duplicate-kzalloc-definition.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slob: kill off duplicate kzalloc() definition.
From: Paul Mundt <lethal@linux-sh.org>

With the slab zeroing allocations cleanups Christoph stubbed in a generic
kzalloc(), which was missed on SLOB. Follow the SLAB/SLUB changes and
kill off the __kzalloc() wrapper that SLOB was using.

Reported-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slob_def.h |   10 ----------
 1 files changed, 10 deletions(-)

diff -puN include/linux/slob_def.h~slob-kill-off-duplicate-kzalloc-definition include/linux/slob_def.h
--- a/include/linux/slob_def.h~slob-kill-off-duplicate-kzalloc-definition
+++ a/include/linux/slob_def.h
@@ -33,14 +33,4 @@ static inline void *__kmalloc(size_t siz
 	return kmalloc(size, flags);
 }
 
-/**
- * kzalloc - allocate memory. The memory is set to zero.
- * @size: how many bytes of memory are required.
- * @flags: the type of memory to allocate (see kcalloc).
- */
-static inline void *kzalloc(size_t size, gfp_t flags)
-{
-	return __kzalloc(size, flags);
-}
-
 #endif /* __LINUX_SLOB_DEF_H */
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
slob-kill-off-duplicate-kzalloc-definition.patch
git-sh.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
