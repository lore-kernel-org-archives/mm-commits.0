Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46364C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 319DE6023F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhGFTMZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231737AbhGFTMZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:12:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BDBB60FE3;
        Tue,  6 Jul 2021 19:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598585;
        bh=0mdZ+m/waD0V+49g+7Y495eK3q7kTIbOd18ObcvnwVQ=;
        h=Date:From:To:Subject:From;
        b=aDrXKDzjmGGsQLbvoS15u2RacLhEUhWnaArPy4f9UDjHwr7foCSeGl2CBAeOPAfu1
         evBCZOIwq5pJ3JuiROQ6Lm1+FvL+UC5moEAjYt+5jXAiBDHFXtwULlmVqIcQ6b0pTx
         Ko+QA+JchM3Hr9jRJUEqvnZvsA2r7LOTrZ1hRRB0=
Date:   Tue, 06 Jul 2021 12:09:45 -0700
From:   akpm@linux-foundation.org
To:     hcochran@kernelspring.com, jack@suse.cz,
        mm-commits@vger.kernel.org, mszeredi@redhat.com,
        sedat.dilek@gmail.com, tj@kernel.org, wuchi.zero@gmail.com
Subject:  [merged]
 mm-page-writeback-use-__this_cpu_inc-in-account_page_dirtied.patch removed
 from -mm tree
Message-ID: <20210706190945.CUmx13XrH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback: use __this_cpu_inc() in account_page_dirtied()
has been removed from the -mm tree.  Its filename was
     mm-page-writeback-use-__this_cpu_inc-in-account_page_dirtied.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chi Wu <wuchi.zero@gmail.com>
Subject: mm/page-writeback: use __this_cpu_inc() in account_page_dirtied()

As account_page_dirtied() was always protected by xa_lock_irqsave(), so
using __this_cpu_inc() is better.

Link: https://lkml.kernel.org/r/20210512144742.4764-1-wuchi.zero@gmail.com
Signed-off-by: Chi Wu <wuchi.zero@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Howard Cochran <hcochran@kernelspring.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-page-writeback-use-__this_cpu_inc-in-account_page_dirtied
+++ a/mm/page-writeback.c
@@ -2445,7 +2445,7 @@ void account_page_dirtied(struct page *p
 		inc_wb_stat(wb, WB_DIRTIED);
 		task_io_account_write(PAGE_SIZE);
 		current->nr_dirtied++;
-		this_cpu_inc(bdp_ratelimits);
+		__this_cpu_inc(bdp_ratelimits);
 
 		mem_cgroup_track_foreign_dirty(page, wb);
 	}
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are


