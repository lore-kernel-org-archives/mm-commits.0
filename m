Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F61C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0250C2177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781197;
	bh=2ygTrxq33L8OrQfhcyX0bwMi+QHMXvPJRyccVxwO+Yw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=zq/S3XTSU5JRY7dGjttP9gfA9cL0KzZnCs5lNc2Hjg+5dR7+gvATRGzOUUvZYnn4m
	 ToFVpB98teLSvFGByGAPsDANfgeu6mIfnRheojV6LdGoT/DA459V4NGjcQ2dBuDWPK
	 7Am2gKDL7gKtdDXDEBckR7c2F2uVkyig4sjO70Dk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgHGGT4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGT4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:19:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 925D122D03;
        Fri,  7 Aug 2020 06:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781195;
        bh=2ygTrxq33L8OrQfhcyX0bwMi+QHMXvPJRyccVxwO+Yw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R8F3PuCYNZ4dM/XJ9J5DjA79RtMlYGlplQDmiXXNt6BR6QIM/iLzFqtnYjvMs9ABt
         wjb+IOWCz8zeSdopKiMydNEc+Z7mF7rfm5KT7qY4uFYlk4u0pZq/2Xs+v0d4/rr0C6
         SEU7Ij8CRpvs1StWOvYEyiy4bNaNg/5HlLL+C2N8=
Date:   Thu, 06 Aug 2020 23:19:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gavin.dg@linux.alibaba.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        riel@surriel.com, shakeelb@google.com,
        torvalds@linux-foundation.org, yang.shi@linux.alibaba.com
Subject:  [patch 051/163] mm: filemap: clear idle flag for writes
Message-ID: <20200807061955.ErOcFZbpk%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: filemap: clear idle flag for writes

Since commit bbddabe2e436aa ("mm: filemap: only do access activations on
reads"), mark_page_accessed() is called for reads only.  But the idle flag
is cleared by mark_page_accessed() so the idle flag won't get cleared if
the page is write accessed only.

Basically idle page tracking is used to estimate workingset size of
workload, noticeable size of workingset might be missed if the idle flag
is not maintained correctly.

It seems good enough to just clear idle flag for write operations.

Link: http://lkml.kernel.org/r/1593020612-13051-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: bbddabe2e436 ("mm: filemap: only do access activations on reads")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reported-by: Gang Deng <gavin.dg@linux.alibaba.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/filemap.c~mm-filemap-clear-idle-flag-for-writes
+++ a/mm/filemap.c
@@ -41,6 +41,7 @@
 #include <linux/delayacct.h>
 #include <linux/psi.h>
 #include <linux/ramfs.h>
+#include <linux/page_idle.h>
 #include "internal.h"
 
 #define CREATE_TRACE_POINTS
@@ -1689,6 +1690,11 @@ repeat:
 
 	if (fgp_flags & FGP_ACCESSED)
 		mark_page_accessed(page);
+	else if (fgp_flags & FGP_WRITE) {
+		/* Clear idle flag for buffer write */
+		if (page_is_idle(page))
+			clear_page_idle(page);
+	}
 
 no_page:
 	if (!page && (fgp_flags & FGP_CREAT)) {
_
