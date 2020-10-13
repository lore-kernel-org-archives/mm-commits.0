Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B20C43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7637D221FF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632925;
	bh=ZWqsrRLAvjyJLHfAhm5VYkHoyqW9PWHkfxq4EaTFIcw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=CwtMBQkyoURo+ZJinp4Q5gLy4ZmAtbmqUS/md5MBXd/TpTuvfaWHAXf+uQv3XYldc
	 18EfR0nJu1BYIc+vlmnNSfnJcN7o9da9lSWLPAHtszs3Qqzl3wGWi+wcFz9Uj3fnXq
	 vEAyFkXVmmQg+a0VWGOwfJO+blykQpegxCHBdB/Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbgJMXsp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbgJMXsp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FBC122227;
        Tue, 13 Oct 2020 23:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632924;
        bh=ZWqsrRLAvjyJLHfAhm5VYkHoyqW9PWHkfxq4EaTFIcw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FbNdQDMxTns3ZpoLaDvG/D2MegtMjm3QTC26OgZNLu1FS3dz78wSeF0HQCuMfQKXg
         8w5gq5lU+joLDMKZJau8zDmZrj4dyRKQvSVkNTOROM1b0W0QF78egn5ywxRtbZSyAs
         3kpc/A6fs+X+cO5ByA2q58Bj/YPdheM9A7egMS1w=
Date:   Tue, 13 Oct 2020 16:48:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, hewenliang4@huawei.com,
        hushiyuan@huawei.com, iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org,
        wuyun.wu@huawei.com
Subject:  [patch 022/181] mm/slub: fix missing ALLOC_SLOWPATH stat
 when bulk alloc
Message-ID: <20201013234843.Wq-xPj29u%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
