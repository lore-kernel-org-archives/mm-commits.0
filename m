Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5292EC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B81661C7C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhGFTU4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229925AbhGFTUz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:20:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D52B61C7F;
        Tue,  6 Jul 2021 19:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599096;
        bh=ClHZR2yJhKfAPcPMpYtxzvdJztYC5tE6/KLERSMBkw0=;
        h=Date:From:To:Subject:From;
        b=DggqgFTJKva6x5UqZaDE83pvAMZ315EavVRPSg6njPsfIj+GcvIYpiF2oOVMm/tqj
         fTdklEh5awNc5hVgLr6RwWqNpQbuACVMQFwid4pNXBpXNhTdwsGTCm9tMrxKAiw8OZ
         66Ew5wcOxCNJv+jgH7Oq0q7wX7o/pYhZaQj+2ldM=
Date:   Tue, 06 Jul 2021 12:18:16 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-workingset-define-macro-workingset_shift.patch removed from -mm tree
Message-ID: <20210706191816.2FZWAr3eN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: define macro WORKINGSET_SHIFT
has been removed from the -mm tree.  Its filename was
     mm-workingset-define-macro-workingset_shift.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

