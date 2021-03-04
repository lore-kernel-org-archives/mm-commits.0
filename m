Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1F2C433DB
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD95A65041
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 01:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbhCDBQW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:16:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232288AbhCDBQC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 20:16:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F320C64F65;
        Thu,  4 Mar 2021 01:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614820521;
        bh=IBFDBzcDPn+Y0FbyZhQ3qqio8EDzI8VIX5afUJ84CWc=;
        h=Date:From:To:Subject:From;
        b=qhbMwZb05v/y8Dxp6Cn9hY9LFlcymU7P1X6dJYWTayMLwEKwHhvllPFjIcgCoWlIR
         kRIH28O1TPuihBdoheN8gAEErXoAX8soFWUsQn6L7Xv2FOl8KIBlhqsmNMfahqIpyj
         nWEBVXkhvFaz3slEka9HF/aBq2cMG5RpF9j75vqg=
Date:   Wed, 03 Mar 2021 17:15:20 -0800
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  + mm-mlock-minor-coding-style-tweaks.patch added to -mm
 tree
Message-ID: <20210304011520.-BXwFcgEk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock: minor coding style tweaks
has been added to the -mm tree.  Its filename is
     mm-mlock-minor-coding-style-tweaks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-minor-coding-style-tweaks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-minor-coding-style-tweaks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-zswap-switch-from-strlcpy-to-strscpy.patch
mm-swapfile-minor-coding-style-tweaks.patch
mm-sparse-minor-coding-style-tweaks.patch
mm-vmscan-minor-coding-style-tweaks.patch
mm-compaction-minor-coding-style-tweaks.patch
mm-oom_kill-minor-coding-style-tweaks.patch
mm-shmem-minor-coding-style-tweaks.patch
mm-page_alloc-minor-coding-style-tweaks.patch
mm-filemap-minor-coding-style-tweaks.patch
mm-mlock-minor-coding-style-tweaks.patch
mm-frontswap-minor-coding-style-tweaks.patch
mm-vmalloc-minor-coding-style-tweaks.patch
mm-memory_hotplug-minor-coding-style-tweaks.patch
mm-mempolicy-minor-coding-style-tweaks.patch

