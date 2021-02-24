Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EC6C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8ADF64F19
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbhBXUC7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:02:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:55514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234364AbhBXUCL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49FA564F24;
        Wed, 24 Feb 2021 20:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196862;
        bh=GqC5KjqXTiGz469Xck+nzFaTNFWpRG1Prz9qgE1+Dgo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WiGbVbeFG5Oo+f3Qe1lCAnz7GyRNAhpeIK9Lcj/WD9yQiyn5YsvK9XIRNf69CfSZO
         d4kpvFtUpPtaeINZ+75R+bucjp5o6/4nraKZERXI/smlFWolMBhvW2xe9Vezq6otQB
         SYLdRc4ZIMig4Ij0e1F9E8AnYextXI8FO86v6k4s=
Date:   Wed, 24 Feb 2021 12:01:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, daizhiyuan@phytium.com.cn,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org
Subject:  [patch 016/173] mm/slab: minor coding style tweaks
Message-ID: <20210224200101.IcBvdfJKS%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
