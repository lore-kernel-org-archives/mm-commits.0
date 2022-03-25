Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12297C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354770AbiCYBf6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357456AbiCYBew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B300C12CA
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BE7460A50
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05EAC340ED;
        Fri, 25 Mar 2022 01:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171963;
        bh=CMq0ZYB9pQ9lS8pmgT+lUb9aJkevb/sM4w7aRjR+vR4=;
        h=Date:To:From:Subject:From;
        b=BMlRUqIJBlB8fYFUcNECC3MtdAWIU0LiZAmgDxGKNRSQbKWzLtJPSOM5wZLNuEhjf
         vlRG0fcJNWqCzbs82yM6bLjLG+3xfyk2JmpAdbccQKwQYZUOaWyUZcy/WusYKUTlVX
         HTSv4wwXa9zJCLuefN6CWER5/KA6Ix+7Bt1XRsL8=
Date:   Thu, 24 Mar 2022 18:32:42 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch removed from -mm tree
Message-Id: <20220325013242.F05EAC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: remove obsolete comment of __add_pages
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory_hotplug: remove obsolete comment of __add_pages

Patch series "A few cleanup patches around memory_hotplug".

This series contains a few patches to fix obsolete and misplaced comments,
clean up the try_offline_node function and so on.  


This patch (of 4):

Since commit f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded
memory to zones until online"), there is no need to pass in the zone.

[akpm@linux-foundation.org: remove the comment altogether, per David]
Link: https://lkml.kernel.org/r/20220207133643.23427-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220207133643.23427-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-obsolete-comment-of-__add_pages
+++ a/mm/memory_hotplug.c
@@ -295,12 +295,6 @@ struct page *pfn_to_online_page(unsigned
 }
 EXPORT_SYMBOL_GPL(pfn_to_online_page);
 
-/*
- * Reasonably generic function for adding memory.  It is
- * expected that archs that support memory hotplug will
- * call this function after deciding the zone to which to
- * add the new pages.
- */
 int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		struct mhp_params *params)
 {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

