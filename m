Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F242C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbjDFDEf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235163AbjDFDEG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFCF7EEA
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C9B06412E
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74BEC433EF;
        Thu,  6 Apr 2023 03:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750233;
        bh=V5W/5Pxdy2tf4Ax3Gzm8wcq0QVCyhXg3xQRFVNDjPJ8=;
        h=Date:To:From:Subject:From;
        b=01U7hhU7GhSplTYS9qphR+o0eAi5mF55tNGzq/YWGEgB6V1sWRE6cw3TKvHPuCI1C
         j3wcTVsGABbitWO6RNA0VPfKV6qsRe6wr1A32CPP85OktALH0B9NJ5Lows5KotvA3r
         cbR28FVqv8kDChPVwb1eTQP1A4OJay/W7t2kktaI=
Date:   Wed, 05 Apr 2023 20:03:53 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-prevent-userfaults-to-be-handled-under-per-vma-lock.patch removed from -mm tree
Message-Id: <20230406030353.C74BEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: prevent userfaults to be handled under per-vma lock
has been removed from the -mm tree.  Its filename was
     mm-prevent-userfaults-to-be-handled-under-per-vma-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: prevent userfaults to be handled under per-vma lock
Date: Mon, 27 Feb 2023 09:36:26 -0800

Due to the possibility of handle_userfault dropping mmap_lock, avoid fault
handling under VMA lock and retry holding mmap_lock.  This can be handled
more gracefully in the future.

Link: https://lkml.kernel.org/r/20230227173632.3292573-28-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/memory.c~mm-prevent-userfaults-to-be-handled-under-per-vma-lock
+++ a/mm/memory.c
@@ -5266,6 +5266,15 @@ retry:
 	if (!vma_start_read(vma))
 		goto inval;
 
+	/*
+	 * Due to the possibility of userfault handler dropping mmap_lock, avoid
+	 * it for now and fall back to page fault handling under mmap_lock.
+	 */
+	if (userfaultfd_armed(vma)) {
+		vma_end_read(vma);
+		goto inval;
+	}
+
 	/* Check since vm_start/vm_end might change before we lock the VMA */
 	if (unlikely(address < vma->vm_start || address >= vma->vm_end)) {
 		vma_end_read(vma);
_

Patches currently in -mm which might be from surenb@google.com are


