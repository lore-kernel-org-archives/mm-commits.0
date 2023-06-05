Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6E5C7EE24
	for <mm-commits@archiver.kernel.org>; Mon,  5 Jun 2023 21:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbjFEVq7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Jun 2023 17:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjFEVq6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2023 17:46:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03367E9
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 14:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9180862521
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 21:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6209C433EF;
        Mon,  5 Jun 2023 21:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686001616;
        bh=pYB2CUV44W5BpnAX8Sj/TpNNWKLVSGu28nZ2shP6GGw=;
        h=Date:To:From:Subject:From;
        b=SjzHhOiIoSkPEHlXmAPy/mqlZml5Yd/mqLvci2104Q/urIrmtgD/rl3OjHQHv7J9t
         LBy09qpOsMhjRC4QjVjAdU6aNkTQCf5mqXi2dDhjQmie3LX15kQ83dnAZKsoctCbT2
         e7MQBbabSLJmXP+5o2zPZ9JR7E39ftt6+LLQFLJw=
Date:   Mon, 05 Jun 2023 14:46:55 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-obsolete-alloc_migrate_target.patch added to mm-unstable branch
Message-Id: <20230605214655.E6209C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove obsolete alloc_migrate_target()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-obsolete-alloc_migrate_target.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-obsolete-alloc_migrate_target.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: remove obsolete alloc_migrate_target()
Date: Sat, 3 Jun 2023 22:25:13 +0800

There's only declaration left in the header file. Remove it.

Link: https://lkml.kernel.org/r/20230603142513.787000-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/page-isolation.h~mm-remove-obsolete-alloc_migrate_target
+++ a/include/linux/page-isolation.h
@@ -45,7 +45,4 @@ void undo_isolate_page_range(unsigned lo
 
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
 			int isol_flags);
-
-struct page *alloc_migrate_target(struct page *page, unsigned long private);
-
 #endif
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-remove-obsolete-alloc_migrate_target.patch

