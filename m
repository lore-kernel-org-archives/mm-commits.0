Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B57C433E6
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FC75224B8
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbhAQVYg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 16:24:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729621AbhAQVYd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 16:24:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2DAE222B3;
        Sun, 17 Jan 2021 21:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610918631;
        bh=amDLARKLW4QvryhwmREpVHgbp1NbJOGMqwj2LsI1Pk0=;
        h=Date:From:To:Subject:From;
        b=2FkbgMXeoOjJHawct5g6E2Ilw8tLwSzIjDOaAlkZJZBkhI9SDqaF8/kmJLBso/nF2
         jb4x4WvCu2tO5IJjKlT8z22OnRj4DdGRPpslD82IEjAaISAjapZXVaUlTqtiipAJhf
         7pTa2LwWPwgf1Zq0+1QCmqKSznZ6Br8McbmBN+tc=
Date:   Sun, 17 Jan 2021 13:23:49 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de
Subject:  +
 mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch added to -mm
 tree
Message-ID: <20210117212349.UtAi0p9NR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: avoid unnecessary hugetlb_acct_memory() call
has been added to the -mm tree.  Its filename is
     mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch

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
Subject: mm/hugetlb: avoid unnecessary hugetlb_acct_memory() call

When reservation accounting remains unchanged, hugetlb_acct_memory() will
do nothing except holding and releasing hugetlb_lock.  We should avoid
this unnecessary hugetlb_lock lock/unlock cycle which is happening on
'most' hugetlb munmap operations by check delta against 0 at the beginning
of hugetlb_acct_memory.

Link: https://lkml.kernel.org/r/20210115092013.61012-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call
+++ a/mm/hugetlb.c
@@ -3588,6 +3588,9 @@ static int hugetlb_acct_memory(struct hs
 {
 	int ret = -ENOMEM;
 
+	if (!delta)
+		return 0;
+
 	spin_lock(&hugetlb_lock);
 	/*
 	 * When cpuset is configured, it breaks the strict hugetlb page
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch

