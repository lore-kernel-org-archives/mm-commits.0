Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B37BC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiJCVIZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiJCVGY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B0A4D4F2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED202B811C4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A8FC433D6;
        Mon,  3 Oct 2022 21:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831142;
        bh=XhvvFPdMGP5M7sb6iBajciswXZJ8nDjQDbO6Df58btM=;
        h=Date:To:From:Subject:From;
        b=xCEyHR6CnQLSQ5XhrxGmBXCiIvTkQ+QwysBiPxJgIBikMEupGVDnkVRms9e1HQ9xd
         CL1FpDfp2Dr70U83D1+hHmK65XFUk05JQh/HBNbZIguW93COwYVDxpEyNbaCEpg08W
         brfmoUVxDGH3lN1uFavXiRVdNzsI4JontF8pHCNw=
Date:   Mon, 03 Oct 2022 14:05:41 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, zeming@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unnecessary-0-values-from-err.patch removed from -mm tree
Message-Id: <20221003210542.91A8FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb.c: remove unnecessary initialization of local `err'
has been removed from the -mm tree.  Its filename was
     mm-remove-unnecessary-0-values-from-err.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li zeming <zeming@nfschina.com>
Subject: mm/hugetlb.c: remove unnecessary initialization of local `err'
Date: Mon, 5 Sep 2022 10:09:18 +0800

Link: https://lkml.kernel.org/r/20220905020918.3552-1-zeming@nfschina.com
Signed-off-by: Li zeming <zeming@nfschina.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-remove-unnecessary-0-values-from-err
+++ a/mm/hugetlb.c
@@ -3718,7 +3718,7 @@ static ssize_t demote_store(struct kobje
 	unsigned long nr_available;
 	nodemask_t nodes_allowed, *n_mask;
 	struct hstate *h;
-	int err = 0;
+	int err;
 	int nid;
 
 	err = kstrtoul(buf, 10, &nr_demote);
_

Patches currently in -mm which might be from zeming@nfschina.com are

usr-remove-unnecessary-1-values-from-int-file.patch

