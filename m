Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F92EC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 01:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A602078B
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 01:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597800770;
	bh=+g0E1lFxw8Ye7RaJV1hon7DJw37cuAgnkWTbXj2GE5w=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=eMhU6DmGVHI0uu1rRvVtXDlDlBD6YmYrEyC8Lx3L4ta2O9loMoOCxFyl55IbZ2JB9
	 HWk0OSUvN28FKPL/pqwJS88I+ZBX5Ht+GQjk3VP6GFqrWfY5ymio28RBZoLXcz8UQu
	 yDMbS5rRpeiD5dLLZ9DQNaEgq6pzKmd02vZSeOqk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgHSBct (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 21:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgHSBct (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 21:32:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CEDE20657;
        Wed, 19 Aug 2020 01:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597800768;
        bh=+g0E1lFxw8Ye7RaJV1hon7DJw37cuAgnkWTbXj2GE5w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UmMJ/0OvOFPxddmpaV4jHf58qWGzdweDNhT1qvf8VwV5HeJjIt/42cwBcknS1BRv1
         Mqh0hSOREC3nq20MLPQ5iOWbCcH+7gPWDBKM4rVShFy9HpZA+t+iTPLnLQaWYPMOqQ
         60ibSYAyagzjNEBs4r+sY5gfhYLM3PQG6eqhHSPY=
Date:   Tue, 18 Aug 2020 18:32:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        tian.xianting@h3c.com
Subject:  +
 mm-memory-failure-do-pgoff-calculation-before-for_each_process.patch added
 to -mm tree
Message-ID: <20200819013248.G89MqL_Bq%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: do pgoff calculation before for_each_process()
has been added to the -mm tree.  Its filename is
     mm-memory-failure-do-pgoff-calculation-before-for_each_process.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-do-pgoff-calculation-before-for_each_process.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-do-pgoff-calculation-before-for_each_process.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xianting Tian <tian.xianting@h3c.com>
Subject: mm/memory-failure: do pgoff calculation before for_each_process()

There is no need to calculate pgoff in each loop of for_each_process(), so
move it to the place before for_each_process(), which can save some CPU
cycles.

Link: http://lkml.kernel.org/r/20200818082647.34322-1-tian.xianting@h3c.com
Signed-off-by: Xianting Tian <tian.xianting@h3c.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-do-pgoff-calculation-before-for_each_process
+++ a/mm/memory-failure.c
@@ -484,11 +484,12 @@ static void collect_procs_file(struct pa
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
 	struct address_space *mapping = page->mapping;
+	pgoff_t pgoff;
 
 	i_mmap_lock_read(mapping);
 	read_lock(&tasklist_lock);
+	pgoff = page_to_pgoff(page);
 	for_each_process(tsk) {
-		pgoff_t pgoff = page_to_pgoff(page);
 		struct task_struct *t = task_early_kill(tsk, force_early);
 
 		if (!t)
_

Patches currently in -mm which might be from tian.xianting@h3c.com are

mm-memory-failure-do-pgoff-calculation-before-for_each_process.patch

