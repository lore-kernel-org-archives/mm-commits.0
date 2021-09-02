Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E64C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EFBC610E8
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347929AbhIBWBv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:01:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347666AbhIBWBu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:01:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D63D0610CF;
        Thu,  2 Sep 2021 22:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630620052;
        bh=hsalppLTlsYaoP8IHkO1XIVN4yg2GHH1N5KW0Gz3LQY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UK9apN5D1fIP22R9fUMfXy6kIVlwCbXc19Nhx3MVBW7VN7cZ2nVd3NZz6htQpVi8/
         KUyoaejJbv6Ah6zBME6xLH7VeoYeFhg47bEF34EXTFzSE7xoDZDSRSKF9MngaIKOP/
         4L/8Z7S3pXKcHC7j9qNf0JxWcxNx6MNzWQDFqJRI=
Date:   Thu, 02 Sep 2021 15:00:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        zhansayabagdaulet@gmail.com
Subject:  [patch 205/212] mm: KSM: fix data type
Message-ID: <20210902220051.abHhtqN5E%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
