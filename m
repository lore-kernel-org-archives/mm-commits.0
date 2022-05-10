Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F868C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbiEJEPn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235996AbiEJEOy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D301D24089
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EB1061738
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4ADDC385A6;
        Tue, 10 May 2022 04:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155856;
        bh=VwJykXaOlBizyWHtzWir8P8zEyjUujbCEF9JI+sHnBU=;
        h=Date:To:From:Subject:From;
        b=BKhbFzFZ0djW2SEN3Bes+GxM/FcEHiku6FrxnQtYgL7JxqvI0o7vMtnEIr2b2XINf
         8APd2omsvZcZGuoHo6BiAPjO2ot6ECyROmAO1z8eLA0bsUu277nzVyvQLKz2Rjnwgp
         W0d5wJyPU2yYKGeENg9PjLRSCvwasfCi00QrLX2M=
Date:   Mon, 09 May 2022 21:10:56 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        dan.carpenter@oracle.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-put-page-in-already-hwpoisoned-case-with-mf_count_increased.patch removed from -mm tree
Message-Id: <20220510041056.C4ADDC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hwpoison: put page in already hwpoisoned case with MF_COUNT_INCREASED
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-put-page-in-already-hwpoisoned-case-with-mf_count_increased.patch

This patch was dropped because it was merged into mm-stable

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
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory-failure.c~mm-hwpoison-put-page-in-already-hwpoisoned-case-with-mf_count_increased
+++ a/mm/memory-failure.c
@@ -1811,6 +1811,8 @@ try_again:
 		res = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
 			res = kill_accessing_process(current, pfn, flags);
+		if (flags & MF_COUNT_INCREASED)
+			put_page(p);
 		goto unlock_mutex;
 	}
 
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


