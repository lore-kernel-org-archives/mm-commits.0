From: akpm@linux-foundation.org
Subject: + idr-remove-dead-code-v2.patch added to -mm tree
Date: Wed, 05 Mar 2014 12:41:55 -0800
Message-ID: <53178c13.JHxwxEB7fgYll58W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817AbaCEUl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2014 15:41:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rdunlap@infradead.org, philipp.reisner@linbit.com, linux@horizon.com, jlayton@redhat.com, jdelvare@suse.de, axboe@kernel.dk, stephen@networkplumber.org

Subject: + idr-remove-dead-code-v2.patch added to -mm tree
To: stephen@networkplumber.org,axboe@kernel.dk,jdelvare@suse.de,jlayton@redhat.com,linux@horizon.com,philipp.reisner@linbit.com,rdunlap@infradead.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 05 Mar 2014 12:41:55 -0800


The patch titled
     Subject: idr: remove dead code
has been added to the -mm tree.  Its filename is
     idr-remove-dead-code-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/idr-remove-dead-code-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/idr-remove-dead-code-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Hemminger <stephen@networkplumber.org>
Subject: idr: remove dead code

Remove no longer used deprecated code, and make local functions
static.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Cc: Jean Delvare <jdelvare@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: George Spelvin <linux@horizon.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   63 ------------------------------------------
 lib/idr.c           |   20 +------------
 2 files changed, 2 insertions(+), 81 deletions(-)

diff -puN include/linux/idr.h~idr-remove-dead-code-v2 include/linux/idr.h
--- a/include/linux/idr.h~idr-remove-dead-code-v2
+++ a/include/linux/idr.h
@@ -133,69 +133,6 @@ static inline void *idr_find(struct idr
 	for (id = 0; ((entry) = idr_get_next(idp, &(id))) != NULL; ++id)
 
 /*
- * Don't use the following functions.  These exist only to suppress
- * deprecated warnings on EXPORT_SYMBOL()s.
- */
-int __idr_pre_get(struct idr *idp, gfp_t gfp_mask);
-int __idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
-void __idr_remove_all(struct idr *idp);
-
-/**
- * idr_pre_get - reserve resources for idr allocation
- * @idp:	idr handle
- * @gfp_mask:	memory allocation flags
- *
- * Part of old alloc interface.  This is going away.  Use
- * idr_preload[_end]() and idr_alloc() instead.
- */
-static inline int __deprecated idr_pre_get(struct idr *idp, gfp_t gfp_mask)
-{
-	return __idr_pre_get(idp, gfp_mask);
-}
-
-/**
- * idr_get_new_above - allocate new idr entry above or equal to a start id
- * @idp: idr handle
- * @ptr: pointer you want associated with the id
- * @starting_id: id to start search at
- * @id: pointer to the allocated handle
- *
- * Part of old alloc interface.  This is going away.  Use
- * idr_preload[_end]() and idr_alloc() instead.
- */
-static inline int __deprecated idr_get_new_above(struct idr *idp, void *ptr,
-						 int starting_id, int *id)
-{
-	return __idr_get_new_above(idp, ptr, starting_id, id);
-}
-
-/**
- * idr_get_new - allocate new idr entry
- * @idp: idr handle
- * @ptr: pointer you want associated with the id
- * @id: pointer to the allocated handle
- *
- * Part of old alloc interface.  This is going away.  Use
- * idr_preload[_end]() and idr_alloc() instead.
- */
-static inline int __deprecated idr_get_new(struct idr *idp, void *ptr, int *id)
-{
-	return __idr_get_new_above(idp, ptr, 0, id);
-}
-
-/**
- * idr_remove_all - remove all ids from the given idr tree
- * @idp: idr handle
- *
- * If you're trying to destroy @idp, calling idr_destroy() is enough.
- * This is going away.  Don't use.
- */
-static inline void __deprecated idr_remove_all(struct idr *idp)
-{
-	__idr_remove_all(idp);
-}
-
-/*
  * IDA - IDR based id allocator, use when translation from id to
  * pointer isn't necessary.
  *
diff -puN lib/idr.c~idr-remove-dead-code-v2 lib/idr.c
--- a/lib/idr.c~idr-remove-dead-code-v2
+++ a/lib/idr.c
@@ -196,7 +196,7 @@ static void idr_mark_full(struct idr_lay
 	}
 }
 
-int __idr_pre_get(struct idr *idp, gfp_t gfp_mask)
+static int __idr_pre_get(struct idr *idp, gfp_t gfp_mask)
 {
 	while (idp->id_free_cnt < MAX_IDR_FREE) {
 		struct idr_layer *new;
@@ -207,7 +207,6 @@ int __idr_pre_get(struct idr *idp, gfp_t
 	}
 	return 1;
 }
-EXPORT_SYMBOL(__idr_pre_get);
 
 /**
  * sub_alloc - try to allocate an id without growing the tree depth
@@ -374,20 +373,6 @@ static void idr_fill_slot(struct idr *id
 	idr_mark_full(pa, id);
 }
 
-int __idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id)
-{
-	struct idr_layer *pa[MAX_IDR_LEVEL + 1];
-	int rv;
-
-	rv = idr_get_empty_slot(idp, starting_id, pa, 0, idp);
-	if (rv < 0)
-		return rv == -ENOMEM ? -EAGAIN : rv;
-
-	idr_fill_slot(idp, ptr, rv, pa);
-	*id = rv;
-	return 0;
-}
-EXPORT_SYMBOL(__idr_get_new_above);
 
 /**
  * idr_preload - preload for idr_alloc()
@@ -607,7 +592,7 @@ void idr_remove(struct idr *idp, int id)
 }
 EXPORT_SYMBOL(idr_remove);
 
-void __idr_remove_all(struct idr *idp)
+static void __idr_remove_all(struct idr *idp)
 {
 	int n, id, max;
 	int bt_mask;
@@ -640,7 +625,6 @@ void __idr_remove_all(struct idr *idp)
 	}
 	idp->layers = 0;
 }
-EXPORT_SYMBOL(__idr_remove_all);
 
 /**
  * idr_destroy - release all cached layers within an idr tree
_

Patches currently in -mm which might be from stephen@networkplumber.org are

idr-remove-dead-code-v2.patch
linux-next.patch

