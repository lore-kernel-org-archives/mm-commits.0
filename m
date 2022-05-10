Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0398BC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiEJEVk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbiEJEUb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3DA2AC6F7
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E4C561771
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C72FC385C2;
        Tue, 10 May 2022 04:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156106;
        bh=GQLnoDa0s1RropFntyupBVPCm4YAPI8v4FbBBY/14QA=;
        h=Date:To:From:Subject:From;
        b=EGMxguu0Rn0fRrhRdoFGeLN08OJs/lo6tpL9BpFVD1wLDgwOL9o2Yk87JojhDngPC
         W38Q/RMGsEl6uoa2odotJ1DXPI0EPHCuE0np+XbH67Md5uM/b625wVRrpmTS0uIURX
         o9gk0Jl8BYQnLT3banyPlxlfD9flMX+raVl6GQPE=
Date:   Mon, 09 May 2022 21:15:05 -0700
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        jhubbard@nvidia.com, yury.norov@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-fix-comments-to-pin_user_pages_.patch removed from -mm tree
Message-Id: <20220510041506.7C72FC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: fix comments to pin_user_pages_*()
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-comments-to-pin_user_pages_.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: mm/gup: fix comments to pin_user_pages_*()

pin_user_pages API forces FOLL_PIN in gup_flags, which means that the API
requires struct page **pages to be provided (not NULL).  However, the
comment to pin_user_pages() clearly allows for passing in a NULL @pages
argument.

Remove the incorrect comments, and add WARN_ON_ONCE(!pages) calls to
enforce the API.

It has been independently spotted by Minchan Kim and confirmed with
John Hubbard:

https://lore.kernel.org/all/YgWA0ghrrzHONehH@google.com/

Link: https://lkml.kernel.org/r/20220422015839.1274328-1-yury.norov@gmail.com
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-gup-fix-comments-to-pin_user_pages_
+++ a/mm/gup.c
@@ -2969,6 +2969,9 @@ int pin_user_pages_fast(unsigned long st
 	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
 		return -EINVAL;
 
+	if (WARN_ON_ONCE(!pages))
+		return -EINVAL;
+
 	gup_flags |= FOLL_PIN;
 	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
 }
@@ -2991,6 +2994,9 @@ int pin_user_pages_fast_only(unsigned lo
 	 */
 	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
 		return 0;
+
+	if (WARN_ON_ONCE(!pages))
+		return 0;
 	/*
 	 * FOLL_FAST_ONLY is required in order to match the API description of
 	 * this routine: no fall back to regular ("slow") GUP.
@@ -3018,8 +3024,7 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast_on
  * @nr_pages:	number of pages from start to pin
  * @gup_flags:	flags modifying lookup behaviour
  * @pages:	array that receives pointers to the pages pinned.
- *		Should be at least nr_pages long. Or NULL, if caller
- *		only intends to ensure the pages are faulted in.
+ *		Should be at least nr_pages long.
  * @vmas:	array of pointers to vmas corresponding to each page.
  *		Or NULL if the caller does not require them.
  * @locked:	pointer to lock flag indicating whether lock is held and
@@ -3042,6 +3047,9 @@ long pin_user_pages_remote(struct mm_str
 	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
 		return -EINVAL;
 
+	if (WARN_ON_ONCE(!pages))
+		return -EINVAL;
+
 	gup_flags |= FOLL_PIN;
 	return __get_user_pages_remote(mm, start, nr_pages, gup_flags,
 				       pages, vmas, locked);
@@ -3055,8 +3063,7 @@ EXPORT_SYMBOL(pin_user_pages_remote);
  * @nr_pages:	number of pages from start to pin
  * @gup_flags:	flags modifying lookup behaviour
  * @pages:	array that receives pointers to the pages pinned.
- *		Should be at least nr_pages long. Or NULL, if caller
- *		only intends to ensure the pages are faulted in.
+ *		Should be at least nr_pages long.
  * @vmas:	array of pointers to vmas corresponding to each page.
  *		Or NULL if the caller does not require them.
  *
@@ -3074,6 +3081,9 @@ long pin_user_pages(unsigned long start,
 	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
 		return -EINVAL;
 
+	if (WARN_ON_ONCE(!pages))
+		return -EINVAL;
+
 	gup_flags |= FOLL_PIN;
 	return __gup_longterm_locked(current->mm, start, nr_pages,
 				     pages, vmas, gup_flags);
@@ -3092,6 +3102,9 @@ long pin_user_pages_unlocked(unsigned lo
 	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
 		return -EINVAL;
 
+	if (WARN_ON_ONCE(!pages))
+		return -EINVAL;
+
 	gup_flags |= FOLL_PIN;
 	return get_user_pages_unlocked(start, nr_pages, pages, gup_flags);
 }
_

Patches currently in -mm which might be from yury.norov@gmail.com are


