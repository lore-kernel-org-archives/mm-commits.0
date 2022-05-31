Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7EFC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 04:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiEaEUC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 00:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiEaEUC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 00:20:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4281E91572
        for <mm-commits@vger.kernel.org>; Mon, 30 May 2022 21:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D31E36115B
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 04:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A255C385A9;
        Tue, 31 May 2022 04:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653970800;
        bh=tpf1hfDU1Pkm5GKTAykgxa5CVtEM/1/09GW+ZuoVPTs=;
        h=Date:To:From:Subject:From;
        b=yQu33dIh4kUAiFryxlWJjxqZSX5lZHUBXoLnUQLfFI3UVW39NHS7IQSvQ0xy0Shas
         cKoiifAzro5eaoJPuFz3MT5Iip0jrwFroAE+KEjb1rGEh/wLQ3yQAOFHmNFCfdv/ad
         QWdCCrrdIkNyhjx0cQ985lA/ubcUrf/zN2UpQgLA=
Date:   Mon, 30 May 2022 21:19:59 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mike.kravetz@oracle.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-fix-config_hugetlb_page_free_vmemmap_default_on.patch added to mm-hotfixes-unstable branch
Message-Id: <20220531042000.2A255C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: fix CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-fix-config_hugetlb_page_free_vmemmap_default_on.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-fix-config_hugetlb_page_free_vmemmap_default_on.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-hugetlb_vmemmap-fix-config_hugetlb_page_free_vmemmap_default_on.patch

