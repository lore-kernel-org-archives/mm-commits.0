Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E23C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13E9D61405
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhEMAEC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 20:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352760AbhEMABx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 20:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E462461183;
        Thu, 13 May 2021 00:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620864044;
        bh=8zi5e8SeTOpVhd8Q291F5vb+VsLoMJTKEsSSbSHr4pQ=;
        h=Date:From:To:Subject:From;
        b=VX4YNZAZHM2apGASof3JiaRHhnjeJhs7NxAQmCJjeTOVvkYfQKGQR8GBYeLwEUiXh
         N3G3o3ZcDHamiziHuGkC09Ylaon/0ohfdKXNSiO5OEdWWmKQZFbQR1pewYzu+RKlRv
         UC6KrgJEqu2+sC1R4INJDuKaaxQ3Ej4QqtOm8RUk=
Date:   Wed, 12 May 2021 17:00:43 -0700
From:   akpm@linux-foundation.org
To:     hcochran@kernelspring.com, jack@suse.cz,
        mm-commits@vger.kernel.org, mszeredi@redhat.com,
        sedat.dilek@gmail.com, tj@kernel.org, wuchi.zero@gmail.com
Subject:  +
 mm-page-writeback-use-__this_cpu_inc-in-account_page_dirtied.patch added to
 -mm tree
Message-ID: <20210513000043.x8uN_Gxde%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback: use __this_cpu_inc() in account_page_dirtied()
has been added to the -mm tree.  Its filename is
     mm-page-writeback-use-__this_cpu_inc-in-account_page_dirtied.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page-writeback-use-__this_cpu_inc-in-account_page_dirtied.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writeback-use-__this_cpu_inc-in-account_page_dirtied.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chi Wu <wuchi.zero@gmail.com>
Subject: mm/page-writeback: use __this_cpu_inc() in account_page_dirtied()

As account_page_dirtied() was always protected by xa_lock_irqsave(), so
using __this_cpu_inc() is better.

Link: https://lkml.kernel.org/r/20210512144742.4764-1-wuchi.zero@gmail.com
Signed-off-by: Chi Wu <wuchi.zero@gmail.com>
Cc: Howard Cochran <hcochran@kernelspring.com>
Cc: Jan Kara <jack@suse.cz>
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

mm-page-writeback-fix-performance-when-bdis-share-of-ratio-is-0.patch
mm-page-writeback-update-the-comment-of-dirty-position-control.patch
mm-page-writeback-use-__this_cpu_inc-in-account_page_dirtied.patch

