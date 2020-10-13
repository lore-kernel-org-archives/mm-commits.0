Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19457C43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1E28208B3
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633205;
	bh=qpVp/0OIGJrxK5a0RVN5jap1Z1cAf3rg92DMdqS8IuY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Zd3AqGUxuwJsr2twwSwW3hYjwe1vkWguPE7TlSvbmHq6ENc0c1vQ1dxl0a01j4MX7
	 He7u+TNtO4t4skhAGhGry+T8heP23cJilUDreYJj5+Sw2/NhdBqJ3rhCMjif00y5l3
	 iiGz47rBVC6V3cx4i4UAim0khua9B04+OucKsMm0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgJMXxX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730087AbgJMXwh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9B7E221FF;
        Tue, 13 Oct 2020 23:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633157;
        bh=qpVp/0OIGJrxK5a0RVN5jap1Z1cAf3rg92DMdqS8IuY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=u7hD4U1XKXDVGTQNEZF/LZq999Bxdag7uK/yKRkr5PHUkbDpYgUsbsYrSeEclAQKU
         blwRVaIQhUgEVUuFBni54fyl/0HTXmH6fRQGHxk1dEheuNjPsrdeZkdeypm7a0HJzI
         uuMu+L3369SldZmJ5VY5eiVFaFKhPh1gNF/S6OgU=
Date:   Tue, 13 Oct 2020 16:52:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gustavoars@kernel.org,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 078/181] mm: memcontrol: use flex_array_size()
 helper in memcpy()
Message-ID: <20201013235236.Kk1owSNr4%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: mm: memcontrol: use flex_array_size() helper in memcpy()

Make use of the flex_array_size() helper to calculate the size of a
flexible array member within an enclosing structure.

This helper offers defense-in-depth against potential integer overflows,
while at the same time makes it explicitly clear that we are dealing with
a flexible array member.

Also, remove unnecessary braces.

Link: https://lkml.kernel.org/r/ddd60dae2d9aea1ccdd2be66634815c93696125e.1596214831.git.gustavoars@kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-use-flex_array_size-helper-in-memcpy
+++ a/mm/memcontrol.c
@@ -4255,10 +4255,9 @@ static int __mem_cgroup_usage_register_e
 	new->size = size;
 
 	/* Copy thresholds (if any) to new array */
-	if (thresholds->primary) {
-		memcpy(new->entries, thresholds->primary->entries, (size - 1) *
-				sizeof(struct mem_cgroup_threshold));
-	}
+	if (thresholds->primary)
+		memcpy(new->entries, thresholds->primary->entries,
+		       flex_array_size(new, entries, size - 1));
 
 	/* Add new threshold */
 	new->entries[size - 1].eventfd = eventfd;
_
