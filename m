From: akpm@linux-foundation.org
Subject: [merged] mm-slub-fix-some-indenting-in-cmpxchg_double_slab.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:03:29 -0700
Message-ID: <53e3db91.0ylhXsItXTAwYU8i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:55393 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaHGUDa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:30 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so879159igd.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: fix some indenting in cmpxchg_double_slab()
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-some-indenting-in-cmpxchg_double_slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
rtc-rtc-pcf8563-add-alarm-support-fix.patch
linux-next.patch

