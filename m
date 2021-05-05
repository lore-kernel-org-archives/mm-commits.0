Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33752C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CD0D613BA
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhEEBBT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231600AbhEEBBS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:01:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A743D613CB;
        Wed,  5 May 2021 01:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176422;
        bh=5t3YY8Hy469uFAjBkqdRo1DSUr9eizzTv8BThy7vPyo=;
        h=Date:From:To:Subject:From;
        b=VbqmHn/X1AJTUNMJHbLK2Gc54PNuOkoACRzJZIYRbEQFZogGwpmFd5qS7+3U7cMLy
         1nm20FJVHjN6Krk69RlCjuO/XVHl75fCPN0S4Dsp79AxamKWc/qGBmda1BuwJ+h9Ey
         k9GO9b+QGJOaOZBAgznHHOLXxT5KMJDQFqGc5/Yw=
Date:   Tue, 04 May 2021 18:00:22 -0700
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  [folded-merged] mm-mlock-minor-coding-style-tweaks.patch
 removed from -mm tree
Message-ID: <20210505010022.ImH6P6hha%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock: minor coding style tweaks
has been removed from the -mm tree.  Its filename was
     mm-mlock-minor-coding-style-tweaks.patch

This patch was dropped because it was folded into mm-mempool-minor-coding-style-tweaks.patch

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/mlock: minor coding style tweaks

Move the pointer location to fix coding style issues, improve code
reading.

Link: https://lkml.kernel.org/r/1613956588-2453-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mlock.c~mm-mlock-minor-coding-style-tweaks
+++ a/mm/mlock.c
@@ -559,7 +559,7 @@ static int apply_vma_lock_flags(unsigned
 				vm_flags_t flags)
 {
 	unsigned long nstart, end, tmp;
-	struct vm_area_struct * vma, * prev;
+	struct vm_area_struct *vma, *prev;
 	int error;
 
 	VM_BUG_ON(offset_in_page(start));
@@ -737,7 +737,7 @@ SYSCALL_DEFINE2(munlock, unsigned long,
  */
 static int apply_mlockall_flags(int flags)
 {
-	struct vm_area_struct * vma, * prev = NULL;
+	struct vm_area_struct *vma, *prev = NULL;
 	vm_flags_t to_add = 0;
 
 	current->mm->def_flags &= VM_LOCKED_CLEAR_MASK;
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-memremap-fixes-improper-spdx-comment-style.patch
mm-interval_tree-add-comments-to-improve-code-reading.patch
mm-dmapool-switch-from-strlcpy-to-strscpy.patch
mm-kasan-switch-from-strlcpy-to-strscpy.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch
mm-mempool-minor-coding-style-tweaks.patch
mm-frontswap-minor-coding-style-tweaks.patch
mm-vmalloc-minor-coding-style-tweaks.patch
mm-memory_hotplug-minor-coding-style-tweaks.patch
mm-mempolicy-minor-coding-style-tweaks.patch

