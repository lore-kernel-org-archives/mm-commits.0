Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E57AC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 23:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343539AbiELXaJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 19:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352409AbiELXaI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 19:30:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72797285AFD
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 16:30:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EF1B62047
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 23:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611B9C385B8;
        Thu, 12 May 2022 23:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652398206;
        bh=k71NsbmQjLGn4VJL1tvx9ZnOzhLYmPco18zytt9K4gg=;
        h=Date:To:From:Subject:From;
        b=j+VnwM2P23zlcfQyVGS/REwqraZBh0a//zaDaAQpDMvuRxwycYF3C0qzcpPghYMqL
         wxm+q9F3jOEN0jqxAYsB+wW1bEePdBJwIi31PoJy87xbNbfYexX/UAie6gwPjsNzHR
         0c+R5iUtDgi2IR4lCVnkqRIiUschsGJqkZeXTTnE=
Date:   Thu, 12 May 2022 16:30:05 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com, osalvador@suse.de,
        mike.kravetz@oracle.com, mcgrof@kernel.org, masahiroy@kernel.org,
        keescook@chromium.org, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-disable-hugetlb_optimize_vmemmap-when-struct-page-crosses-page-boundaries.patch added to mm-unstable branch
Message-Id: <20220512233006.611B9C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: disable hugetlb_optimize_vmemmap when struct page crosses page boundaries
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-disable-hugetlb_optimize_vmemmap-when-struct-page-crosses-page-boundaries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-disable-hugetlb_optimize_vmemmap-when-struct-page-crosses-page-boundaries.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: disable hugetlb_optimize_vmemmap when struct page crosses page boundaries

Patch series "add hugetlb_optimize_vmemmap sysctl", v11.

This series aims to add hugetlb_optimize_vmemmap sysctl to enable or
disable the feature of optimizing vmemmap pages associated with HugeTLB
pages.


This patch (of 4):

If the size of "struct page" is not the power of two but with the feature
of minimizing overhead of struct page associated with each HugeTLB is
enabled, then the vmemmap pages of HugeTLB will be corrupted after
remapping (panic is about to happen in theory).  But this only exists when
!CONFIG_MEMCG && !CONFIG_SLUB on x86_64.  However, it is not a
conventional configuration nowadays.  So it is not a real word issue, just
the result of a code review.

But we cannot prevent anyone from configuring that combined configure. 
This hugetlb_optimize_vmemmap should be disable in this case to fix this
issue.

Link: https://lkml.kernel.org/r/20220512041142.39501-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20220512041142.39501-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-disable-hugetlb_optimize_vmemmap-when-struct-page-crosses-page-boundaries
+++ a/mm/hugetlb_vmemmap.c
@@ -28,12 +28,6 @@ EXPORT_SYMBOL(hugetlb_optimize_vmemmap_k
 
 static int __init hugetlb_vmemmap_early_param(char *buf)
 {
-	/* We cannot optimize if a "struct page" crosses page boundaries. */
-	if (!is_power_of_2(sizeof(struct page))) {
-		pr_warn("cannot free vmemmap pages because \"struct page\" crosses page boundaries\n");
-		return 0;
-	}
-
 	if (!buf)
 		return -EINVAL;
 
@@ -119,6 +113,12 @@ void __init hugetlb_vmemmap_init(struct
 	if (!hugetlb_optimize_vmemmap_enabled())
 		return;
 
+	if (!is_power_of_2(sizeof(struct page))) {
+		pr_warn_once("cannot optimize vmemmap pages because \"struct page\" crosses page boundaries\n");
+		static_branch_disable(&hugetlb_optimize_vmemmap_key);
+		return;
+	}
+
 	vmemmap_pages = (nr_pages * sizeof(struct page)) >> PAGE_SHIFT;
 	/*
 	 * The head page is not to be freed to buddy allocator, the other tail
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-disable-hugetlb_optimize_vmemmap-when-struct-page-crosses-page-boundaries.patch
mm-memory_hotplug-override-memmap_on_memory-when-hugetlb_free_vmemmap=on.patch
mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing.patch
mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl.patch

