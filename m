Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6E3C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbjDFDEb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbjDFDEF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B111310D1
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9316964125
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED955C433D2;
        Thu,  6 Apr 2023 03:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750230;
        bh=DrRaUJQfLWnlVgc7JpaDKj21XLj+/PHMESAMXn0zBLM=;
        h=Date:To:From:Subject:From;
        b=qpX1eyMVovRfNjRjhCxP9MBHLboiVLt9gEIFNROFQ/tEka2crMr+teEJCrEOuPgkZ
         f268nC0vbKURCUGc+6z9BClowEVjK8HmqgRc/e+VGQm1hC8fDcWB5xqG3Anab37DjA
         jGH6ZqFF9brErmL+6/kaiNjcAUWjyRLCkpz1ai4o=
Date:   Wed, 05 Apr 2023 20:03:49 -0700
To:     mm-commits@vger.kernel.org, 42.hyeyoo@gmail.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fall-back-to-mmap_lock-if-vma-anon_vma-is-not-yet-set.patch removed from -mm tree
Message-Id: <20230406030349.ED955C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fall back to mmap_lock if vma->anon_vma is not yet set
has been removed from the -mm tree.  Its filename was
     mm-fall-back-to-mmap_lock-if-vma-anon_vma-is-not-yet-set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: fall back to mmap_lock if vma->anon_vma is not yet set
Date: Mon, 27 Feb 2023 09:36:23 -0800

When vma->anon_vma is not set, page fault handler will set it by either
reusing anon_vma of an adjacent VMA if VMAs are compatible or by
allocating a new one.  find_mergeable_anon_vma() walks VMA tree to find a
compatible adjacent VMA and that requires not only the faulting VMA to be
stable but also the tree structure and other VMAs inside that tree. 
Therefore locking just the faulting VMA is not enough for this search. 
Fall back to taking mmap_lock when vma->anon_vma is not set.  This
situation happens only on the first page fault and should not affect
overall performance.

Link: https://lkml.kernel.org/r/20230227173632.3292573-25-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/memory.c~mm-fall-back-to-mmap_lock-if-vma-anon_vma-is-not-yet-set
+++ a/mm/memory.c
@@ -5254,6 +5254,10 @@ retry:
 	if (!vma_is_anonymous(vma))
 		goto inval;
 
+	/* find_mergeable_anon_vma uses adjacent vmas which are not locked */
+	if (!vma->anon_vma)
+		goto inval;
+
 	if (!vma_start_read(vma))
 		goto inval;
 
_

Patches currently in -mm which might be from surenb@google.com are


