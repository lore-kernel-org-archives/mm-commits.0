Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 776F6C5479D
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 22:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbjAKWMw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 17:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235870AbjAKWMu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 17:12:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FE036337
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 14:12:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87E4AB81D52
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 22:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26678C433D2;
        Wed, 11 Jan 2023 22:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673475167;
        bh=1c7FNgfgKGF2vmDnKwKGhz4KyWrgKn1Xp2I0wB7vmLM=;
        h=Date:To:From:Subject:From;
        b=0cH1lc9kR6NIlW73a2uNZ2eojum4cPHtJ5rEeDD2vD5BYZSTtKlJAyjPacGYcWG8g
         9vAh9gHj8Jaayg0o7FOKB4mIVQNIqZaCJ+56pg0cqZa14xPyGvpYMnnJh/Kdawf+ge
         /vcnCYYbcztc4bHqwGKuUtcbgGPYOzJnbgDopIj4=
Date:   Wed, 11 Jan 2023 14:12:46 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio_add_new_anon_rmap-fix.patch added to mm-unstable branch
Message-Id: <20230111221247.26678C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-folio_add_new_anon_rmap-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-folio_add_new_anon_rmap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_add_new_anon_rmap-fix.patch

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
Subject: mm-add-folio_add_new_anon_rmap-fix
Date: Wed Jan 11 02:11:45 PM PST 2023

Fix NOMMU build.  page_add_new_anon_rmap() requires CONFIG_MMU.

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/folio-compat.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/folio-compat.c~mm-add-folio_add_new_anon_rmap-fix
+++ a/mm/folio-compat.c
@@ -124,6 +124,7 @@ void putback_lru_page(struct page *page)
 	folio_putback_lru(page_folio(page));
 }
 
+#ifdef CONFIG_MMU
 void page_add_new_anon_rmap(struct page *page, struct vm_area_struct *vma,
 		unsigned long address)
 {
@@ -131,3 +132,4 @@ void page_add_new_anon_rmap(struct page
 
 	return folio_add_new_anon_rmap((struct folio *)page, vma, address);
 }
+#endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
mm-memcontrol-deprecate-charge-moving-fix.patch
mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch
mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch
mm-add-folio_add_new_anon_rmap-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch

