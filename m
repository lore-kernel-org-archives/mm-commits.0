Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB62C54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiILDcB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiILD36 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809BC28730
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2EC061171
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C07C433D6;
        Mon, 12 Sep 2022 03:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953363;
        bh=YbvDq8M1siD/hXzhq1ykkZ2P9daEMwkuRUf2hVTSHSI=;
        h=Date:To:From:Subject:From;
        b=tL5ZqfLUOUdNCsKUceQAwEasCH2NBJiPTJkaW3uGYYiBk0AbB6fSxwmGmymOSz2iZ
         V+/UV83Lzeh2ITVM3pewloR+NsZUAjV7fPod0SeNUb3Ipq6LxT1pm7yBc2Ko/+DACZ
         8OqMXA7SLFvc2Lj7d5VL/XhMEux84xlAlmnVGJ8k=
Date:   Sun, 11 Sep 2022 20:29:22 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-fix-page-refcnt-leaking-in-try_memory_failure_hugetlb.patch removed from -mm tree
Message-Id: <20220912032923.54C07C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: fix page refcnt leaking in try_memory_failure_hugetlb()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-page-refcnt-leaking-in-try_memory_failure_hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, hwpoison: fix page refcnt leaking in try_memory_failure_hugetlb()
Date: Thu, 18 Aug 2022 21:00:11 +0800

Patch series "A few fixup patches for memory-failure", v2.

This series contains a few fixup patches to fix incorrect update of page
refcnt, fix possible use-after-free issue and so on.  More details can be
found in the respective changelogs.

This patch (of 6):

When hwpoison_filter() refuses to hwpoison a hugetlb page, the refcnt of
the page would have been incremented if res == 1.  Using put_page() to fix
the refcnt leaking in this case.

Link: https://lkml.kernel.org/r/20220823032346.4260-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220818130016.45313-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220818130016.45313-2-linmiaohe@huawei.com
Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-page-refcnt-leaking-in-try_memory_failure_hugetlb
+++ a/mm/memory-failure.c
@@ -1860,8 +1860,10 @@ retry:
 
 	if (hwpoison_filter(p)) {
 		hugetlb_clear_page_hwpoison(head);
-		res = -EOPNOTSUPP;
-		goto out;
+		unlock_page(head);
+		if (res == 1)
+			put_page(head);
+		return -EOPNOTSUPP;
 	}
 
 	/*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

