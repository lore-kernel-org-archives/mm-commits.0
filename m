Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0822C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CB4920709
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597794630;
	bh=A9mHKaOjbq+Qdx8LmjQLqMYOAoSibCNEFfIAx3OWN40=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=KG5y+st0bE9wiWbx748t+8ajdVBqWpiOJ+H6aDYB4STfe07fkGQekRMNKbAu7/dr7
	 Pg64i2XAzqVnGnwGE65SYQYFWYgcpP5kLE0MWk6ZxHWgkyFAKiGEEJRly/b9bgUCsv
	 Tov+aaForY+VG2vqDBYZsjqQq9ZgJxO4ssarU0YE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgHRXua (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbgHRXu3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 19:50:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 910DC2065D;
        Tue, 18 Aug 2020 23:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597794628;
        bh=A9mHKaOjbq+Qdx8LmjQLqMYOAoSibCNEFfIAx3OWN40=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2I/zSN868ZQCm6+EU7ulhjrTx/fVRVx0gAmM9rjuAfDMCnOJyqiqnjr228f8tgWGl
         XK+VE17M4wHj+19uM81qQ1i5nRZtKPBWOzNSBGuupd6jtuTbinvvFrbSXUORjSbwUQ
         FPIw0uqxQjXVNYEYzNo9irW9EB1XFTa6RncnCf/g=
Date:   Tue, 18 Aug 2020 16:50:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, yuehaibing@huawei.com
Subject:  + mm-slab-remove-duplicate-include.patch added to -mm
 tree
Message-ID: <20200818235028.YLv7jS8ef%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.h: remove duplicate include
has been added to the -mm tree.  Its filename is
     mm-slab-remove-duplicate-include.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-remove-duplicate-include.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-remove-duplicate-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: mm/slab.h: remove duplicate include

Remove duplicate header which is included twice.

Link: http://lkml.kernel.org/r/20200818114323.58156-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/slab.h~mm-slab-remove-duplicate-include
+++ a/mm/slab.h
@@ -46,7 +46,6 @@ struct kmem_cache {
 #include <linux/kmemleak.h>
 #include <linux/random.h>
 #include <linux/sched/mm.h>
-#include <linux/kmemleak.h>
 
 /*
  * State of the slab allocator.
_

Patches currently in -mm which might be from yuehaibing@huawei.com are

mm-slab-remove-duplicate-include.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch

