Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C36C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjHKW6p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234953AbjHKW6o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EA42D5B
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FC39671E7
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F125BC433C9;
        Fri, 11 Aug 2023 22:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794718;
        bh=W9C/xk0Ojq/wWOqk+U1qizPVI42Yjiqs0zeKMSfoo34=;
        h=Date:To:From:Subject:From;
        b=LvgDGolabGHKL5NJijfoy/4D+rBUZF/pGuIwTc/eXs9BKRmRNZPiBk1v3kKp7QIgK
         gfQuPZADsa9mr9FnuC2QahlYJMeCIjJMgTmPrCeX8adPQCKlSebgT6LJ5Tt/bbFZN5
         NPMnR5+m052s5hTjYl+e6uoYoOhBYVAYAep6Ebt4=
Date:   Fri, 11 Aug 2023 15:58:37 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, will@kernel.org,
        vincenzo.frascino@arm.com, surenb@google.com, steven.price@arm.com,
        qun-wei.lin@mediatek.com, Kuan-Ying.Lee@mediatek.com,
        kasan-dev@googlegroups.com, gregkh@linuxfoundation.org,
        eugenis@google.com, david@redhat.com, chinwen.chang@mediatek.com,
        catalin.marinas@arm.com, alexandru.elisei@arm.com, pcc@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-call-arch_swap_restore-from-unuse_pte.patch removed from -mm tree
Message-Id: <20230811225837.F125BC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: call arch_swap_restore() from unuse_pte()
has been removed from the -mm tree.  Its filename was
     mm-call-arch_swap_restore-from-unuse_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


