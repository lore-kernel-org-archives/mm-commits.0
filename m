Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E996CC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Apr 2022 23:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiDHXsN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Apr 2022 19:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiDHXsM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2022 19:48:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588381CFCC
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 16:46:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE70A62160
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 23:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF0AC385A3;
        Fri,  8 Apr 2022 23:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649461564;
        bh=9MmVotAtsIXV/6LOvaOIeiVHN5IxRH8sFqiJcm8JWuw=;
        h=Date:To:From:Subject:From;
        b=AYY9QvLlK59vvtXB+J9zh9Mmoy/GJwmlwpkyCA7mOCXRtuiagkwX0Ccd1Cjutp4fU
         R6o8wD5+9WB7f51t9QYzZx83/q7bmXVdt2gLEUCp5orpw2kSXFq56p1FKmILn0xQDD
         qAw3N+YCJ2StzWlsc03rWQ8Mds4I4y8kSWDBqTZw=
Date:   Fri, 08 Apr 2022 16:46:03 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        dan.carpenter@oracle.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-put-page-in-already-hwpoisoned-case-with-mf_count_increased.patch added to -mm tree
Message-Id: <20220408234604.4FF0AC385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: put page in already hwpoisoned case with MF_COUNT_INCREASED
has been added to the -mm tree.  Its filename is
     mm-hwpoison-put-page-in-already-hwpoisoned-case-with-mf_count_increased.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-put-page-in-already-hwpoisoned-case-with-mf_count_increased.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-put-page-in-already-hwpoisoned-case-with-mf_count_increased.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hwpoison: put page in already hwpoisoned case with MF_COUNT_INCREASED

In already hwpoisoned case, memory_failure() is supposed to return with
releasing the page refcount taken for error handling.  But currently the
refcount is not released when called with MF_COUNT_INCREASED, which makes
page refcount inconsistent.  This should be rare and non-critical, but it
might be inconvenient in testing (unpoison doesn't work).

Link: https://lkml.kernel.org/r/20220408135323.1559401-3-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Suggested-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory-failure.c~mm-hwpoison-put-page-in-already-hwpoisoned-case-with-mf_count_increased
+++ a/mm/memory-failure.c
@@ -1809,6 +1809,8 @@ try_again:
 		res = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
 			res = kill_accessing_process(current, pfn, flags);
+		if (flags & MF_COUNT_INCREASED)
+			put_page(p);
 		goto unlock_mutex;
 	}
 
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb.patch
mm-hwpoison-put-page-in-already-hwpoisoned-case-with-mf_count_increased.patch
revert-mm-memory-failurec-fix-race-with-changing-page-compound-again.patch

