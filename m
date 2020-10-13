Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F5EC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C98022247
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633429;
	bh=+f3C+XaYK4WzZOmmvwQWmVQMjkZstl/vMI9LhsloERY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ELJEaFtbFJ6rtTDWXWS53MVqzz3TDdkUb4mBMbOE6Z0/byWG5nn4TYNL+Gwlr2ufp
	 ioRnwJ8/7j/g0dz2FP0n/7UcUf6CQ6FAVOBXZPImXoT+w7OoA4KGL7fIA2a3izMcQJ
	 jKbnxggpwvtXgKp1kPBOoGNIooyXYOF5SXAWiyiQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389359AbgJMX5J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389233AbgJMX5J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:57:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 671952222E;
        Tue, 13 Oct 2020 23:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633428;
        bh=+f3C+XaYK4WzZOmmvwQWmVQMjkZstl/vMI9LhsloERY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HRh04Fquznd0c4q6C7KOVxK+lmVr9H6ZknMUjNLTjMJywLUmJdi85FTVaRZXH20G/
         MbUl4NJpNlFJ3b5HBo+ZtSlBi2V3bSM9AX0J3e45mjDT5Kaz02uByMElk7iopnxOU+
         9ZOIGBgLEErlkMHb4AJVB3d1l+iiHm0p4KEijE+s=
Date:   Tue, 13 Oct 2020 16:57:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        torvalds@linux-foundation.org
Subject:  [patch 159/181] mm/mempolicy: remove or narrow the lock
 on current
Message-ID: <20201013235708.jAS0Gx_Zg%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mempolicy: remove or narrow the lock on current

It is not necessary to hold the lock of current when setting nodemask of
a new policy.

Link: https://lkml.kernel.org/r/20200921040416.86185-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-remove-or-narrow-the-lock-on-current
+++ a/mm/mempolicy.c
@@ -875,13 +875,12 @@ static long do_set_mempolicy(unsigned sh
 		goto out;
 	}
 
-	task_lock(current);
 	ret = mpol_set_nodemask(new, nodes, scratch);
 	if (ret) {
-		task_unlock(current);
 		mpol_put(new);
 		goto out;
 	}
+	task_lock(current);
 	old = current->mempolicy;
 	current->mempolicy = new;
 	if (new && new->mode == MPOL_INTERLEAVE)
@@ -1324,9 +1323,7 @@ static long do_mbind(unsigned long start
 		NODEMASK_SCRATCH(scratch);
 		if (scratch) {
 			mmap_write_lock(mm);
-			task_lock(current);
 			err = mpol_set_nodemask(new, nmask, scratch);
-			task_unlock(current);
 			if (err)
 				mmap_write_unlock(mm);
 		} else
_
