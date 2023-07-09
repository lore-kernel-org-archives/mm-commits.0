Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48BCEB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 01:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjGIBJZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 21:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjGIBJY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 21:09:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9262FE43
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 18:09:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3052D60B6D
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 01:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A90C433C7;
        Sun,  9 Jul 2023 01:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688864961;
        bh=i4NIqxsBT5LpyPCRqfz+ua6KVfxV3cNx6j4XSJiMvZk=;
        h=Date:To:From:Subject:From;
        b=ELGzy8Wg6Rzn5+FnD8/bHc1X0ZUsobtMWav7NzJrlsDvWLiOZGeZhJkUWtt9ViTqL
         o234vMBVGuY0D3YkC1fB3MYN58TOzj9bNc72R2hvuGKN6i65JHkBXjiEbLpAuadvtI
         G0dHhAy1Kl6ezkd8wrNkCGMri4T4w1fT8B2Cfq9A=
Date:   Sat, 08 Jul 2023 18:09:20 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        axelrasmussen@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-pte_marker_swapin_error-more-general-fix.patch added to mm-unstable branch
Message-Id: <20230709010921.83A90C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-make-pte_marker_swapin_error-more-general-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-pte_marker_swapin_error-more-general-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-pte_marker_swapin_error-more-general-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-make-pte_marker_swapin_error-more-general-fix
Date: Sat Jul  8 06:03:23 PM PDT 2023

fix CONFIG_MMU=n build

Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/mm_inline.h~mm-make-pte_marker_swapin_error-more-general-fix
+++ a/include/linux/mm_inline.h
@@ -523,6 +523,7 @@ static inline bool mm_tlb_flush_nested(s
 	return atomic_read(&mm->tlb_flush_pending) > 1;
 }
 
+#ifdef CONFIG_MMU
 /*
  * Computes the pte marker to copy from the given source entry into dst_vma.
  * If no marker should be copied, returns 0.
@@ -541,6 +542,7 @@ static inline pte_marker copy_pte_marker
 
 	return dstm;
 }
+#endif
 
 /*
  * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch

