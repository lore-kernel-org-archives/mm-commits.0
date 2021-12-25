Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56465C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 25 Dec 2021 03:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhLYDrI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Dec 2021 22:47:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55594 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhLYDrI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Dec 2021 22:47:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02ECBB82395
        for <mm-commits@vger.kernel.org>; Sat, 25 Dec 2021 03:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA8FC36AE9;
        Sat, 25 Dec 2021 03:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640404025;
        bh=fzWsKSWWQRaMLUnIrYIp20b2DES+aGRAcIm02qD5R1A=;
        h=Date:From:To:Subject:From;
        b=LmecAD5zUyqnK37xYih3dn4syIPeHeT7AShNMNiPrwLTHg2fMpDGr2i5hlTTQpUC6
         uOxIDz2qLYMdgCAcDhezlV70vTLw3eSTzA1hVKCd5khhbOu9FB0FtWXgXrZ2AXNjB4
         33KROERHjQOfK6FWmdBLbA3gmwOqnncWBsxLc5vc=
Date:   Fri, 24 Dec 2021 19:47:03 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        luofei@unicloud.com, naoya.horiguchi@linux.dev
Subject:  [folded-merged]
 mm-hwpoison-fix-condition-in-free-hugetlb-page-path-fix.patch removed from
 -mm tree
Message-ID: <20211225034703.-h7Gz%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-fix-condition-in-free-hugetlb-page-path-fix
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-condition-in-free-hugetlb-page-path-fix.patch

This patch was dropped because it was folded into mm-hwpoison-fix-condition-in-free-hugetlb-page-path.patch

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Subject: mm-hwpoison-fix-condition-in-free-hugetlb-page-path-fix

fix "HardwareCorrupted" counter

Link: https://lkml.kernel.org/r/20211220084851.GA1460264@u2004
Cc: Fei Luo <luofei@unicloud.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-condition-in-free-hugetlb-page-path-fix
+++ a/mm/memory-failure.c
@@ -1478,9 +1478,11 @@ static int memory_failure_hugetlb(unsign
 				return 0;
 			}
 			unlock_page(head);
-			res = MF_RECOVERED;
-			if (!page_handle_poison(p, true, false))
-				res = MF_FAILED;
+			res = MF_FAILED;
+			if (__page_handle_poison(p)) {
+				page_ref_inc(p);
+				res = MF_RECOVERED;
+			}
 			action_result(pfn, MF_MSG_FREE_HUGE, res);
 			return res == MF_RECOVERED ? 0 : -EBUSY;
 		} else if (res < 0) {
_

Patches currently in -mm which might be from naoya.horiguchi@linux.dev are

mm-hwpoison-fix-condition-in-free-hugetlb-page-path.patch

