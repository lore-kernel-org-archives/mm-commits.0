Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9F2EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjFSXUZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjFSXUW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B87E1A3
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBFB160F38
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC43C433C0;
        Mon, 19 Jun 2023 23:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216820;
        bh=Nj9a2cFyAjMwW9mbKSAB5F2+a6vUomsFp92TTeywTIY=;
        h=Date:To:From:Subject:From;
        b=Agluxe7AQqIICnYofsTWKR92DlSItKV5Ga005IXkoUXN3kWq0pAsPlJWu/vk/gy5Z
         KWRPIpggLjBxJznfQoMO7vhIhZU0Vq+4wAEXTjnjChflCyx6mH2sua4y6HLyr7MPuT
         lAN0jFol6jAIb0Fb8isQEaAON1AKvvtDumSkqj3U=
Date:   Mon, 19 Jun 2023 16:20:19 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-obsolete-alloc_migrate_target.patch removed from -mm tree
Message-Id: <20230619232020.1DC43C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove obsolete alloc_migrate_target()
has been removed from the -mm tree.  Its filename was
     mm-remove-obsolete-alloc_migrate_target.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


