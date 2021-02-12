Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 922D7C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 00:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 609F064E4A
	for <mm-commits@archiver.kernel.org>; Fri, 12 Feb 2021 00:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhBLAGJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Feb 2021 19:06:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:54406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhBLAGJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Feb 2021 19:06:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89EB264D8F;
        Fri, 12 Feb 2021 00:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613088328;
        bh=JeU5TJ4RoVFDly9h5DhO/+qvnohsJ30XtyIs2X9HQkE=;
        h=Date:From:To:Subject:From;
        b=pFyfEWjYBJhc+8pE0BcVaN3r+vNifL3dFowJFcKaCmdtvimXJsT/kHMYNSxtjHuJW
         mxXp3JdxXeQEG7eVxf0Azj66SP68lTYv6Cknaf1cXaV7JqSY1v3FIaYq86vhLae5lc
         /edZfn+rIFXkTl4punSZRpwipL4JqalyNgsHRFfo=
Date:   Thu, 11 Feb 2021 16:05:28 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rientjes@google.com,
        daizhiyuan@phytium.com.cn
Subject:  + mm-slab-minor-coding-style-tweaks.patch added to -mm tree
Message-ID: <20210212000528.LgHxm%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: minor coding style tweaks
has been added to the -mm tree.  Its filename is
     mm-slab-minor-coding-style-tweaks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slab-minor-coding-style-tweaks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-minor-coding-style-tweaks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/slab: minor coding style tweaks

Fix some coding style issues, improve code reading.  Adds whitespace to
clearly separate the parameters.

Link: https://lkml.kernel.org/r/1612841499-32166-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/slab.c~mm-slab-minor-coding-style-tweaks
+++ a/mm/slab.c
@@ -272,7 +272,7 @@ static void kmem_cache_node_init(struct
 #define	STATS_DEC_ACTIVE(x)	((x)->num_active--)
 #define	STATS_INC_ALLOCED(x)	((x)->num_allocations++)
 #define	STATS_INC_GROWN(x)	((x)->grown++)
-#define	STATS_ADD_REAPED(x,y)	((x)->reaped += (y))
+#define	STATS_ADD_REAPED(x, y)	((x)->reaped += (y))
 #define	STATS_SET_HIGH(x)						\
 	do {								\
 		if ((x)->num_active > (x)->high_mark)			\
@@ -296,7 +296,7 @@ static void kmem_cache_node_init(struct
 #define	STATS_DEC_ACTIVE(x)	do { } while (0)
 #define	STATS_INC_ALLOCED(x)	do { } while (0)
 #define	STATS_INC_GROWN(x)	do { } while (0)
-#define	STATS_ADD_REAPED(x,y)	do { (void)(y); } while (0)
+#define	STATS_ADD_REAPED(x, y)	do { (void)(y); } while (0)
 #define	STATS_SET_HIGH(x)	do { } while (0)
 #define	STATS_INC_ERR(x)	do { } while (0)
 #define	STATS_INC_NODEALLOCS(x)	do { } while (0)
@@ -332,7 +332,7 @@ static int obj_offset(struct kmem_cache
 static unsigned long long *dbg_redzone1(struct kmem_cache *cachep, void *objp)
 {
 	BUG_ON(!(cachep->flags & SLAB_RED_ZONE));
-	return (unsigned long long*) (objp + obj_offset(cachep) -
+	return (unsigned long long *) (objp + obj_offset(cachep) -
 				      sizeof(unsigned long long));
 }
 
@@ -580,7 +580,7 @@ static int transfer_objects(struct array
 	if (!nr)
 		return 0;
 
-	memcpy(to->entry + to->avail, from->entry + from->avail -nr,
+	memcpy(to->entry + to->avail, from->entry + from->avail - nr,
 			sizeof(void *) *nr);
 
 	from->avail -= nr;
@@ -2737,7 +2737,7 @@ static void *cache_free_debugcheck(struc
 
 #else
 #define kfree_debugcheck(x) do { } while(0)
-#define cache_free_debugcheck(x,objp,z) (objp)
+#define cache_free_debugcheck(x, objp, z) (objp)
 #endif
 
 static inline void fixup_objfreelist_debug(struct kmem_cache *cachep,
@@ -3024,7 +3024,7 @@ static void *cache_alloc_debugcheck_afte
 	return objp;
 }
 #else
-#define cache_alloc_debugcheck_after(a,b,objp,d) (objp)
+#define cache_alloc_debugcheck_after(a, b, objp, d) (objp)
 #endif
 
 static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-slab-minor-coding-style-tweaks.patch
mm-slub-minor-coding-style-tweaks.patch
mm-hugetlbc-fix-typos-in-comments.patch

