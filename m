Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D2EC433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 05:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B76E660FF2
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 05:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhEJFeN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 01:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229986AbhEJFeF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 01:34:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A375E60FF2;
        Mon, 10 May 2021 05:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620624780;
        bh=fa/65BgTYn/xk5a8L9Cy1+ebtAXPWoO8onJOhw84VP8=;
        h=Date:From:To:Subject:From;
        b=VNgCKMxIsrKlMclslGZdVuYZuqrCImmJOfN3ItznuWDldn2AhaD3f9GsTMArGxq2h
         OgpGZdl2pPVHDVgh8Ybvqv8yEpDyR+9evrBK2lfuOZa35bXWFfkkU85YCMLEicufUW
         hJc2mQH2TosiJaHBTW0YBtHlXzRcCGdJZot1ECjU=
Date:   Sun, 09 May 2021 22:33:00 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, eugenis@google.com,
        mm-commits@vger.kernel.org, pcc@google.com
Subject:  +
 mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch added
 to -mm tree
Message-ID: <20210510053300.LOJNNSpK2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix
has been added to the -mm tree.  Its filename is
     mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix

avoid 80-column tricks

Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mprotect.c~mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix
+++ a/mm/mprotect.c
@@ -47,8 +47,9 @@ static unsigned long change_pte_range(st
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
-	bool anon_writable =
-		vma_is_anonymous(vma) && (vma->vm_flags & VM_WRITE);
+	bool anon_writable;
+
+	anon_writable = vma_is_anonymous(vma) && (vma->vm_flags & VM_WRITE);
 
 	/*
 	 * Can be called with only the mmap_lock for reading by
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

