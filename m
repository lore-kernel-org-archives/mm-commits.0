Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 031F2C678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjASBQe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjASBPF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7357869B0F
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26911B81F6C
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA654C433EF;
        Thu, 19 Jan 2023 01:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090863;
        bh=uDTqyDL7yVYsrbt2E8Sxfb1WNDcDcxAz+Jcqi2y04mU=;
        h=Date:To:From:Subject:From;
        b=wySLU5mSg/vc6sPSHRHrIdmDPUJKCkBjr8DTKpLJdMlK2+Osn/mCk3LM270Cxw+a/
         pIdC91zLPFnjf/Ga2wkJHBcHu92riQpJdy6R7btdRLSPfLdjreu4fQ19LGs85xhrE/
         SaeD5zlp7cO5gXdn0OyRuaJAbfcq/ITh2qm4Wg1w=
Date:   Wed, 18 Jan 2023 17:14:23 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-initialize-variable-to-avoid-compiler-warning.patch removed from -mm tree
Message-Id: <20230119011423.CA654C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: initialize variable to avoid compiler warning
has been removed from the -mm tree.  Its filename was
     hugetlb-initialize-variable-to-avoid-compiler-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -6760,7 +6760,7 @@ bool hugetlb_reserve_pages(struct inode
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


