Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24011C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE683206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026960;
	bh=EVOuNOt/2GD4wFYs8NUwN1x71sFLTzYP7bFuoyOIaw4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=nE6GGr3RRt0kuqlxHih9KoCJfuLGIwyLFX5+7sG6oRfHY+9/iVe7505/RopqlZo0a
	 o3HO9VXnHyflVwqAq9HVpYj4P1jltOahplutBHsV9SKYLhexFuLJwbvCQ8oVr/TOSI
	 ebBInhS0kcn1WwW7HixmqgkcvOPFOQHV9wUicIYU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgHJCgA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCgA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:00 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B7CF2065D;
        Mon, 10 Aug 2020 02:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026959;
        bh=EVOuNOt/2GD4wFYs8NUwN1x71sFLTzYP7bFuoyOIaw4=;
        h=Date:From:To:Subject:From;
        b=Am9buM8cJILqbPYIA6Q0GGBj2ePrsoCdPc3ywco7qomjM16i7A8pG4mR7/M8r1idp
         FL3zYiQTp4x9T2dqbEc7TdIcb32Mg2PruV1jyN4/8i7cNrkLe1yM8eeFYZ+oEMJxm+
         S5gP12/UMbnsRYX2bVYbpNa1nXUygSybS7IS+iwM=
Date:   Sun, 09 Aug 2020 19:35:59 -0700
From:   akpm@linux-foundation.org
To:     gavin.dg@linux.alibaba.com, hannes@cmpxchg.org,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        yang.shi@linux.alibaba.com
Subject:  [merged] mm-filemap-clear-idle-flag-for-writes.patch
 removed from -mm tree
Message-ID: <20200810023559.ooWFnuApv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: filemap: clear idle flag for writes
has been removed from the -mm tree.  Its filename was
     mm-filemap-clear-idle-flag-for-writes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-thp-remove-debug_cow-switch.patch

