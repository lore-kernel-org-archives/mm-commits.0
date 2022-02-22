Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6AFC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 05:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiBVFiH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 00:38:07 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiBVFh6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 00:37:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7737091D
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 21:37:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 209BDB81852
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 04:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27E3C340E8;
        Tue, 22 Feb 2022 04:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645505537;
        bh=GxQQveovNCICVo+ux9prK0LowOatx2z1gFuQqctO3A4=;
        h=Date:To:From:Subject:From;
        b=B46zYdmutgmOJ99t4ri8yxhRO88yoze0//eSPKg1M3X1EnGC3dak2oCRNWJEbbhnv
         m7csITyO2F8LoCQHIPIKYkwL52U9nNfc0b8hvWEP9wtwifpCfUHB1CvWGtO82pzNRU
         wZj0IexdqZ1k3zrMgP1cH4k9l6oqob0HrV7mp/pQ=
Date:   Mon, 21 Feb 2022 20:52:17 -0800
To:     mm-commits@vger.kernel.org, yaozhenguo1@gmail.com, mhocko@suse.com,
        liuyuntao10@huawei.com, dan.carpenter@oracle.com,
        baolin.wang@linux.alibaba.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-clean-up-potential-spectre-issue-warnings-v2.patch added to -mm tree
Message-Id: <20220222045217.A27E3C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-clean-up-potential-spectre-issue-warnings-v2
has been added to the -mm tree.  Its filename is
     hugetlb-clean-up-potential-spectre-issue-warnings-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-clean-up-potential-spectre-issue-warnings-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-clean-up-potential-spectre-issue-warnings-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb-clean-up-potential-spectre-issue-warnings-v2

Link: https://lkml.kernel.org/r/20220218212946.35441-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Liu Yuntao <liuyuntao10@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-clean-up-potential-spectre-issue-warnings-v2
+++ a/mm/hugetlb.c
@@ -6890,7 +6890,7 @@ static int __init cmdline_parse_hugetlb_
 			break;
 
 		if (s[count] == ':') {
-			if (tmp < 0 || tmp >= MAX_NUMNODES)
+			if (tmp >= MAX_NUMNODES)
 				break;
 			nid = array_index_nospec(tmp, MAX_NUMNODES);
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

selftests-vm-cleanup-hugetlb-file-after-mremap-test.patch
selftests-memfd-clean-up-mapping-in-mfd_fail_write.patch
mm-enable-madv_dontneed-for-hugetlb-mappings.patch
selftests-vm-add-hugetlb-madvise-madv_dontneed-madv_remove-test.patch
userfaultfd-selftests-enable-hugetlb-remap-and-remove-event-testing.patch
hugetlb-clean-up-potential-spectre-issue-warnings.patch
hugetlb-clean-up-potential-spectre-issue-warnings-v2.patch

