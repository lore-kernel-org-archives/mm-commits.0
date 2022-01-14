Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF7EBC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiANWFu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:05:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47336 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiANWFu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:05:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC58462001
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080A3C36AE9;
        Fri, 14 Jan 2022 22:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197949;
        bh=nzmXekE0bXlfnawVvQP/czFiiwQFPyO2nhpHEMNdO+Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oMuIx1oAYAWJvA+cjZNp7XEeemlU6Rq19G63ka4jbIcL5prBkXz+I4dJBl541j25K
         27N05x7AN4TRtxCP0J0V4gSiYr98XPVS5Z16kSPkR2ozcBoPwA4ksSV9E7LtxXKRxp
         nh6TyGhH/tYwESNW9x9c7GWV7Ka8AnFAPxir1/uA=
Date:   Fri, 14 Jan 2022 14:05:48 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chi.minghao@zte.com.cn,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, zealci@zte.com.cn
Subject:  [patch 054/146] tools/testing/selftests/vm/userfaultfd.c:
 use swap() to make code cleaner
Message-ID: <20220114220548.cmlrzhxJX%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: chiminghao <chi.minghao@zte.com.cn>
Subject: tools/testing/selftests/vm/userfaultfd.c: use swap() to make code cleaner

Fix the following coccicheck REVIEW:
./tools/testing/selftests/vm/userfaultfd.c:1531:21-22:use swap() to make
code cleaner

Link: https://lkml.kernel.org/r/20211124031632.35317-1-chi.minghao@zte.com.cn
Signed-off-by: chiminghao <chi.minghao@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~selftests-vm-use-swap-to-make-code-cleaner
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -1417,7 +1417,6 @@ static void userfaultfd_pagemap_test(uns
 static int userfaultfd_stress(void)
 {
 	void *area;
-	char *tmp_area;
 	unsigned long nr;
 	struct uffdio_register uffdio_register;
 	struct uffd_stats uffd_stats[nr_cpus];
@@ -1528,13 +1527,9 @@ static int userfaultfd_stress(void)
 					    count_verify[nr], nr);
 
 		/* prepare next bounce */
-		tmp_area = area_src;
-		area_src = area_dst;
-		area_dst = tmp_area;
-
-		tmp_area = area_src_alias;
-		area_src_alias = area_dst_alias;
-		area_dst_alias = tmp_area;
+		swap(area_src, area_dst);
+
+		swap(area_src_alias, area_dst_alias);
 
 		uffd_stats_report(uffd_stats, nr_cpus);
 	}
_
