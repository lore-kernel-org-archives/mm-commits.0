Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5E9C25B70
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:50:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbjJYXur (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbjJYXtc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9478E10F6
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:49:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3BBC433CA;
        Wed, 25 Oct 2023 23:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277750;
        bh=cgzJceEEuo/faHzQS0y9MQHqzDUlN6Do7IXkyOoMy9E=;
        h=Date:To:From:Subject:From;
        b=l65EXp7avuZ7XS0m4kjXNH8O+KI7zXduErp4qKfGOwI/90SkCx3ZzVpWE8T1zwHCX
         GCXoZmbVq8+Vj7IxOniIJ3SS+sJSiw01vu4f4IPW7EZachqFBUT2/yjMBV+sx2aq0q
         FjeIOHLXRio/n5XrNy6+2Du01hp3WxHVEjO7AnO4=
Date:   Wed, 25 Oct 2023 16:49:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, rppt@kernel.org, riel@surriel.com,
        mike.kravetz@oracle.com, ira.weiny@intel.com, corbet@lwn.net,
        bobwxc@email.cn, vegard.nossum@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-fix-reference-to-nonexistent-file.patch removed from -mm tree
Message-Id: <20231025234910.2A3BBC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: fix reference to nonexistent file
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-fix-reference-to-nonexistent-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: mm: hugetlb_vmemmap: fix reference to nonexistent file
Date: Sun, 22 Oct 2023 20:56:19 +0200

The directory this file is in was renamed but the reference didn't get
updated.  Fix it.

Link: https://lkml.kernel.org/r/20231022185619.919397-1-vegard.nossum@oracle.com
Fixes: ee65728e103b ("docs: rename Documentation/vm to Documentation/mm")
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Wu XiangCheng <bobwxc@email.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_vmemmap.h~mm-hugetlb_vmemmap-fix-reference-to-nonexistent-file
+++ a/mm/hugetlb_vmemmap.h
@@ -12,7 +12,7 @@
 
 /*
  * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
- * Documentation/vm/vmemmap_dedup.rst.
+ * Documentation/mm/vmemmap_dedup.rst.
  */
 #define HUGETLB_VMEMMAP_RESERVE_SIZE	PAGE_SIZE
 #define HUGETLB_VMEMMAP_RESERVE_PAGES	(HUGETLB_VMEMMAP_RESERVE_SIZE / sizeof(struct page))
_

Patches currently in -mm which might be from vegard.nossum@oracle.com are


