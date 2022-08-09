Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05367C00140
	for <mm-commits@archiver.kernel.org>; Tue,  9 Aug 2022 01:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244804AbiHIBO3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Aug 2022 21:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbiHIBOV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2022 21:14:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F061DA60
        for <mm-commits@vger.kernel.org>; Mon,  8 Aug 2022 18:14:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3A0D610A1
        for <mm-commits@vger.kernel.org>; Tue,  9 Aug 2022 01:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BE0C433D6;
        Tue,  9 Aug 2022 01:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660007659;
        bh=j4hKnxDNWRXZ0KVEXcnSpO/IePQzMK9BOGOrUT+xOm0=;
        h=Date:To:From:Subject:From;
        b=JV5S7WLZJ1TVQvhuI8ZV+dWRSRMGTZMdL43A1AVpDb31lQTnIcMzH6HQEhe/7A5sV
         Y1sK8a257vtJiiXnxigGM51TU57fa9KkSHMFWnBfXnJd5eymuQVHFwq7Rk+Tu77T/1
         V9bBJ4aHHKFAVN3+ORwl3Lw9stcBAWBmnxHk3FPg=
Date:   Mon, 08 Aug 2022 18:14:18 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch removed from -mm tree
Message-Id: <20220809011419.52BE0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: replace early_param() with core_param()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: replace early_param() with core_param()
Date: Tue, 28 Jun 2022 17:22:32 +0800

After the following commit:

  78f39084b41d ("mm: hugetlb_vmemmap: add hugetlb_optimize_vmemmap sysctl")

There is no order requirement between the parameter of
"hugetlb_free_vmemmap" and "hugepages" since we have removed the check of
whether HVO is enabled from hugetlb_vmemmap_init().  Therefore we can
safely replace early_param() with core_param() to simplify the code.

Link: https://lkml.kernel.org/r/20220628092235.91270-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Will Deacon <will@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-replace-early_param-with-core_param
+++ a/mm/hugetlb_vmemmap.c
@@ -423,14 +423,8 @@ static int vmemmap_remap_alloc(unsigned
 DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
 EXPORT_SYMBOL(hugetlb_optimize_vmemmap_key);
 
-static bool vmemmap_optimize_enabled =
-	IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
-
-static int __init hugetlb_vmemmap_early_param(char *buf)
-{
-	return kstrtobool(buf, &vmemmap_optimize_enabled);
-}
-early_param("hugetlb_free_vmemmap", hugetlb_vmemmap_early_param);
+static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
+core_param(hugetlb_free_vmemmap, vmemmap_optimize_enabled, bool, 0);
 
 /*
  * Previously discarded vmemmap pages will be allocated and remapping
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


