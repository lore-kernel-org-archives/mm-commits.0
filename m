Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE5CC433DB
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 05:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3CB0225AC
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 05:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbhALFEU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 00:04:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbhALFEU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 00:04:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4C66225AB;
        Tue, 12 Jan 2021 05:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610427814;
        bh=0GbHJAmhMZSbgySNbw+sLn5X88JFUzqUgAcJp28goWA=;
        h=Date:From:To:Subject:From;
        b=RZHsPvVNkUgH5vJQsT0iQlUr/2lR8NYIcqMhybj1lv2GZutSzmoTFCqMOmbqA6u8G
         YHMa3Z4qLCqoFB1eIwqEhhBOTBwBAofiVangFm+UKtdKI98nNfkWom6xGOFto1J0Ob
         ctKa+5NwOoz+21OVzkvTlanEA9YePbZP6qCCODIg=
Date:   Mon, 11 Jan 2021 21:03:33 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  +
 mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch added to
 -mm tree
Message-ID: <20210112050333.VPq1tOH84%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: remove duplicated VM_BUG_ON_PAGE !PageLocked
has been added to the -mm tree.  Its filename is
     mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/compaction: remove duplicated VM_BUG_ON_PAGE !PageLocked

The VM_BUG_ON_PAGE(!PageLocked(page), page) is also done in PageMovable.
Remove this explicitly one.

Link: https://lkml.kernel.org/r/20210109081420.46030-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked
+++ a/mm/compaction.c
@@ -137,7 +137,6 @@ EXPORT_SYMBOL(__SetPageMovable);
 
 void __ClearPageMovable(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	/*
 	 * Clear registered address_space val with keeping PAGE_MAPPING_MOVABLE
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmallocc-fix-potential-memory-leak.patch
mm-hugetlb-fix-potential-missing-huge-page-size-info.patch
mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch

