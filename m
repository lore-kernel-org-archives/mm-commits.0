Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 668DEC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BDFB2080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195918;
	bh=T7Tmm8z8t+ocoM26YhmOhdhVWRVA5H+gc57af3leT7o=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=IRhwhCKmcOQ14DwGqKqnk2JcA+We5vAPhnFBgeTpTXEz/reQRfEkxYuDOKnvhi1yz
	 Pbi9WYgqGNRPHqMJx1TxmqnkFyyCdBdHzfLHJ/1PHo8frwoXgSa8+27Nusf6y6S1KB
	 sJohdRWXe0nyLpEPVghsCWSDv9LOJ1LSW+yA2iYE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgHLBb5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgHLBb4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:31:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA0802076C;
        Wed, 12 Aug 2020 01:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195915;
        bh=T7Tmm8z8t+ocoM26YhmOhdhVWRVA5H+gc57af3leT7o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Myn4mVibv2vidXjEnjH0yDLJZeP0z4lMrZ4ZCxFNN1a4ek3mQjWRytfsrJNVIusd2
         jthGXippMYxKXPGDzBlhc0z4qtSlyIPpFtKAyUJWYuSr475rRNfUIwDNomr5Bh+i2K
         8gif2N5y8kk8xLlnZbN/yRpGipviSl78Fy9SEVhA=
Date:   Tue, 11 Aug 2020 18:31:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, jay.xu@rock-chips.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 031/165] mm/cma.c: fix NULL pointer dereference
 when cma could not be activated
Message-ID: <20200812013154.RGm-7uVDJ%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jianqun Xu <jay.xu@rock-chips.com>
Subject: mm/cma.c: fix NULL pointer dereference when cma could not be activated

In some case the cma area could not be activated, but the cma_alloc be
used under this case, then the kernel will crash caused by NULL pointer
dereference.

Add bitmap valid check in cma_alloc to avoid this issue.

Link: http://lkml.kernel.org/r/20200615010123.15596-1-jay.xu@rock-chips.com
Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-fix-null-pointer-dereference-when-cma-could-not-be-activated
+++ a/mm/cma.c
@@ -425,7 +425,7 @@ struct page *cma_alloc(struct cma *cma,
 	struct page *page = NULL;
 	int ret = -ENOMEM;
 
-	if (!cma || !cma->count)
+	if (!cma || !cma->count || !cma->bitmap)
 		return NULL;
 
 	pr_debug("%s(cma %p, count %zu, align %d)\n", __func__, (void *)cma,
_
