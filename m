Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1BACC43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 669C021D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633293;
	bh=OpTaj1+tFL/G2iGMfxB4sRLL47HFTs8WonyJj6Q5pM0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=b0xvdDLWYFIoxq8T3wcKmTsU+MWdQksz3js8K+gW+t3J3eQOddCQxL7Pgyp7EWa6u
	 nur24LBOeja99AD5X0uHiUL1Pq38twx8yediBFv1Atm5RcRWrTC1ofhr91sRPbqGsy
	 /Yz6NoepsTVj66ZNFWFMetLdxETeOScOov2lAbsQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388174AbgJMXyx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXyw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57C7F206D5;
        Tue, 13 Oct 2020 23:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633292;
        bh=OpTaj1+tFL/G2iGMfxB4sRLL47HFTs8WonyJj6Q5pM0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BA2uUf2ZVWa51Xl1Oo2XstsFqqT/aADDcfRopwdK8Vk+sENkX00W5umQ31DQdst8o
         p1GEENR1BJ9EDQUQ8xIU7tTLV+ON547svxwltmUtjco8HiDCxqiJGcYjh3bkrHiWrg
         QwVlkb7DdhxgJ2zBVIlcZi6x6f06j5rZZofagGN0=
Date:   Tue, 13 Oct 2020 16:54:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sh_def@163.com,
        torvalds@linux-foundation.org
Subject:  [patch 118/181] mm/vmalloc.c: fix the comment of
 find_vm_area
Message-ID: <20201013235451.acZxgxSdm%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hui Su <sh_def@163.com>
Subject: mm/vmalloc.c: fix the comment of find_vm_area

Fix the comment of find_vm_area() and get_vm_area()

Link: https://lkml.kernel.org/r/20200927153034.GA199877@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-fix-the-comment-of-find_vm_area
+++ a/mm/vmalloc.c
@@ -2133,7 +2133,7 @@ struct vm_struct *get_vm_area_caller(uns
  * It is up to the caller to do all required locking to keep the returned
  * pointer valid.
  *
- * Return: pointer to the found area or %NULL on faulure
+ * Return: the area descriptor on success or %NULL on failure.
  */
 struct vm_struct *find_vm_area(const void *addr)
 {
@@ -2154,7 +2154,7 @@ struct vm_struct *find_vm_area(const voi
  * This function returns the found VM area, but using it is NOT safe
  * on SMP machines, except for its size or flags.
  *
- * Return: pointer to the found area or %NULL on faulure
+ * Return: the area descriptor on success or %NULL on failure.
  */
 struct vm_struct *remove_vm_area(const void *addr)
 {
_
