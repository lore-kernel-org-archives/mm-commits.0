Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40487C4742C
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 064B020782
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:32:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="115PM5c2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732877AbgKPUcZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 15:32:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgKPUcZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 15:32:25 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAC6420782;
        Mon, 16 Nov 2020 20:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605558744;
        bh=lEfKCZuirohuhNOIyfOunNx2onRC3rYHL67hOCOU9b8=;
        h=Date:From:To:Subject:From;
        b=115PM5c25o8vbM//NsTX3RBY3xU8E0IeHOtLbgDUtgJvOXXqNlTnK2N+po96onvbD
         gqF5TqjA22vgFhVASlJHBb2kRnOWwjpEkcg9j9nIxZic8Tina28ATZcQaaMzTahb0O
         e2f3Xxqy9Dpyc4OtCaAdrC6zeQjYK0y23lGtp2eI=
Date:   Mon, 16 Nov 2020 12:32:23 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, corbet@lwn.net,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        rientjes@google.com, yang.shi@linux.alibaba.com, ziy@nvidia.com
Subject:  +
 docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch added to
 -mm tree
Message-ID: <20201116203223.oJtwCScXt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs/vm: remove unused 3 items explanation for /proc/vmstat
has been added to the -mm tree.  Its filename is
     docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: docs/vm: remove unused 3 items explanation for /proc/vmstat

Commit 5647bc293ab1 ("mm: compaction: Move migration fail/success
stats to migrate.c"), removed 3 items in /proc/vmstat. but the docs
still has their explanation. let's remove them.

"compact_blocks_moved",
"compact_pages_moved",
"compact_pagemigrate_failed",

Link: https://lkml.kernel.org/r/1605520282-51993-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~docs-vm-remove-unused-3-items-explanation-for-proc-vmstat
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -401,21 +401,6 @@ compact_fail
 	is incremented if the system tries to compact memory
 	but failed.
 
-compact_pages_moved
-	is incremented each time a page is moved. If
-	this value is increasing rapidly, it implies that the system
-	is copying a lot of data to satisfy the huge page allocation.
-	It is possible that the cost of copying exceeds any savings
-	from reduced TLB misses.
-
-compact_pagemigrate_failed
-	is incremented when the underlying mechanism
-	for moving a page failed.
-
-compact_blocks_moved
-	is incremented each time memory compaction examines
-	a huge page aligned range of pages.
-
 It is possible to establish how long the stalls were using the function
 tracer to record how long was spent in __alloc_pages_nodemask and
 using the mm_page_alloc tracepoint to identify which allocations were
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
fs-ntfs-remove-unused-varibles.patch
fs-ntfs-remove-unused-varible-attr_len.patch
mm-memcg-update-page-struct-member-in-comments.patch
docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

