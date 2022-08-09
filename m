Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4B7C25B0C
	for <mm-commits@archiver.kernel.org>; Tue,  9 Aug 2022 01:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244809AbiHIBPO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Aug 2022 21:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244814AbiHIBOi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2022 21:14:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063811E3D1
        for <mm-commits@vger.kernel.org>; Mon,  8 Aug 2022 18:14:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F19A6116C
        for <mm-commits@vger.kernel.org>; Tue,  9 Aug 2022 01:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C083DC433C1;
        Tue,  9 Aug 2022 01:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660007674;
        bh=qyC+7iii2TLlC4QJVf7e+JTRjL0KOg8/DlTyvFq8nPU=;
        h=Date:To:From:Subject:From;
        b=bI6D8KkVoL8tBhZu9clxNEi/v01F/Bzd1joCwjG9D5RCxrgzEXB5Vls0U5PZ+FR/S
         nsbBqIWUc+GD9o0HnnLt7Uwq7h1Vi2nX/RI5/9kPi0SZ/01hXUx0Cx8BBBNMglEEH5
         grFfndZJuPMe7u/hplt/TPxXnAeSjIW4SARMPP80=
Date:   Mon, 08 Aug 2022 18:14:34 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        lkp@intel.com, liushixin2@huawei.com, linmiaohe@huawei.com,
        david@redhat.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch removed from -mm tree
Message-Id: <20220809011434.C083DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: enable memory error handling on 1GB hugepage
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: enable memory error handling on 1GB hugepage
Date: Thu, 14 Jul 2022 13:24:20 +0900

Now error handling code is prepared, so remove the blocking code and
enable memory error handling on 1GB hugepage.

Link: https://lkml.kernel.org/r/20220714042420.1847125-9-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    1 -
 include/ras/ras_event.h |    1 -
 mm/memory-failure.c     |   16 ----------------
 3 files changed, 18 deletions(-)

--- a/include/linux/mm.h~mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage
+++ a/include/linux/mm.h
@@ -3229,7 +3229,6 @@ enum mf_action_page_type {
 	MF_MSG_DIFFERENT_COMPOUND,
 	MF_MSG_HUGE,
 	MF_MSG_FREE_HUGE,
-	MF_MSG_NON_PMD_HUGE,
 	MF_MSG_UNMAP_FAILED,
 	MF_MSG_DIRTY_SWAPCACHE,
 	MF_MSG_CLEAN_SWAPCACHE,
--- a/include/ras/ras_event.h~mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage
+++ a/include/ras/ras_event.h
@@ -360,7 +360,6 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_DIFFERENT_COMPOUND, "different compound page after locking" ) \
 	EM ( MF_MSG_HUGE, "huge page" )					\
 	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
-	EM ( MF_MSG_NON_PMD_HUGE, "non-pmd-sized huge page" )		\
 	EM ( MF_MSG_UNMAP_FAILED, "unmapping failed page" )		\
 	EM ( MF_MSG_DIRTY_SWAPCACHE, "dirty swapcache page" )		\
 	EM ( MF_MSG_CLEAN_SWAPCACHE, "clean swapcache page" )		\
--- a/mm/memory-failure.c~mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage
+++ a/mm/memory-failure.c
@@ -768,7 +768,6 @@ static const char * const action_page_ty
 	[MF_MSG_DIFFERENT_COMPOUND]	= "different compound page after locking",
 	[MF_MSG_HUGE]			= "huge page",
 	[MF_MSG_FREE_HUGE]		= "free huge page",
-	[MF_MSG_NON_PMD_HUGE]		= "non-pmd-sized huge page",
 	[MF_MSG_UNMAP_FAILED]		= "unmapping failed page",
 	[MF_MSG_DIRTY_SWAPCACHE]	= "dirty swapcache page",
 	[MF_MSG_CLEAN_SWAPCACHE]	= "clean swapcache page",
@@ -1885,21 +1884,6 @@ retry:
 
 	page_flags = head->flags;
 
-	/*
-	 * TODO: hwpoison for pud-sized hugetlb doesn't work right now, so
-	 * simply disable it. In order to make it work properly, we need
-	 * make sure that:
-	 *  - conversion of a pud that maps an error hugetlb into hwpoison
-	 *    entry properly works, and
-	 *  - other mm code walking over page table is aware of pud-aligned
-	 *    hwpoison entries.
-	 */
-	if (huge_page_size(page_hstate(head)) > PMD_SIZE) {
-		action_result(pfn, MF_MSG_NON_PMD_HUGE, MF_IGNORED);
-		res = -EBUSY;
-		goto out;
-	}
-
 	if (!hwpoison_user_mappings(p, pfn, flags, head)) {
 		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


