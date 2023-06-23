Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4378FEB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jun 2023 18:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjFWS3f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 14:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjFWS3e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 14:29:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DEC271E
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 11:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96C8061AC1
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 18:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33A8C433C0;
        Fri, 23 Jun 2023 18:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687544973;
        bh=I33HKL8wi5KFbm8CdoxJk3191NvtpenyG3JzJip9CLQ=;
        h=Date:To:From:Subject:From;
        b=eQw1DQNm8qUlBK78tHniGID5+Gt3TIVvfdzkIVc0qIKVt15Xo9b96czDLYqm+fzqO
         CtmsuzOTHRZXErZuN3A+4E3Ao9SJnvpOVjeqIwKI6a82VLnYcAE34WaiiUcigR9md+
         lzsOotkx+l6unin/8Fi+7UOkL38QPkfURKCXUXrY=
Date:   Fri, 23 Jun 2023 11:29:32 -0700
To:     mm-commits@vger.kernel.org, tsahu@linux.ibm.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-hugetlb_set_page_subpool.patch added to mm-unstable branch
Message-Id: <20230623182932.E33A8C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: remove hugetlb_set_page_subpool()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-remove-hugetlb_set_page_subpool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-hugetlb_set_page_subpool.patch

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

mm-hugetlb-remove-hugetlb_set_page_subpool.patch

