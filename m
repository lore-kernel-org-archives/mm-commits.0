Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12ED9C35267
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D319B20725
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709317;
	bh=sWynb5iKvABIjxfHzo/aNMuqIeZrH0eIJjFMEz4TJAo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=fQarEU7nOEkE3eFmzTrqMB1Cjq45P/BlEsCSD8njLB2IS+pTiFEcHbyc/lqVR7Me2
	 +kLPBo/0cMSeRWQ/yul5y4aB74zW+Pgt6FWqVEWiYESL2bFtQkj6egehSXGBaXdwm/
	 CTJy/KfvVNYcxvGYf7NKsKmDSd7/MLaeeYmpgNUo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgJNVBw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730579AbgJNVBw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:52 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99003221FF;
        Wed, 14 Oct 2020 21:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709311;
        bh=sWynb5iKvABIjxfHzo/aNMuqIeZrH0eIJjFMEz4TJAo=;
        h=Date:From:To:Subject:From;
        b=QAfhlahapwhxnrLtrXuVXvcRDX3z7JzWOUAA/9IoiLbP2kAlBkGxLinlY7p0ZloUz
         kijNEFmTcH4Yh1cReVJxHlLjS/HdFFBYZkeljRAVgJp4mv4XqQodyhHD4LeZEfoPl5
         jpP2oP+QlPf6h6L4q0OjUhzOJq6ruAxnSpVrBXTU=
Date:   Wed, 14 Oct 2020 14:01:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        tian.xianting@h3c.com
Subject:  [merged]
 mm-memory-failure-do-pgoff-calculation-before-for_each_process.patch
 removed from -mm tree
Message-ID: <20201014210151.DlL8HEz1v%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: do pgoff calculation before for_each_process()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-do-pgoff-calculation-before-for_each_process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


