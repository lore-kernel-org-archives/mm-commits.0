Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B098FC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89BB020855
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597809416;
	bh=c/bmIZp3As7BOUxR5aQAkxIAgC4+K2lChGzOcFywSiU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GfEfgFiRznYSjHFzpqHjK1X3BWP6IPtinNPj71FwiKcX8j/NktoL3AoKOdCDv3i8w
	 ZHwSvcWfpFMpVwRNbPt2tZxg4DeMu/ai3L8CkfFh8+rKVQm+rzV8hlmPuDY0HWOgsl
	 dQ6OB5MsJLFgKq+hfnbj9ESKsDvrW1BpQfXbietM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgHSD44 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 23:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbgHSD4z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 23:56:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9C64207BB;
        Wed, 19 Aug 2020 03:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597809415;
        bh=c/bmIZp3As7BOUxR5aQAkxIAgC4+K2lChGzOcFywSiU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZvWOfKdK9ZaXDk+Q0YDs9DnfOwlo1DDz/Hk7dAbj7qT3CKMprurBBNfisTy9p4cfE
         KPTbSXIq3RgaI0AHQ92v7ihY6OgXdC+mpUgFMnVratFrb2MYMGoR87wZV88IMDu58s
         rTLEkyxL1XZK6gbs3F5dmwi4VrdOW2syXlue4YNc=
Date:   Tue, 18 Aug 2020 20:56:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cl@linux.com, hewenliang4@huawei.com, hushiyuan@huawei.com,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, wuyun.wu@huawei.com
Subject:  +
 mm-slub-fix-missing-alloc_slowpath-stat-when-bulk-alloc.patch added to -mm
 tree
Message-ID: <20200819035654.pqJKV762j%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: fix missing ALLOC_SLOWPATH stat when bulk alloc
has been added to the -mm tree.  Its filename is
     mm-slub-fix-missing-alloc_slowpath-stat-when-bulk-alloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-missing-alloc_slowpath-stat-when-bulk-alloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-missing-alloc_slowpath-stat-when-bulk-alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2666,6 +2666,8 @@ static void *___slab_alloc(struct kmem_c
 	void *freelist;
 	struct page *page;
 
+	stat(s, ALLOC_SLOWPATH);
+
 	page = c->page;
 	if (!page) {
 		/*
@@ -2855,7 +2857,6 @@ redo:
 	page = c->page;
 	if (unlikely(!object || !node_match(page, node))) {
 		object = __slab_alloc(s, gfpflags, node, addr, c);
-		stat(s, ALLOC_SLOWPATH);
 	} else {
 		void *next_object = get_freepointer_safe(s, object);
 
_

Patches currently in -mm which might be from wuyun.wu@huawei.com are

mm-slub-branch-optimization-in-free-slowpath.patch
mm-slub-fix-missing-alloc_slowpath-stat-when-bulk-alloc.patch

