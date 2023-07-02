Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88577EB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 19:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjGBTfj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 15:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjGBTfj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 15:35:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418A9C2
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 12:35:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA5EB60C7F
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 19:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17933C433C7;
        Sun,  2 Jul 2023 19:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688326537;
        bh=n70uEL9YzTQWjw3uxLAhRzPGldcyIdrtDg7VMQciSk4=;
        h=Date:To:From:Subject:From;
        b=jQo9kxVd8Fc1bm8gPkSYTsLxGxjpV44m7wbiuj1d04joVm4ZrTrL/+D7NVrbotIHu
         9ZpHUVC8s9hD8yAHEphG9wCHdbfZo6VfR6fZCcYycoreVaKBLVx7HUo8bWGAedluNE
         yFp6TJUltmB4LRdtrMGpNjVKS8CnxGgvAWOaeHGs=
Date:   Sun, 02 Jul 2023 12:35:36 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, will@kernel.org,
        vincenzo.frascino@arm.com, surenb@google.com, steven.price@arm.com,
        qun-wei.lin@mediatek.com, Kuan-Ying.Lee@mediatek.com,
        kasan-dev@googlegroups.com, gregkh@linuxfoundation.org,
        eugenis@google.com, david@redhat.com, chinwen.chang@mediatek.com,
        catalin.marinas@arm.com, alexandru.elisei@arm.com, pcc@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-call-arch_swap_restore-from-unuse_pte.patch added to mm-unstable branch
Message-Id: <20230702193537.17933C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: call arch_swap_restore() from unuse_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-call-arch_swap_restore-from-unuse_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-call-arch_swap_restore-from-unuse_pte.patch

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
From: Peter Collingbourne <pcc@google.com>
Subject: mm: call arch_swap_restore() from unuse_pte()
Date: Mon, 22 May 2023 17:43:09 -0700

We would like to move away from requiring architectures to restore
metadata from swap in the set_pte_at() implementation, as this is not only
error-prone but adds complexity to the arch-specific code.  This requires
us to call arch_swap_restore() before calling swap_free() whenever pages
are restored from swap.  We are currently doing so everywhere except in
unuse_pte(); do so there as well.

Link: https://lkml.kernel.org/r/20230523004312.1807357-3-pcc@google.com
Link: https://linux-review.googlesource.com/id/I68276653e612d64cde271ce1b5a99ae05d6bbc4f
Signed-off-by: Peter Collingbourne <pcc@google.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kasan-dev <kasan-dev@googlegroups.com>
Cc: "Kuan-Ying Lee (李冠穎)" <Kuan-Ying.Lee@mediatek.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/swapfile.c~mm-call-arch_swap_restore-from-unuse_pte
+++ a/mm/swapfile.c
@@ -1778,6 +1778,13 @@ static int unuse_pte(struct vm_area_stru
 		goto setpte;
 	}
 
+	/*
+	 * Some architectures may have to restore extra metadata to the page
+	 * when reading from swap. This metadata may be indexed by swap entry
+	 * so this must be called before swap_free().
+	 */
+	arch_swap_restore(entry, page_folio(page));
+
 	/* See do_swap_page() */
 	BUG_ON(!PageAnon(page) && PageMappedToDisk(page));
 	BUG_ON(PageAnon(page) && PageAnonExclusive(page));
_

Patches currently in -mm which might be from pcc@google.com are

mm-call-arch_swap_restore-from-do_swap_page.patch
mm-call-arch_swap_restore-from-unuse_pte.patch
arm64-mte-simplify-swap-tag-restoration-logic.patch

