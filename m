Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A4EC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 18:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240573AbiB1SpG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 13:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240454AbiB1So5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 13:44:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276813D4B1
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 10:43:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7F97B810DB
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 18:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5759BC340F1;
        Mon, 28 Feb 2022 18:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646073797;
        bh=KXNA/GwOswvlMdo/q+scHqbhZCjd4Q7jxEA+5kf5xtw=;
        h=Date:To:From:Subject:From;
        b=Qr1E7CZyTCM+aSGrrJ+xXq4z7/lbAwoNN+bjhcdjOTg3elkr3UH2Sl2MeWBZ1KPkv
         k8fiB6j4qBBDSAFUi6uMcMEaCe1vaGNOYwYzooqxSCiHoDNbs9yXvKkZC7nnG0D7Ee
         2esE+3gxFqrcQUqFT7f1nVHQ4SQOeThn8h0j1zgQ=
Date:   Mon, 28 Feb 2022 10:43:16 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mike.kravetz@oracle.com, kirill@shutemov.name, hch@infradead.org,
        dhowells@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-export-pageheadhuge-fix.patch added to -mm tree
Message-Id: <20220228184317.5759BC340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-export-pageheadhuge-fix
has been added to the -mm tree.  Its filename is
     mm-export-pageheadhuge-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-export-pageheadhuge-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-export-pageheadhuge-fix.patch

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
Subject: mm-export-pageheadhuge-fix

s/EXPORT_SYMBOL/EXPORT_SYMBOL_GPL/, per Christoph

Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-export-pageheadhuge-fix
+++ a/mm/hugetlb.c
@@ -1855,7 +1855,7 @@ int PageHeadHuge(struct page *page_head)
 
 	return page_head[1].compound_dtor == HUGETLB_PAGE_DTOR;
 }
-EXPORT_SYMBOL(PageHeadHuge);
+EXPORT_SYMBOL_GPL(PageHeadHuge);
 
 /*
  * Find and lock address space (mapping) in write mode.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
x86-mm-enable-arch_has_vm_get_page_prot-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
drivers-gpu-drm-dp-drm_dpc-fix-build.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

