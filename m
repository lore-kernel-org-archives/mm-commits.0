From: akpm@linux-foundation.org
Subject: - slob-kill-off-duplicate-kzalloc-definition.patch removed from -mm tree
Date: Wed, 18 Jul 2007 01:38:28 -0700
Message-ID: <200707180838.l6I8cSUP000449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43902 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836AbXGRIjW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 04:39:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, clameter@sgi.com, jengelh@computergmbh.de, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     slob: kill off duplicate kzalloc() definition.
has been removed from the -mm tree.  Its filename was
     slob-kill-off-duplicate-kzalloc-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
