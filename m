Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F1AC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D0D161468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238423AbhGABwY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABwY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:52:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A54746105A;
        Thu,  1 Jul 2021 01:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104194;
        bh=jfervTFIl6D7+YaQowUqIZ/SImxUQ6eoqGhYYf6uadE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ujVOIHFcF5fV2pP4oLZJLAhw5aP8idk+reEUeJ6p5bxX6Jd62ZAL3IUdYGIN2mt6V
         f8V431U0kPGYP08mLogXNV2LhRt9orumfV3ULuS0euvILr+NFJhD3hpthjOX8yPf+3
         YdsWLUK2q65vQdv1Pw5895sJE4mEfyHbOmCGfavw=
Date:   Wed, 30 Jun 2021 18:49:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 051/192] mm: workingset: define macro
 WORKINGSET_SHIFT
Message-ID: <20210701014954.a8xL3Jys0%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: workingset: define macro WORKINGSET_SHIFT

The magic number 1 is used in several places in workingset.c.  Define a
macro WORKINGSET_SHIFT for it to improve code readability.

Link: https://lkml.kernel.org/r/20210624122307.1759342-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/workingset.c~mm-workingset-define-macro-workingset_shift
+++ a/mm/workingset.c
@@ -168,8 +168,10 @@
  * refault distance will immediately activate the refaulting page.
  */
 
+#define WORKINGSET_SHIFT 1
 #define EVICTION_SHIFT	((BITS_PER_LONG - BITS_PER_XA_VALUE) +	\
-			 1 + NODES_SHIFT + MEM_CGROUP_ID_SHIFT)
+			 WORKINGSET_SHIFT + NODES_SHIFT + \
+			 MEM_CGROUP_ID_SHIFT)
 #define EVICTION_MASK	(~0UL >> EVICTION_SHIFT)
 
 /*
@@ -189,7 +191,7 @@ static void *pack_shadow(int memcgid, pg
 	eviction &= EVICTION_MASK;
 	eviction = (eviction << MEM_CGROUP_ID_SHIFT) | memcgid;
 	eviction = (eviction << NODES_SHIFT) | pgdat->node_id;
-	eviction = (eviction << 1) | workingset;
+	eviction = (eviction << WORKINGSET_SHIFT) | workingset;
 
 	return xa_mk_value(eviction);
 }
@@ -201,8 +203,8 @@ static void unpack_shadow(void *shadow,
 	int memcgid, nid;
 	bool workingset;
 
-	workingset = entry & 1;
-	entry >>= 1;
+	workingset = entry & ((1UL << WORKINGSET_SHIFT) - 1);
+	entry >>= WORKINGSET_SHIFT;
 	nid = entry & ((1UL << NODES_SHIFT) - 1);
 	entry >>= NODES_SHIFT;
 	memcgid = entry & ((1UL << MEM_CGROUP_ID_SHIFT) - 1);
_
