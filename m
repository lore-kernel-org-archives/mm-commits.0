From: akpm@linux-foundation.org
Subject: +
 mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch added to -mm tree
Date: Mon, 24 Nov 2014 13:57:19 -0800
Message-ID: <5473a9bf.m9p/jAEU3eptq5QE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaKXV45 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Nov 2014 16:56:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nasa4836@gmail.com, hannes@cmpxchg.org, jianyu.zhan@emc.com, kirill@linux.intel.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, gfp: escalatedly define GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE
has been added to the -mm tree.  Its filename is
     mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Acked-by: Kirill A. Shutemov <kirill@linux.intel.com>
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

mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch

