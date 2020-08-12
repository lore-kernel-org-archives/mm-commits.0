Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721AAC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50883206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195978;
	bh=Xj9Q/HIMUqJCFvJGqFW1G29lkaEJWJgQtL+7RcWodk8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0jmr6loj6MfI0grX6mSVlZOKOckR6zd/VD/1XOFBZsDVxs5OO1jinqWqwwLOvVuz8
	 Pfy5n8sbAF7VmvCbuWBtyGLS82VozDMfItVytsuMqFQoW8aN8hkwbIL0S+6EHbIMHw
	 ZxuMcC574AGCrqyehQt3yGafI3ZOQzo+u/144TSQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHLBc6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBc5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:32:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B54B3207DA;
        Wed, 12 Aug 2020 01:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195977;
        bh=Xj9Q/HIMUqJCFvJGqFW1G29lkaEJWJgQtL+7RcWodk8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=g24dHfQQTw/WXE1V+P04/CRsg+mCxELCsyNvprRTpuzcH6ac0LqPk3ICoThp/HAyW
         sRj4PNF7Q8tO17HBETKAbStpMzi5rFWDLJTVLndZdrGCShsTuXNSd4nD7cNfUXqB0B
         upGcnhZDQRp8rvSpWQAbx4/R7WpEinmyNjxtkOwk=
Date:   Tue, 11 Aug 2020 18:32:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 050/165] mm/hmm.c: delete duplicated word
Message-ID: <20200812013256.Nes9OJPOc%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/hmm.c: delete duplicated word

Drop the repeated word "pages".

Link: http://lkml.kernel.org/r/20200801173822.14973-4-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hmm.c~mm-hmmc-delete-duplicated-word
+++ a/mm/hmm.c
@@ -249,7 +249,7 @@ static int hmm_vma_handle_pte(struct mm_
 		swp_entry_t entry = pte_to_swp_entry(pte);
 
 		/*
-		 * Never fault in device private pages pages, but just report
+		 * Never fault in device private pages, but just report
 		 * the PFN even if not present.
 		 */
 		if (hmm_is_device_private_entry(range, entry)) {
_
