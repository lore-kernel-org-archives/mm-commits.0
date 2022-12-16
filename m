Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D442EC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 23:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiLPXHb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 18:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiLPXHa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 18:07:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8956163D3A
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 15:07:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA11762250
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 23:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47549C433D2;
        Fri, 16 Dec 2022 23:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671232048;
        bh=kLEGHv9Zqf4JCcvrRnja34v+3YxNXzPYQMuTYOD1u8g=;
        h=Date:To:From:Subject:From;
        b=eyibYyPCruxTzD1hq/zczG2AhJv34gp8hPAwsVySAt9E05epoDDCZU+fL8IQxgb7W
         l1b/j7U3hHkJs2lY5SXMtnuoLaGnRxXw/apRvKbfbJBvoKhRQze46RUfj//twcRmul
         /4bG57NQLOjKcJqxMF/cXFx5euzGWQCV8lNOMkeU=
Date:   Fri, 16 Dec 2022 15:07:27 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-initialize-variable-to-avoid-compiler-warning.patch added to mm-unstable branch
Message-Id: <20221216230728.47549C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: initialize variable to avoid compiler warning
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-initialize-variable-to-avoid-compiler-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-initialize-variable-to-avoid-compiler-warning.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: initialize variable to avoid compiler warning
Date: Fri, 16 Dec 2022 14:45:07 -0800

With the gcc 'maybe-uninitialized' warning enabled, gcc will produce:

  mm/hugetlb.c:6896:20: warning: `chg' may be used uninitialized

This is a false positive, but may be difficult for the compiler to
determine.  maybe-uninitialized is disabled by default, but this gets
flagged as a 0-DAY build regression.

Initialize the variable to silence the warning.

Link: https://lkml.kernel.org/r/20221216224507.106789-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-initialize-variable-to-avoid-compiler-warning
+++ a/mm/hugetlb.c
@@ -6736,7 +6736,7 @@ bool hugetlb_reserve_pages(struct inode
 					struct vm_area_struct *vma,
 					vm_flags_t vm_flags)
 {
-	long chg, add = -1;
+	long chg = -1, add = -1;
 	struct hstate *h = hstate_inode(inode);
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	struct resv_map *resv_map;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-really-allocate-vma-lock-for-all-sharable-vmas.patch
hugetlb-update-vma-flag-check-for-hugetlb-vma-lock.patch
hugetlb-initialize-variable-to-avoid-compiler-warning.patch

