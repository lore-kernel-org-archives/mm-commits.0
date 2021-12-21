Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CCFEC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Dec 2021 23:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhLUXoa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 18:44:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46654 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhLUXoa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 18:44:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C0F7B81A2F
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 23:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CCEC36AE9;
        Tue, 21 Dec 2021 23:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640130268;
        bh=FXdB012iiGrm6Nj4gMqVCIAeknznstr6vXi1xxzI5zo=;
        h=Date:From:To:Subject:From;
        b=vLcejY2awguskIVK/Nje6rOpZsazMKQWNibCWqg5aRpvW4gbUqTQETwVBPNnqEBYI
         QIOel7hMdOQWBiQy+PwUsKmhP1EnQzQ5QnxJpq4p6igbKioxSQXhkrnCzyWRLwPue5
         xuVI/6dJecQrmYWNf9thOFvnFQqSlZlf0YzDutSc=
Date:   Tue, 21 Dec 2021 15:44:27 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        luofei@unicloud.com, naoya.horiguchi@linux.dev
Subject:  +
 mm-hwpoison-fix-condition-in-free-hugetlb-page-path-fix.patch added to -mm
 tree
Message-ID: <20211221234427.QrGPL%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-fix-condition-in-free-hugetlb-page-path-fix
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-condition-in-free-hugetlb-page-path-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-condition-in-free-hugetlb-page-path-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-condition-in-free-hugetlb-page-path-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hwpoison-fix-condition-in-free-hugetlb-page-path-fix.patch

