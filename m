Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15938C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9D99221FF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633283;
	bh=RKsqDCvQBnswaEDzFNjDstwyZvGAUGprpL/HOZ5spGU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Ut4JLkU4COIZj3qebJujnT2XnKYXAs6Errpx7jH2nJ0DLAJg5Yfg3S6fZwsnuNQ6G
	 McCTs1FoggYCOStadLcQ6E62t2cYiOjzBH0UcLJgAtpXo1roBO0y5dzXbdqK4u9GYV
	 nAlJQtNL2sUL0zVrxnf/nbgm3AoKb1XQmvE+82eg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgJMXyn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727306AbgJMXyn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBF9321D7B;
        Tue, 13 Oct 2020 23:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633283;
        bh=RKsqDCvQBnswaEDzFNjDstwyZvGAUGprpL/HOZ5spGU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PUOwNJUHhI+iViIqGAe95ys65qayMLldpJDdODOmnPxiY7wiBETgXJZl5FWCtaSsU
         jdE0CZfWENE/PoqzL7JI1E45eneOeNEYNrSgNa4elWR7bnmHsSC0dNeNJDBCU4ud77
         ngUburfapKUTo6Thyx4ywUkFnQfXYk5MAQHZK0HU=
Date:   Tue, 13 Oct 2020 16:54:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        tian.xianting@h3c.com, torvalds@linux-foundation.org
Subject:  [patch 115/181] mm/memory-failure: do pgoff calculation
 before for_each_process()
Message-ID: <20201013235442.aQsdH_NtH%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
