Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD65C43461
	for <mm-commits@archiver.kernel.org>; Wed, 21 Apr 2021 00:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE0176024A
	for <mm-commits@archiver.kernel.org>; Wed, 21 Apr 2021 00:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbhDUAWi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Apr 2021 20:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233863AbhDUAWi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Apr 2021 20:22:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C88B261409;
        Wed, 21 Apr 2021 00:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618964525;
        bh=IWNCHNDee8FDaDFuD4487oUq2HTtDoN0pi2/8ulph00=;
        h=Date:From:To:Subject:From;
        b=X3ebIiOW08yfMbX0S41gSX6pdyiV0Umrt7KBobzoONEE0tO3Eyi5qRPR0VdtA94yA
         yZI/Bh0vDWwvyysDPy3jt3zIasXNfEJ0zVslcn+NzlaTVfRd13su+9/uScaZgxEous
         FfTPX0pboq2F7OjmQ1EiY3AVLiIr6lci+U7E5YOY=
Date:   Tue, 20 Apr 2021 17:22:04 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  +
 =?US-ASCII?Q?mm-introduce-memfd=5Fsecret-system-call-to-create-secret-?=
 =?US-ASCII?Q?memory-areas-fix-2.patch?= added to -mm tree
Message-ID: <20210421002204.HmKQb3VEO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: secretmem/gup: don't check if page is secretmem without reference
has been added to the -mm tree.  Its filename is
     mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: secretmem/gup: don't check if page is secretmem without reference

The check in gup_pte_range() whether a page belongs to a secretmem mapping
is performed before grabbing the page reference.

To avoid potential race move the check after try_grab_compound_head().

Link: https://lkml.kernel.org/r/20210420150049.14031-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-2
+++ a/mm/gup.c
@@ -2080,13 +2080,15 @@ static int gup_pte_range(pmd_t pmd, unsi
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
 
-		if (page_is_secretmem(page))
-			goto pte_unmap;
-
 		head = try_grab_compound_head(page, 1, flags);
 		if (!head)
 			goto pte_unmap;
 
+		if (unlikely(page_is_secretmem(page))) {
+			put_compound_head(head, 1, flags);
+			goto pte_unmap;
+		}
+
 		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
 			put_compound_head(head, 1, flags);
 			goto pte_unmap;
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin-fix.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-2.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant-fix.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch
secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch
secretmem-optimize-page_is_secretmem.patch

