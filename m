Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B95C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41B7C22200
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632929;
	bh=pV0iKWeDUNtw/1LML0Opzg6KzB9DFJPmOh5QkG5IfB8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=x/RSeneSFnBJw6u7KrJHqEhkpx5MNM9+ifhl2laSIAbLREdhTkXH+mr2x0CwUdepU
	 yql9HAokAZbzg9mAxccnpqdDGGRC0MJQSbabhWaCuURXkg75mxsIprfeGtrMjmRsgk
	 U6VN8biUxENeEyR2SZiOfOfxc8QtpPv27C8ymXio=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbgJMXst (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbgJMXss (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BEB121D81;
        Tue, 13 Oct 2020 23:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632927;
        bh=pV0iKWeDUNtw/1LML0Opzg6KzB9DFJPmOh5QkG5IfB8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ozKj6mlpwwWFxT3fqnuWpj+F1qO2zsfZf8feO6jE6DKTFJh726ZObGesSa8C/eGVN
         CrC8Pjya7j2MxUrq1XSOSfgkvXPKypTcWRqrHD1RQL0TCXziG7bCd+o8vIOq49lSMn
         7hDQNydVKw3WJoungFcBYx1BwPYNMc0tlCbCeOjc=
Date:   Tue, 13 Oct 2020 16:48:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, liu.xiang6@zte.com.cn,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org,
        wuyun.wu@huawei.com
Subject:  [patch 023/181] mm/slub: make add_full() condition more
 explicit
Message-ID: <20201013234847.01El79qe1%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Abel Wu <wuyun.wu@huawei.com>
Subject: mm/slub: make add_full() condition more explicit

The commit below is incomplete, as it didn't handle the add_full() part. 
commit a4d3f8916c65 ("slub: remove useless kmem_cache_debug() before
remove_full()")

This patch checks for SLAB_STORE_USER instead of kmem_cache_debug(), since
that should be the only context in which we need the list_lock for
add_full().

Link: https://lkml.kernel.org/r/20200811020240.1231-1-wuyun.wu@huawei.com
Signed-off-by: Abel Wu <wuyun.wu@huawei.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Liu Xiang <liu.xiang6@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-make-add_full-condition-more-explicit
+++ a/mm/slub.c
@@ -2245,7 +2245,8 @@ redo:
 		}
 	} else {
 		m = M_FULL;
-		if (kmem_cache_debug(s) && !lock) {
+#ifdef CONFIG_SLUB_DEBUG
+		if ((s->flags & SLAB_STORE_USER) && !lock) {
 			lock = 1;
 			/*
 			 * This also ensures that the scanning of full
@@ -2254,6 +2255,7 @@ redo:
 			 */
 			spin_lock(&n->list_lock);
 		}
+#endif
 	}
 
 	if (l != m) {
_
