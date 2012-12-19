From: akpm@linux-foundation.org
Subject: [merged] mm-add-a-__gfp_kmemcg-flag.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:40:14 -0800
Message-ID: <20121219204015.09EAB82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:46420 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab2LSUkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:40:16 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so277874yen.3
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:40:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add a __GFP_KMEMCG flag
has been removed from the -mm tree.  Its filename was
     mm-add-a-__gfp_kmemcg-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: mm: add a __GFP_KMEMCG flag

This flag is used to indicate to the callees that this allocation is a
kernel allocation in process context, and should be accounted to current's
memcg.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: JoonSoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h             |    2 ++
 include/trace/events/gfpflags.h |    1 +
 2 files changed, 3 insertions(+)

diff -puN include/linux/gfp.h~mm-add-a-__gfp_kmemcg-flag include/linux/gfp.h
--- a/include/linux/gfp.h~mm-add-a-__gfp_kmemcg-flag
+++ a/include/linux/gfp.h
@@ -30,6 +30,7 @@ struct vm_area_struct;
 #define ___GFP_HARDWALL		0x20000u
 #define ___GFP_THISNODE		0x40000u
 #define ___GFP_RECLAIMABLE	0x80000u
+#define ___GFP_KMEMCG		0x100000u
 #define ___GFP_NOTRACK		0x200000u
 #define ___GFP_NO_KSWAPD	0x400000u
 #define ___GFP_OTHER_NODE	0x800000u
@@ -89,6 +90,7 @@ struct vm_area_struct;
 
 #define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
 #define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */
+#define __GFP_KMEMCG	((__force gfp_t)___GFP_KMEMCG) /* Allocation comes from a memcg-accounted resource */
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)	/* Allocator intends to dirty page */
 
 /*
diff -puN include/trace/events/gfpflags.h~mm-add-a-__gfp_kmemcg-flag include/trace/events/gfpflags.h
--- a/include/trace/events/gfpflags.h~mm-add-a-__gfp_kmemcg-flag
+++ a/include/trace/events/gfpflags.h
@@ -34,6 +34,7 @@
 	{(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL"},	\
 	{(unsigned long)__GFP_THISNODE,		"GFP_THISNODE"},	\
 	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
+	{(unsigned long)__GFP_KMEMCG,		"GFP_KMEMCG"},		\
 	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"},		\
 	{(unsigned long)__GFP_NOTRACK,		"GFP_NOTRACK"},		\
 	{(unsigned long)__GFP_NO_KSWAPD,	"GFP_NO_KSWAPD"},	\
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

