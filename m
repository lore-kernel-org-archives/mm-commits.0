Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16843C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 20:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJUUFV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 16:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiJUUFS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 16:05:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3C6EE8A9
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 13:05:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E76E061F6A
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 20:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E030C433C1;
        Fri, 21 Oct 2022 20:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666382714;
        bh=hy8nzF8F5MGJjW6qPrkXXfC23lObACU/kFIB4BWvvOc=;
        h=Date:To:From:Subject:From;
        b=TGeeVeIfeGq5gqkKE9ukNw0Y9Ns+4E1EfhRkwO0ALUtjjNxV5QUfkPEOtVlX4FeLS
         a+7t+Q5VUjaDGwQod8ZlCihAPE/YlnJGjp8Sz7HCJ7hSMBEz1hopBs4/5F1DuC2fEd
         XvmIV6+xKyy+MBptATD/vr8Oxzs5H0zqYQ9k5NiY=
Date:   Fri, 21 Oct 2022 13:05:13 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-avoid-pfn_valid-twice-in-soft_offline_page.patch added to mm-unstable branch
Message-Id: <20221021200514.4E030C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: avoid pfn_valid() twice in soft_offline_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-avoid-pfn_valid-twice-in-soft_offline_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-avoid-pfn_valid-twice-in-soft_offline_page.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: avoid pfn_valid() twice in soft_offline_page()
Date: Fri, 21 Oct 2022 16:46:10 +0800

Simplify WARN_ON_ONCE(flags & MF_COUNT_INCREASED) under !pfn_valid().

Link: https://lkml.kernel.org/r/20221021084611.53765-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-avoid-pfn_valid-twice-in-soft_offline_page
+++ a/mm/memory-failure.c
@@ -2554,10 +2554,10 @@ int soft_offline_page(unsigned long pfn,
 	bool try_again = true;
 	struct page *page;
 
-	WARN_ON_ONCE(!pfn_valid(pfn) && (flags & MF_COUNT_INCREASED));
-
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn)) {
+		WARN_ON_ONCE(flags & MF_COUNT_INCREASED);
 		return -ENXIO;
+	}
 
 	/* Only online pages can be soft-offlined (esp., not ZONE_DEVICE). */
 	page = pfn_to_online_page(pfn);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-rmap-rename-page_not_mapped-to-folio_not_mapped.patch
mm-remove-kern_addr_valid-completely.patch
nios2-remove-unused-init_mmap.patch
x86-sgx-use-vm_access_flags.patch
mm-mprotect-use-vm_access_flags.patch
mm-debug_vm_pgtable-use-vm_access_flags.patch
amdgpu-use-vm_access_flags.patch
mm-memory-failure-make-put_ref_page-more-useful.patch
mm-memory-failure-avoid-pfn_valid-twice-in-soft_offline_page.patch
mm-memory-failure-make-action_result-return-int.patch

