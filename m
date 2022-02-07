Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4EDC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 21:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiBGVAe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbiBGVAZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 16:00:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D2FC06173B
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 13:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94C0A61565
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 21:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AF3C004E1;
        Mon,  7 Feb 2022 21:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644267623;
        bh=L/p/g7C+GJpSFlmn4lrg4P9qJSnPutpSRlHj9WZM3VI=;
        h=Date:To:From:Subject:From;
        b=BYfwZ7Q2bfDhctD2t25b3CHknvYufWOjEcisJ1pbJrAs5+oIM061jhaIGobRdddw/
         yAQoBCRa8Xvq4+ra7BYYfIHeuyGYpDLRDoEL6TP8Ce0wTjdc9fWEcXYjzu7pKSd/8g
         hWhGx/JinOGuZcCfOi6fhHolA7jcAdRKAu9oQWIo=
Date:   Mon, 07 Feb 2022 13:00:22 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch added to -mm tree
Message-Id: <20220207210022.E9AF3C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: remove obsolete comment of __add_pages
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch

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
Subject: mm/memory_hotplug: remove obsolete comment of __add_pages

Patch series "A few cleanup patches around memory_hotplug".

This series contains a few patches to fix obsolete and misplaced comments,
clean up the try_offline_node function and so on.  


This patch (of 4):

Since commit f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded
memory to zones until online"), there is no need to pass in the zone.

Link: https://lkml.kernel.org/r/20220207133643.23427-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220207133643.23427-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-obsolete-comment-of-__add_pages
+++ a/mm/memory_hotplug.c
@@ -296,10 +296,7 @@ struct page *pfn_to_online_page(unsigned
 EXPORT_SYMBOL_GPL(pfn_to_online_page);
 
 /*
- * Reasonably generic function for adding memory.  It is
- * expected that archs that support memory hotplug will
- * call this function after deciding the zone to which to
- * add the new pages.
+ * Reasonably generic function for adding memory.
  */
 int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		struct mhp_params *params)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-mmzoneh-remove-unused-macros.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch

