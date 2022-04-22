Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A29C43217
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 22:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbiDVW2n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 18:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234171AbiDVW2Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 18:28:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A48242482
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 14:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3564161EB6
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 21:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7505EC385A4;
        Fri, 22 Apr 2022 21:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650662560;
        bh=nX9E51LSrBWN6eFPfNz1TpCOEMcIEd9SLLxE7cVWm3I=;
        h=Date:To:From:Subject:From;
        b=jn42x4VN4i/I4uHH0TE/DupWDuZgeCyIK7Y9CNbnuQHfrfBm0oEjaWI2tQoJGESL8
         M65SJhHR7Sp+cJRt9T12zqk45Ajcd1zDW1pSzpp6O5gfJOslGzLhJeXC/nmsrbJw01
         t1tC+wrm15YTgTfx3bblnyVRurg/SGeWwfljlq9s=
Date:   Fri, 22 Apr 2022 14:22:39 -0700
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        jhubbard@nvidia.com, yury.norov@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-fix-comments-to-pin_user_pages_.patch added to -mm tree
Message-Id: <20220422212240.7505EC385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: fix comments to pin_user_pages_*()
has been added to the -mm tree.  Its filename is
     mm-gup-fix-comments-to-pin_user_pages_.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-fix-comments-to-pin_user_pages_.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-fix-comments-to-pin_user_pages_.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-gup-fix-comments-to-pin_user_pages_.patch

