Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A434BC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59F7564DF2
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbhBYTVB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:21:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234545AbhBYTRK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:17:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A19864F3B;
        Thu, 25 Feb 2021 19:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280313;
        bh=mqiFrThEtyIPz5ooGbMfsylNPCfFndG8e6KYAmSezS4=;
        h=Date:From:To:Subject:From;
        b=g1X4/Z0ZsiB9XIxuKkYF1xaLK0kf716vBOTQSYpTWdQTJRCSArnuuChSpGHKrHzb9
         uMfMnT1Om+oZ+4mji6uGVXIBeGj7OzsY6imTs9MbboC65z7aWgR8OwY32vdyAfX4vF
         uRsZJGDsZwr7ZDTmQ9/6EEwBLJfDKVac35EZmxgA=
Date:   Thu, 25 Feb 2021 11:11:53 -0800
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org,
        rientjes@google.com
Subject:  [merged] mm-slab-minor-coding-style-tweaks.patch removed
 from -mm tree
Message-ID: <20210225191153.yfOcickwn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: minor coding style tweaks
has been removed from the -mm tree.  Its filename was
     mm-slab-minor-coding-style-tweaks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


