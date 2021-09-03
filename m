Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BB6C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B25D5610E9
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239176AbhICVCm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:32956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350491AbhICVCg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6789560EE3;
        Fri,  3 Sep 2021 21:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702896;
        bh=aSRSPKwywbskR2kNBVbVGbng3lw5MZ1dXeh1M5Uuntw=;
        h=Date:From:To:Subject:From;
        b=p/f6OeXjiHlP2hThsg8qSVH3RUtqkGi/Vo/+fBCuChzgn9xwgddRLJivebyYuPnL4
         f+Tic+CyQGYE9zMn5FEo+JlcXXuZ0RwnDsldHuIRpCQaE7Bdl9NyEBeaFiVHADmzXO
         42TNu9+nbh/qJXh5kB2+XL5gINnEJHjzAr7quRf8=
Date:   Fri, 03 Sep 2021 14:01:36 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, mm-commits@vger.kernel.org,
        zhansayabagdaulet@gmail.com
Subject:  [merged] mm-ksm-fix-data-type.patch removed from -mm tree
Message-ID: <20210903210136.klU715YJk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: KSM: fix data type
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-data-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Subject: mm: KSM: fix data type

ksm_stable_node_chains_prune_millisecs is declared as int, but in
stable__node_chains_prune_millisecs_store(), it can store values up to
UINT_MAX.  Change its type to unsigned int.

Link: https://lkml.kernel.org/r/20210806111351.GA71845@asus
Signed-off-by: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/ksm.c~mm-ksm-fix-data-type
+++ a/mm/ksm.c
@@ -259,7 +259,7 @@ static unsigned long ksm_stable_node_cha
 static unsigned long ksm_stable_node_dups;
 
 /* Delay in pruning stale stable_node_dups in the stable_node_chains */
-static int ksm_stable_node_chains_prune_millisecs = 2000;
+static unsigned int ksm_stable_node_chains_prune_millisecs = 2000;
 
 /* Maximum number of page slots sharing a stable node */
 static int ksm_max_page_sharing = 256;
@@ -3105,11 +3105,11 @@ stable_node_chains_prune_millisecs_store
 					 struct kobj_attribute *attr,
 					 const char *buf, size_t count)
 {
-	unsigned long msecs;
+	unsigned int msecs;
 	int err;
 
-	err = kstrtoul(buf, 10, &msecs);
-	if (err || msecs > UINT_MAX)
+	err = kstrtouint(buf, 10, &msecs);
+	if (err)
 		return -EINVAL;
 
 	ksm_stable_node_chains_prune_millisecs = msecs;
_

Patches currently in -mm which might be from zhansayabagdaulet@gmail.com are


