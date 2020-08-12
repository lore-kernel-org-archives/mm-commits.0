Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9587C433E3
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB62920B1F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266133;
	bh=tpmdgrSgBDHlMA1QcwYsoP0Zkgyq7ZEG5ra2FbcrSKc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=A4Is9ibtjEaXf2j+OY/USqMG3PBnSHG+GORmL/nZP2m0G1/i/PZ/2HT78562IHfvm
	 rnE78sqDm3nz0lVC/dq9rS5qLj1MbGJr5uWhXCxnyXff4ZuAFZ/RSR7SXmdJgTxBJp
	 IjVRI0E9lau9N0L/rJSvq0/Cv9jXzHqmAW5tK0H0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgHLVCN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgHLVCM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:12 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7858D20866;
        Wed, 12 Aug 2020 21:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266132;
        bh=tpmdgrSgBDHlMA1QcwYsoP0Zkgyq7ZEG5ra2FbcrSKc=;
        h=Date:From:To:Subject:From;
        b=hkvECJ/m9D8EIUFcBND15GZNWrQdUh5ZRK+FTv8GbFg8zKAPnZFkG+4QkZP5dtPnv
         osYdROr/jZq3MmeHT+tDZB9/QMrOesb5Ba6p1fG0+iaFjFaRrZjAfno7wSa9qIoQhL
         zDjTmSpH+ed32gQtXsFcaQtOF39d/uq2bVJPz15c=
Date:   Wed, 12 Aug 2020 14:02:12 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, jay.xu@rock-chips.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-cma-fix-null-pointer-dereference-when-cma-could-not-be-activated.patch
 removed from -mm tree
Message-ID: <20200812210212._oKeYTIzG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma.c: fix NULL pointer dereference when cma could not be activated
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-null-pointer-dereference-when-cma-could-not-be-activated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from jay.xu@rock-chips.com are


