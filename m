Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04849C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3A4C610FB
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235821AbhICU7j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349960AbhICU7h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ABD061151;
        Fri,  3 Sep 2021 20:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702717;
        bh=jLOwJQcP4VgUHElHUb8TYCRjxy8Tl0cCZh9e0ttPajw=;
        h=Date:From:To:Subject:From;
        b=O4mtDiHNpvcANnqv5VVcf6vbc8M4gDcqkzOLQlXChUQjQOeNWeUr9F+phwgHBLJTw
         wufx23dOs7ZKvbNZoG49eq1Lq6asSm+wlVEhDOWUt6QP4j53ketn74icK/byLRjYJw
         5QElprmUSSdT4ucmdSckswDnNawcBdS/wE/JQwDo=
Date:   Fri, 03 Sep 2021 13:58:37 -0700
From:   akpm@linux-foundation.org
To:     lrizzo@google.com, mm-commits@vger.kernel.org, rientjes@google.com
Subject:  [merged]
 add-mmap_assert_locked-annotations-to-find_vma.patch removed from -mm tree
Message-ID: <20210903205837.nSZuokjha%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pagemap: add mmap_assert_locked() annotations to find_vma*()
has been removed from the -mm tree.  Its filename was
     add-mmap_assert_locked-annotations-to-find_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[penguin-kernel@i-love.sakura.ne.jp: TOMOYO needs the same protection which get_arg_page() needs]
  Link: https://lkml.kernel.org/r/58bb6bf7-a57e-8a40-e74b-39584b415152@i-love.sakura.ne.jp
Link: https://lkml.kernel.org/r/20210731175341.3458608-1-lrizzo@google.com
Signed-off-by: Luigi Rizzo <lrizzo@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |    2 ++
 mm/mmap.c                |    2 ++
 security/tomoyo/domain.c |   13 +++++++++----
 3 files changed, 13 insertions(+), 4 deletions(-)

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
--- a/security/tomoyo/domain.c~add-mmap_assert_locked-annotations-to-find_vma
+++ a/security/tomoyo/domain.c
@@ -897,6 +897,9 @@ bool tomoyo_dump_page(struct linux_binpr
 		      struct tomoyo_page_dump *dump)
 {
 	struct page *page;
+#ifdef CONFIG_MMU
+	int ret;
+#endif
 
 	/* dump->data is released by tomoyo_find_next_domain(). */
 	if (!dump->data) {
@@ -909,11 +912,13 @@ bool tomoyo_dump_page(struct linux_binpr
 	/*
 	 * This is called at execve() time in order to dig around
 	 * in the argv/environment of the new proceess
-	 * (represented by bprm).  'current' is the process doing
-	 * the execve().
+	 * (represented by bprm).
 	 */
-	if (get_user_pages_remote(bprm->mm, pos, 1,
-				FOLL_FORCE, &page, NULL, NULL) <= 0)
+	mmap_read_lock(bprm->mm);
+	ret = get_user_pages_remote(bprm->mm, pos, 1,
+				    FOLL_FORCE, &page, NULL, NULL);
+	mmap_read_unlock(bprm->mm);
+	if (ret <= 0)
 		return false;
 #else
 	page = bprm->page[pos / PAGE_SIZE];
_

Patches currently in -mm which might be from lrizzo@google.com are


