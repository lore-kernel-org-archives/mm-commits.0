Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F086C6FA82
	for <mm-commits@archiver.kernel.org>; Wed, 14 Sep 2022 22:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiINW4q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Sep 2022 18:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiINW4p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2022 18:56:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B177FE6A
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 15:56:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F4AF61F71
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 22:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E94C433C1;
        Wed, 14 Sep 2022 22:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663196203;
        bh=KrlNA0X35dg3MstAn3FNM/nd8N04IHovuGAbPykQjpE=;
        h=Date:To:From:Subject:From;
        b=vkb+osViAfrMMaLQMWzgC3Q+VeIWQtdrj5SMxD7aDozv4q9ck4dnbhAXsLkqAXtmb
         bzXu4q2ysLMh+FRYWeBGL41aaXEns9W3JG99BhS/yn4nIN5u/se/AzjVAYV3FnQU+L
         +Xy0XWdrRY2PQ0vIjpl49mp/16w7c4rLz2nrqUiQ=
Date:   Wed, 14 Sep 2022 15:56:42 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, xupengfei@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-unnecessary-null-values-from-pointer.patch added to mm-unstable branch
Message-Id: <20220914225643.83E94C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: remove unnecessary 'NULL' values from pointer
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-remove-unnecessary-null-values-from-pointer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-unnecessary-null-values-from-pointer.patch

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
From: XU pengfei <xupengfei@nfschina.com>
Subject: mm/hugetlb: remove unnecessary 'NULL' values from pointer
Date: Wed, 14 Sep 2022 09:21:14 +0800

Pointer variables allocate memory first, and then judge.  There is no need
to initialize the assignment.

Link: https://lkml.kernel.org/r/20220914012113.6271-1-xupengfei@nfschina.com
Signed-off-by: XU pengfei <xupengfei@nfschina.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-unnecessary-null-values-from-pointer
+++ a/mm/hugetlb.c
@@ -258,7 +258,7 @@ static inline struct hugepage_subpool *s
 static struct file_region *
 get_file_region_entry_from_cache(struct resv_map *resv, long from, long to)
 {
-	struct file_region *nrg = NULL;
+	struct file_region *nrg;
 
 	VM_BUG_ON(resv->region_cache_count <= 0);
 
@@ -340,7 +340,7 @@ static bool has_same_uncharge_info(struc
 
 static void coalesce_file_region(struct resv_map *resv, struct file_region *rg)
 {
-	struct file_region *nrg = NULL, *prg = NULL;
+	struct file_region *nrg, *prg;
 
 	prg = list_prev_entry(rg, link);
 	if (&prg->link != &resv->regions && prg->to == rg->from &&
_

Patches currently in -mm which might be from xupengfei@nfschina.com are

mm-hugetlb-remove-unnecessary-null-values-from-pointer.patch

