Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B167C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00A4E22259
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708987;
	bh=a5jTmDkDzp+fr1aIlbSF/UyDmF1I55lmlTBO2SUMqu4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0lSwTSzJNwmnlI+PUqRBE9oOMtEkao46F2MFYxLJj8iae7Fr/TSx2fhB2YFHtb2s9
	 bapg1xZ1V8miRnqIUlyMRc4G2T4LjmXlJJXbS/4UYep32jGIXqLfARHvJojvSqwUyn
	 AJ0qLls+7JQScO/yYM0gecTT3AwFsLa/ThXlkzPM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388998AbgJNU40 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNU40 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:56:26 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA4B522250;
        Wed, 14 Oct 2020 20:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708986;
        bh=a5jTmDkDzp+fr1aIlbSF/UyDmF1I55lmlTBO2SUMqu4=;
        h=Date:From:To:Subject:From;
        b=gu0Tf1jMi6Bz7BuEUjjjOKEm2x5zlYAPOxwLOXLCpKH9Hz8HFTFHODQshgIhBf459
         v3XUlrFZgSBa6b/Ntx0zj5sdJqNdxvm483cbnX2/nOU1Lk7588CdfhmstZlec/O9rM
         r/TuaTURsHRMuJj+TOSVog6kMh0Pnhl+ml4pVOdg=
Date:   Wed, 14 Oct 2020 13:56:25 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, hewenliang4@huawei.com, hushiyuan@huawei.com,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, wuyun.wu@huawei.com
Subject:  [merged]
 mm-slub-fix-missing-alloc_slowpath-stat-when-bulk-alloc.patch removed from
 -mm tree
Message-ID: <20201014205625.SMZ3TuJJy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: fix missing ALLOC_SLOWPATH stat when bulk alloc
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-missing-alloc_slowpath-stat-when-bulk-alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Abel Wu <wuyun.wu@huawei.com>
Subject: mm/slub: fix missing ALLOC_SLOWPATH stat when bulk alloc

The ALLOC_SLOWPATH statistics is missing in bulk allocation now.  Fix it
by doing statistics in alloc slow path.

Link: http://lkml.kernel.org/r/20200811022427.1363-1-wuyun.wu@huawei.com
Signed-off-by: Abel Wu <wuyun.wu@huawei.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hewenliang <hewenliang4@huawei.com>
Cc: Hu Shiyuan <hushiyuan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-missing-alloc_slowpath-stat-when-bulk-alloc
+++ a/mm/slub.c
@@ -2661,6 +2661,8 @@ static void *___slab_alloc(struct kmem_c
 	void *freelist;
 	struct page *page;
 
+	stat(s, ALLOC_SLOWPATH);
+
 	page = c->page;
 	if (!page) {
 		/*
@@ -2850,7 +2852,6 @@ redo:
 	page = c->page;
 	if (unlikely(!object || !node_match(page, node))) {
 		object = __slab_alloc(s, gfpflags, node, addr, c);
-		stat(s, ALLOC_SLOWPATH);
 	} else {
 		void *next_object = get_freepointer_safe(s, object);
 
_

Patches currently in -mm which might be from wuyun.wu@huawei.com are


