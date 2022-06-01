Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534CCC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 22:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbiFAW6z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 18:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiFAW6y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 18:58:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AFBDE31F
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 15:58:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EB3160FD3
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 22:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D457C385A5;
        Wed,  1 Jun 2022 22:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654124331;
        bh=3cebf0JxNxA8uxWM8Ctug7DgJzYo9MU5cjuKd5V7hzc=;
        h=Date:To:From:Subject:From;
        b=jq5Re2hxd5N873kTdU1E8YYmDELJG5r7a24d/Ptv/ycMjIqgqYnUv2H45xH94Gx+x
         q5wudltjLtMpe/bLngml3fN6ai28CJKTiPOr9ggBvkIsxb5Ar9yBUXgcPgkhqXNu58
         SrbF+N+ycRcvkiPwKLZhq+gHEm2Fc2t0uAeY5VNA=
Date:   Wed, 01 Jun 2022 15:58:50 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mike.kravetz@oracle.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb_vmemmap-fix-config_hugetlb_page_free_vmemmap_default_on.patch removed from -mm tree
Message-Id: <20220601225851.9D457C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: fix CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-fix-config_hugetlb_page_free_vmemmap_default_on.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: fix CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON
Date: Fri, 27 May 2022 16:19:48 +0800

The following:

  commit 47010c040dec ("mm: hugetlb_vmemmap: cleanup CONFIG_HUGETLB_PAGE_FREE_VMEMMAP*")

forgot to update CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON used in
vmemmap_optimize_mode to CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON. 
The result is we cannot enable hugetlb_optimize_vmemmap at boot time when
we configure CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON.  Fix it.

Link: https://lkml.kernel.org/r/20220527081948.68832-1-songmuchun@bytedance.com
Fixes: 47010c040dec ("mm: hugetlb_vmemmap: cleanup CONFIG_HUGETLB_PAGE_FREE_VMEMMAP*")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-fix-config_hugetlb_page_free_vmemmap_default_on
+++ a/mm/hugetlb_vmemmap.c
@@ -33,7 +33,7 @@ DEFINE_STATIC_KEY_MAYBE(CONFIG_HUGETLB_P
 EXPORT_SYMBOL(hugetlb_optimize_vmemmap_key);
 
 static enum vmemmap_optimize_mode vmemmap_optimize_mode =
-	IS_ENABLED(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON);
+	IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 
 static void vmemmap_optimize_mode_switch(enum vmemmap_optimize_mode to)
 {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-introduce-section_cannot_optimize_vmemmap.patch

