From: akpm@linux-foundation.org
Subject: [merged]
 mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:07:37 -0800
Message-ID: <548d0d09.YI2CS1snai5fTqN8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbaLNEH3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nasa4836@gmail.com, hannes@cmpxchg.org, jianyu.zhan@emc.com, kirill.shutemov@linux.intel.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, gfp: escalatedly define GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE
has been removed from the -mm tree.  Its filename was
     mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: mm, gfp: escalatedly define GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE

GFP_USER, GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE are escalatedly confined
defined, also implied by their names:

GFP_USER                                  = GFP_USER
GFP_USER + __GFP_HIGHMEM                  = GFP_HIGHUSER
GFP_USER + __GFP_HIGHMEM + __GFP_MOVABLE  = GFP_HIGHUSER_MOVABLE

So just make GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE escalatedly defined to
reflect this fact.  It also makes the definition clear and texturally warn
on any furture break-up of this escalated relastionship.

Signed-off-by: Jianyu Zhan <jianyu.zhan@emc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN include/linux/gfp.h~mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable include/linux/gfp.h
--- a/include/linux/gfp.h~mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable
+++ a/include/linux/gfp.h
@@ -110,11 +110,8 @@ struct vm_area_struct;
 #define GFP_TEMPORARY	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
 			 __GFP_RECLAIMABLE)
 #define GFP_USER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
-#define GFP_HIGHUSER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL | \
-			 __GFP_HIGHMEM)
-#define GFP_HIGHUSER_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
-				 __GFP_HARDWALL | __GFP_HIGHMEM | \
-				 __GFP_MOVABLE)
+#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
+#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
 #define GFP_IOFS	(__GFP_IO | __GFP_FS)
 #define GFP_TRANSHUGE	(GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
 			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | \
_

Patches currently in -mm which might be from nasa4836@gmail.com are

origin.patch

