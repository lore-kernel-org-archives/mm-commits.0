From: akpm@linux-foundation.org
Subject: + mm-slub-fix-some-indenting-in-cmpxchg_double_slab.patch added
 to -mm tree
Date: Thu, 24 Jul 2014 13:55:12 -0700
Message-ID: <53d172b0.4soDfKmY/5rRXuiT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:49396 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934553AbaGXUzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 16:55:13 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so921636pde.1
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 13:55:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: fix some indenting in cmpxchg_double_slab()
has been added to the -mm tree.  Its filename is
     mm-slub-fix-some-indenting-in-cmpxchg_double_slab.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-some-indenting-in-cmpxchg_double_slab.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-some-indenting-in-cmpxchg_double_slab.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm, slub: fix some indenting in cmpxchg_double_slab()

The return statement goes with the cmpxchg_double() condition so it needs
to be indented another tab.

Also these days the fashion is to line function parameters up, and it
looks nicer that way because then the "freelist_new" is not at the same
indent level as the "return 1;".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/slub.c~mm-slub-fix-some-indenting-in-cmpxchg_double_slab mm/slub.c
--- a/mm/slub.c~mm-slub-fix-some-indenting-in-cmpxchg_double_slab
+++ a/mm/slub.c
@@ -381,9 +381,9 @@ static inline bool __cmpxchg_double_slab
     defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
 		if (cmpxchg_double(&page->freelist, &page->counters,
-			freelist_old, counters_old,
-			freelist_new, counters_new))
-		return 1;
+				   freelist_old, counters_old,
+				   freelist_new, counters_new))
+			return 1;
 	} else
 #endif
 	{
@@ -417,9 +417,9 @@ static inline bool cmpxchg_double_slab(s
     defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
 		if (cmpxchg_double(&page->freelist, &page->counters,
-			freelist_old, counters_old,
-			freelist_new, counters_new))
-		return 1;
+				   freelist_old, counters_old,
+				   freelist_new, counters_new))
+			return 1;
 	} else
 #endif
 	{
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
mm-slub-fix-some-indenting-in-cmpxchg_double_slab.patch
makefile-tell-gcc-optimizer-to-never-introduce-new-data-races.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-add-an-index-variable-for-fixed-lines.patch
checkpatch-add-ability-to-insert-and-delete-lines-to-patch-file.patch
linux-next.patch

