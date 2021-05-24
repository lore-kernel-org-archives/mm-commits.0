Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86092C2B9F7
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 23:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F464613FC
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 23:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhEXX4J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 May 2021 19:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhEXX4I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 May 2021 19:56:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBD47613D5;
        Mon, 24 May 2021 23:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621900480;
        bh=fB+5Se3LvSSx7PgVjZpK37eHHgtnTO2lhdZyvdmBDAA=;
        h=Date:From:To:Subject:From;
        b=MnmU9VYSK1fzw1a+hIxfIR2OsFMs40vuI5/MdnanQVOsRhinQ+WmD+9SB72DtwS7D
         IAMz+m3uTpoBb2f870up1W716VaUhvhX5nRyoARV7kqxN0TxvcpV62tdNf9xUElguS
         PRUnwjXONIE8Sq8t+/aRLUtlvzwQgOfxtu5YEN64=
Date:   Mon, 24 May 2021 16:54:39 -0700
From:   akpm@linux-foundation.org
To:     abaci@linux.alibaba.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        yang.lee@linux.alibaba.com
Subject:  + mm-memcontrol-fix-kernel-doc.patch added to -mm tree
Message-ID: <20210524235439.Nzu7BymQU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix kernel-doc
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-kernel-doc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-kernel-doc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-kernel-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm: memcontrol: fix kernel-doc

Fix function name in mm/memcontrol.c kernel-doc comment to remove a
warning.

mm/memcontrol.c:6546: warning: expecting prototype for
mem_cgroup_protected(). Prototype was for
mem_cgroup_calculate_protection() instead.

Link: https://lkml.kernel.org/r/1621851862-34443-1-git-send-email-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-kernel-doc
+++ a/mm/memcontrol.c
@@ -6625,7 +6625,7 @@ static unsigned long effective_protectio
 }
 
 /**
- * mem_cgroup_protected - check if memory consumption is in the normal range
+ * mem_cgroup_calculate_protection - check if memory consumption is in the normal range
  * @root: the top ancestor of the sub-tree being checked
  * @memcg: the memory cgroup to check
  *
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

mm-memcontrol-fix-kernel-doc.patch

