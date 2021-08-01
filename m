Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85D4C4338F
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 19:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F3261050
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 19:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhHATes (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Aug 2021 15:34:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhHATer (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Aug 2021 15:34:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 951B66024A;
        Sun,  1 Aug 2021 19:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627846479;
        bh=DYll+IEagL7Hnu7RtMakotQ/ai73nqUrA76aRPPA0kM=;
        h=Date:From:To:Subject:From;
        b=qZgIz6zCfo6xfIjbgQ+fZAS7V4NCG4Y9VyYF8wGHkV0eddsS0Y5frBUv4GGVW3xLr
         mXG81mReVy8zwSiEEcXCf5RIbz0Ee7AC/REl1x9FdIxY3P8t76vQ7pM0Po9IJlLF2B
         YhFlkTqp5ndTtQ6FbavSh0nI0nDstA5iYGwqdXaM=
Date:   Sun, 01 Aug 2021 12:34:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rientjes@google.com, lrizzo@google.com
Subject:  + add-mmap_assert_locked-annotations-to-find_vma.patch
 added to -mm tree
Message-ID: <20210801193439.mWVMh%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pagemap: add mmap_assert_locked() annotations to find_vma*()
has been added to the -mm tree.  Its filename is
     add-mmap_assert_locked-annotations-to-find_vma.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/add-mmap_assert_locked-annotations-to-find_vma.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/add-mmap_assert_locked-annotations-to-find_vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luigi Rizzo <lrizzo@google.com>
Subject: mm/pagemap: add mmap_assert_locked() annotations to find_vma*()

find_vma() and variants need protection when used.  This patch adds
mmap_assert_lock() calls in the functions.

To make sure the invariant is satisfied, we also need to add a
mmap_read_loc() around the get_user_pages_remote() call in get_arg_page().
The lock is not strictly necessary because the mm has been newly created,
but the extra cost is limited because the same mutex was also acquired
shortly before in __bprm_mm_init(), so it is hot and uncontended.

Link: https://lkml.kernel.org/r/20210731175341.3458608-1-lrizzo@google.com
Signed-off-by: Luigi Rizzo <lrizzo@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    2 ++
 mm/mmap.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/fs/exec.c~add-mmap_assert_locked-annotations-to-find_vma
+++ a/fs/exec.c
@@ -217,8 +217,10 @@ static struct page *get_arg_page(struct
 	 * We are doing an exec().  'current' is the process
 	 * doing the exec and bprm->mm is the new process's mm.
 	 */
+	mmap_read_lock(bprm->mm);
 	ret = get_user_pages_remote(bprm->mm, pos, 1, gup_flags,
 			&page, NULL, NULL);
+	mmap_read_unlock(bprm->mm);
 	if (ret <= 0)
 		return NULL;
 
--- a/mm/mmap.c~add-mmap_assert_locked-annotations-to-find_vma
+++ a/mm/mmap.c
@@ -534,6 +534,7 @@ static int find_vma_links(struct mm_stru
 {
 	struct rb_node **__rb_link, *__rb_parent, *rb_prev;
 
+	mmap_assert_locked(mm);
 	__rb_link = &mm->mm_rb.rb_node;
 	rb_prev = __rb_parent = NULL;
 
@@ -2303,6 +2304,7 @@ struct vm_area_struct *find_vma(struct m
 	struct rb_node *rb_node;
 	struct vm_area_struct *vma;
 
+	mmap_assert_locked(mm);
 	/* Check the cache first. */
 	vma = vmacache_find(mm, addr);
 	if (likely(vma))
_

Patches currently in -mm which might be from lrizzo@google.com are

add-mmap_assert_locked-annotations-to-find_vma.patch

