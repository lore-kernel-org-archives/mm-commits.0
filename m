Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF78EB64D7
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbjFXABw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjFXAAk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32902693
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7711661680
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1E4C433C8;
        Sat, 24 Jun 2023 00:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564838;
        bh=vSyjDARYHquKjyUNM8AYFaCmCg8jxumVvmBxXzPpE/s=;
        h=Date:To:From:Subject:From;
        b=cVCZYAZgb9yeaIZh19nN7PEJP0Y45HMDsLRotdHcOqE1MsPUWhhYUimh5lcu4SB8P
         fSa2ciqp+bKKiTnjf84G25Geik0MccvJtSlu1ZO7XJ2sLX35q7G7qne8oNckYjog/F
         Gvj02bFsylDHWpky4aqWRpUdROdFbmV6ncKtn2PY=
Date:   Fri, 23 Jun 2023 17:00:38 -0700
To:     mm-commits@vger.kernel.org, tsahu@linux.ibm.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-remove-hugetlb_set_page_subpool.patch removed from -mm tree
Message-Id: <20230624000038.CF1E4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: remove hugetlb_set_page_subpool()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-hugetlb_set_page_subpool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: remove hugetlb_set_page_subpool()
Date: Thu, 22 Jun 2023 22:49:48 -0700

All users have been converted to hugetlb_set_folio_subpool() so we can
safely remove this function.

Link: https://lkml.kernel.org/r/20230623054948.280627-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tarun Sahu <tsahu@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-remove-hugetlb_set_page_subpool
+++ a/include/linux/hugetlb.h
@@ -761,12 +761,6 @@ static inline void hugetlb_set_folio_sub
 	folio->_hugetlb_subpool = subpool;
 }
 
-static inline void hugetlb_set_page_subpool(struct page *hpage,
-					struct hugepage_subpool *subpool)
-{
-	hugetlb_set_folio_subpool(page_folio(hpage), subpool);
-}
-
 static inline struct hstate *hstate_file(struct file *f)
 {
 	return hstate_inode(file_inode(f));
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


